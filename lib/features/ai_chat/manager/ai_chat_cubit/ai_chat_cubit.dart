import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:egy_go/features/ai_chat/data/models/ai_message_model.dart';
import 'package:egy_go/features/ai_chat/data/repos/ai_chat_repo.dart';
import 'ai_chat_state.dart';

class AiChatCubit extends Cubit<AiChatState> {
  AiChatCubit(this.aiChatRepo) : super(AiChatInitial());

  final AiChatRepo aiChatRepo;
  final List<AiMessageModel> _messages = [];
  String? _lastFailedMessage;

  List<AiMessageModel> get messages => _messages;

  void initializeChat() {
    // Add welcome message from Nefertiti
    _messages.clear();
    _messages.add(
      AiMessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message:
            'Hello! I\'m Nefertiti, your smart tour guide in Egypt. How can I help you today?',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
    emit(AiChatLoaded(List.from(_messages)));
  }

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    _lastFailedMessage = message; // Store for potential retry

    // Add user message
    final userMessage = AiMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: message,
      isUser: true,
      timestamp: DateTime.now(),
    );

    _messages.add(userMessage);
    emit(AiChatLoading(List.from(_messages)));

    // Get conversation history (exclude the welcome message and current user message)
    final conversationHistory =
        _messages.where((msg) => msg != userMessage).toList();

    // Send to AI backend with history
    final result = await aiChatRepo.sendMessage(message, conversationHistory);

    result.fold(
      (error) {
        // Keep the failed message for retry
        emit(AiChatError(error, List.from(_messages), _lastFailedMessage));
      },
      (response) {
        print(
            '[AiChatCubit] Got response from ${response.source}: ${response.reply}');
        print('[AiChatCubit] Places count: ${response.places?.length ?? 0}');

        // Add AI response with places
        _messages.add(
          AiMessageModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            message: response.reply,
            isUser: false,
            timestamp: DateTime.now(),
            places: response.places,
          ),
        );
        _lastFailedMessage = null; // Clear on success
        emit(AiChatLoaded(List.from(_messages)));
      },
    );
  }

  Future<void> retryLastMessage() async {
    if (_lastFailedMessage != null) {
      final messageToRetry = _lastFailedMessage!;
      _lastFailedMessage = null;

      // Get conversation history
      final conversationHistory = _messages
          .where((msg) => !msg.isUser || msg.message != messageToRetry)
          .toList();

      // Retry sending
      emit(AiChatLoading(List.from(_messages)));
      final result =
          await aiChatRepo.sendMessage(messageToRetry, conversationHistory);

      result.fold(
        (error) {
          _lastFailedMessage = messageToRetry; // Store again for retry
          emit(AiChatError(error, List.from(_messages), _lastFailedMessage));
        },
        (response) {
          print('[AiChatCubit] Retry - Got response: ${response.reply}');

          // Add AI response with places
          _messages.add(
            AiMessageModel(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              message: response.reply,
              isUser: false,
              timestamp: DateTime.now(),
              places: response.places,
            ),
          );
          emit(AiChatLoaded(List.from(_messages)));
        },
      );
    }
  }

  Future<void> getPlaceDetails(String placeId) async {
    // Don't change the chat state, just fetch the place details
    final result = await aiChatRepo.getPlaceDetails(placeId);

    return result.fold(
      (error) {
        print('[AiChatCubit] Error fetching place details: $error');
        throw Exception(error);
      },
      (placeDetails) {
        print('[AiChatCubit] Successfully fetched place: ${placeDetails.name}');
        return placeDetails;
      },
    );
  }

  void clearChat() {
    _messages.clear();
    initializeChat();
  }
}
