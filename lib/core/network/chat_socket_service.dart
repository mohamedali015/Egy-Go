import 'package:egy_go/core/cache/cache_helper.dart';
import 'package:egy_go/core/cache/cache_key.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

/// Socket.io Service for Trip Chat
/// Handles real-time messaging between tourist and guide
class ChatSocketService {
  IO.Socket? _socket;
  bool _isConnected = false;
  String? _currentTripId;

  bool get isConnected => _isConnected;

  String? get currentTripId => _currentTripId;

  /// Get socket base URL
  String get _socketUrl {
    const baseUrl = 'https://1p1jgw5z-5001.euw.devtunnels.ms';
    return baseUrl;
  }

  /// Connect to socket server with JWT authentication
  Future<void> connect() async {
    if (_socket != null && _isConnected) {
      print('[ChatSocketService] Already connected');
      return;
    }

    try {
      final token = CacheHelper.getData(key: CacheKeys.accessToken);
      if (token == null) {
        print('[ChatSocketService] ❌ No auth token found');
        throw Exception('Authentication required');
      }

      print('[ChatSocketService] 🔌 Connecting to: $_socketUrl');

      _socket = IO.io(
        _socketUrl,
        IO.OptionBuilder()
            .setTransports(['websocket', 'polling'])
            .enableAutoConnect()
            .enableForceNew()
            .setAuth({'token': token})
            .build(),
      );

      _socket!.onConnect((_) {
        _isConnected = true;
        print('[ChatSocketService] ✅ Connected - Socket ID: ${_socket!.id}');
      });

      _socket!.onDisconnect((_) {
        _isConnected = false;
        _currentTripId = null;
        print('[ChatSocketService] ❌ Disconnected from server');
      });

      _socket!.onConnectError((error) {
        _isConnected = false;
        print('[ChatSocketService] ❌ Connection error: $error');
      });

      _socket!.onError((error) {
        print('[ChatSocketService] ⚠️ Socket error: $error');
      });

      // Wait for connection
      int retries = 0;
      while (!_isConnected && retries < 20) {
        await Future.delayed(Duration(milliseconds: 500));
        retries++;
      }

      if (!_isConnected) {
        throw Exception('Failed to connect to chat server');
      }
    } catch (e) {
      print('[ChatSocketService] ❌ Failed to initialize socket: $e');
      rethrow;
    }
  }

  /// Join trip chat room
  Future<void> joinTripChat(String tripId) async {
    if (_socket == null || !_isConnected) {
      throw Exception('Socket not connected');
    }

    if (_currentTripId == tripId) {
      print('[ChatSocketService] ℹ️ Already in chat room: $tripId');
      return;
    }

    // Leave previous room if exists
    if (_currentTripId != null) {
      await leaveTripChat();
    }

    print('[ChatSocketService] 🚪 Joining trip chat: $tripId');
    _socket!.emit('join_trip_chat', {'tripId': tripId});
    _currentTripId = tripId;

    // Wait a bit for join confirmation
    await Future.delayed(Duration(milliseconds: 500));
  }

  /// Leave trip chat room
  Future<void> leaveTripChat() async {
    if (_socket == null || _currentTripId == null) {
      return;
    }

    print('[ChatSocketService] 🚪 Leaving trip chat: $_currentTripId');
    _socket!.emit('leave_trip_chat', {'tripId': _currentTripId});
    _currentTripId = null;
  }

  /// Send a message
  void sendMessage(String tripId, String message) {
    if (_socket == null || !_isConnected) {
      throw Exception('Socket not connected');
    }

    print('[ChatSocketService] 📤 Sending message to trip: $tripId');
    _socket!.emit('send_message', {
      'tripId': tripId,
      'message': message,
    });
  }

  /// Listen for new messages
  void onNewMessage(Function(Map<String, dynamic>) callback) {
    if (_socket == null) return;

    _socket!.on('new_message', (data) {
      print('[ChatSocketService] 📨 New message received: $data');
      if (data is Map<String, dynamic>) {
        callback(data);
      }
    });
  }

  /// Listen for chat errors
  void onChatError(Function(String) callback) {
    if (_socket == null) return;

    _socket!.on('chat_error', (data) {
      print('[ChatSocketService] ❌ Chat error: $data');
      final errorMessage =
          data is Map ? data['message'] ?? 'Chat error' : 'Chat error';
      callback(errorMessage.toString());
    });
  }

  /// Disconnect from socket
  Future<void> disconnect() async {
    if (_currentTripId != null) {
      await leaveTripChat();
    }

    if (_socket != null) {
      print('[ChatSocketService] 🔌 Disconnecting socket');
      _socket!.dispose();
      _socket = null;
      _isConnected = false;
    }
  }
}
