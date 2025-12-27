import 'package:egy_go/core/cache/cache_helper.dart';
import 'package:egy_go/core/cache/cache_key.dart';
import 'package:egy_go/core/network/chat_socket_service.dart';
import 'package:egy_go/features/trip/data/models/chat_message_model.dart';
import 'package:egy_go/features/trip/data/repos/chat_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'trip_chat_state.dart';

class TripChatCubit extends Cubit<TripChatState> {
  TripChatCubit(this.chatRepo) : super(TripChatInitial());

  final ChatRepo chatRepo;
  final ChatSocketService _chatSocketService = ChatSocketService();

  List<ChatMessageModel> _messages = [];
  String? _currentUserId;
  bool _isSocketInitialized = false;

  List<ChatMessageModel> get messages => _messages;

  bool get isSocketConnected => _chatSocketService.isConnected;

  /// Initialize chat for a trip
  Future<void> initializeChat(String tripId) async {
    emit(ChatAccessChecking());

    // Get current user ID from token payload
    _currentUserId = _getUserIdFromToken();

    // Step 1: Check chat access
    final accessResult = await chatRepo.checkChatAccess(tripId);

    accessResult.fold(
      (error) {
        emit(ChatAccessDenied(error));
      },
      (accessResponse) async {
        print(
            '[TripChatCubit] 📋 Access response: success=${accessResponse.success}, hasAccess=${accessResponse.hasAccess}');

        if (accessResponse.hasAccess != true) {
          print(
              '[TripChatCubit] ❌ Access denied - hasAccess is: ${accessResponse.hasAccess}');
          emit(ChatAccessDenied(
              accessResponse.message ?? 'You do not have access to this chat'));
          return;
        }

        print('[TripChatCubit] ✅ Access granted!');
        emit(ChatAccessGranted());

        // Step 2: Load message history
        emit(TripChatLoading());
        final messagesResult = await chatRepo.getChatMessages(tripId);

        messagesResult.fold(
          (error) {
            _messages = [];
            emit(ChatError(error, _messages));
          },
          (messagesResponse) async {
            _messages = messagesResponse.messages ?? [];
            print(
                '[TripChatCubit] 📨 Loaded ${_messages.length} messages from history');

            // Print first message for debugging if available
            if (_messages.isNotEmpty) {
              final firstMsg = _messages.first;
              print(
                  '[TripChatCubit] - First message: senderId=${firstMsg.senderId}, message=${firstMsg.message}');
            }

            emit(ChatMessagesLoaded(_messages));

            // Step 3: Initialize socket connection
            await _initializeSocket(tripId);
          },
        );
      },
    );
  }

  /// Extract user ID from JWT token
  String? _getUserIdFromToken() {
    try {
      final token = CacheHelper.getData(key: CacheKeys.accessToken);
      if (token == null) return null;

      // Decode JWT token to get user ID
      final parts = token.toString().split('.');
      if (parts.length != 3) return null;

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final payloadMap = json.decode(decoded);

      return payloadMap['userId'] ?? payloadMap['id'] ?? payloadMap['sub'];
    } catch (e) {
      print('[TripChatCubit] Error extracting user ID: $e');
      return null;
    }
  }

  /// Initialize socket connection and listeners
  Future<void> _initializeSocket(String tripId) async {
    if (_isSocketInitialized) {
      print('[TripChatCubit] Socket already initialized');
      return;
    }

    try {
      print('[TripChatCubit] 🚀 Initializing chat socket for trip: $tripId');

      // Connect to socket
      await _chatSocketService.connect();

      // Join trip chat room
      await _chatSocketService.joinTripChat(tripId);

      // Set up listeners
      _chatSocketService.onNewMessage((data) {
        _handleNewMessage(data);
      });

      _chatSocketService.onChatError((error) {
        _handleChatError(error);
      });

      _isSocketInitialized = true;
      print('[TripChatCubit] ✅ Socket initialized successfully');

      // Emit updated state to trigger UI rebuild with socket connected
      emit(ChatMessagesUpdated(List.from(_messages)));
    } catch (e) {
      print('[TripChatCubit] ❌ Socket initialization failed: $e');
      emit(ChatSocketDisconnected(_messages));
    }
  }

  /// Handle incoming message from socket
  void _handleNewMessage(Map<String, dynamic> data) {
    try {
      print('[TripChatCubit] 📨 Handling new message: $data');

      // Parse message data
      final messageData = data['data'] ?? data;
      final message = ChatMessageModel.fromJson(messageData);

      // Check if message already exists (avoid duplicates)
      final messageExists = _messages.any((m) => m.id == message.id);
      if (messageExists) {
        print('[TripChatCubit] ℹ️ Message already exists, skipping');
        return;
      }

      // Add message to list
      _messages.add(message);

      print(
          '[TripChatCubit] ✅ Message added. Total messages: ${_messages.length}');

      // Emit updated state with a new list instance to ensure rebuild
      emit(ChatMessagesUpdated(List.from(_messages)));
    } catch (e) {
      print('[TripChatCubit] ❌ Error parsing message: $e');
      print('[TripChatCubit] ❌ Raw data: $data');
    }
  }

  /// Handle chat error from socket
  void _handleChatError(String error) {
    print('[TripChatCubit] ❌ Chat error: $error');
    emit(ChatError(error, _messages));
  }

  /// Send a message
  Future<void> sendMessage(String tripId, String message) async {
    // Validate message
    final trimmedMessage = message.trim();
    if (trimmedMessage.isEmpty) {
      emit(ChatError('Message cannot be empty', _messages));
      return;
    }

    if (trimmedMessage.length > 5000) {
      emit(ChatError('Message is too long (max 5000 characters)', _messages));
      return;
    }

    if (!_chatSocketService.isConnected) {
      emit(ChatError('Chat is not connected. Please try again.', _messages));
      return;
    }

    try {
      // Show sending state
      emit(ChatMessageSending(_messages));

      // Send message via socket
      _chatSocketService.sendMessage(tripId, trimmedMessage);

      // Revert to normal state (message will be added when we receive new_message event)
      emit(ChatMessagesUpdated(_messages));
    } catch (e) {
      print('[TripChatCubit] ❌ Error sending message: $e');
      emit(ChatError('Failed to send message: ${e.toString()}', _messages));
    }
  }

  /// Check if message was sent by current user
  bool isMyMessage(ChatMessageModel message) {
    return message.senderId == _currentUserId;
  }

  /// Dispose and cleanup
  Future<void> dispose() async {
    print('[TripChatCubit] 🧹 Disposing chat cubit');
    await _chatSocketService.disconnect();
    _isSocketInitialized = false;
  }

  @override
  Future<void> close() async {
    await dispose();
    return super.close();
  }
}
