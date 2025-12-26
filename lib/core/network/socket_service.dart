import 'package:egy_go/core/cache/cache_helper.dart';
import 'package:egy_go/core/cache/cache_key.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

/// Socket.io Service for real-time trip status updates
/// STRICTLY follows backend contract - DO NOT modify events or room names
class SocketService {
  IO.Socket? _socket;
  bool _isConnected = false;
  String? _currentTripId;
  bool _isJoinedToRoom = false;

  bool get isConnected => _isConnected;

  String? get currentTripId => _currentTripId;

  bool get isJoinedToRoom => _isJoinedToRoom;

  /// Get socket base URL from API base URL
  String get _socketUrl {
    const baseUrl = 'https://1p1jgw5z-5001.euw.devtunnels.ms';
    // NOTE: If you get "Failed host lookup" error, the DevTunnel has expired.
    // Ask your backend team for the new tunnel URL and update it here.
    return baseUrl;
  }

  /// Initialize socket connection with JWT auth
  /// Opens socket ONLY when Trip Details screen is mounted
  Future<void> connect() async {
    if (_socket != null && _isConnected) {
      print('[SocketService] Already connected');
      return;
    }

    try {
      final token = CacheHelper.getData(key: CacheKeys.accessToken);
      if (token == null) {
        print('[SocketService] ❌ No auth token found');
        return;
      }

      print('[SocketService] 🔌 Connecting to: $_socketUrl');
      print(
          '[SocketService] 🔑 Using token: ${token.toString().substring(0, 20)}...');

      _socket = IO.io(
        _socketUrl,
        IO.OptionBuilder()
            .setTransports(['websocket', 'polling'])
            .enableAutoConnect()
            .enableForceNew()
            .setAuth({
              'token': token,
            })
            .build(),
      );

      _socket!.onConnect((_) {
        _isConnected = true;
        print(
            '[SocketService] ✅ Connected successfully - Socket ID: ${_socket!.id}');
      });

      _socket!.onDisconnect((_) {
        _isConnected = false;
        _currentTripId = null;
        _isJoinedToRoom = false;
        print('[SocketService] ❌ Disconnected from server');
      });

      _socket!.onConnectError((error) {
        _isConnected = false;
        print('[SocketService] ❌ Connection error: $error');
      });

      _socket!.onError((error) {
        print('[SocketService] ⚠️ Socket error: $error');
      });

      // Add debug listeners for all events
      _socket!.onAny((event, data) {
        print('[SocketService] 📡 Event received: $event with data: $data');
      });

      // Listen for room join confirmation
      _socket!.on('trip_room_joined', (data) {
        print('[SocketService] ✅ Room join confirmed: $data');
        _isJoinedToRoom = true;
      });

      _socket!.on('trip_room_left', (data) {
        print('[SocketService] ✅ Room leave confirmed: $data');
        _isJoinedToRoom = false;
      });

      // Add listeners for all possible status update event variations
      // In case backend uses different event names
      _socket!.on('tripStatusUpdated', (data) {
        print(
            '[SocketService] 🔔 Received tripStatusUpdated (camelCase): $data');
      });

      _socket!.on('status_updated', (data) {
        print('[SocketService] 🔔 Received status_updated: $data');
      });

      _socket!.on('trip_updated', (data) {
        print('[SocketService] 🔔 Received trip_updated: $data');
      });

      _socket!.on('error', (data) {
        print('[SocketService] ❌ Error event: $data');
      });

      _socket!.on('message', (data) {
        print('[SocketService] 📨 Message event: $data');
      });
    } catch (e) {
      print('[SocketService] ❌ Failed to initialize socket: $e');
    }
  }

  /// Join trip room after successful connection
  /// Room identifier: "trip:{tripId}" - DO NOT change this format
  Future<void> joinTripRoom(String tripId) async {
    if (_socket == null) {
      print('[SocketService] ❌ Cannot join room - socket not initialized');
      return;
    }

    // Wait for connection to be established
    int retries = 0;
    while (!_isConnected && retries < 20) {
      print('[SocketService] ⏳ Waiting for connection... (${retries + 1}/20)');
      await Future.delayed(Duration(milliseconds: 500));
      retries++;
    }

    if (!_isConnected) {
      print('[SocketService] ❌ Cannot join room - not connected after waiting');
      return;
    }

    if (_currentTripId == tripId) {
      print('[SocketService] ℹ️ Already in trip room: $tripId');
      return;
    }

    // Leave previous room if exists
    if (_currentTripId != null) {
      await leaveTripRoom();
    }

    final roomId = 'trip:$tripId';
    print('[SocketService] 🚪 Joining room: $roomId');
    print(
        '[SocketService] 📤 Emitting join_trip_room event with tripId: $tripId');
    print('[SocketService] 📤 Socket ID: ${_socket!.id}');

    _socket!.emit('join_trip_room', {'tripId': tripId});
    _currentTripId = tripId;
    _isJoinedToRoom = false; // Will be set to true when confirmation arrives

    // Wait a bit for join confirmation
    await Future.delayed(Duration(milliseconds: 1000));

    print('[SocketService] ✅ Room join request sent for: $roomId');
    print('[SocketService] ℹ️ Join confirmed: $_isJoinedToRoom');
  }

  /// Leave trip room before socket disconnect
  Future<void> leaveTripRoom() async {
    if (_socket == null || _currentTripId == null) {
      return;
    }

    print('[SocketService] 🚪 Leaving room: trip:$_currentTripId');
    _socket!.emit('leave_trip_room', {'tripId': _currentTripId});
    _currentTripId = null;
    _isJoinedToRoom = false;
  }

  /// Listen to trip_status_updated event
  /// Payload: {tripId: string, status: string}
  /// MUST be called BEFORE joining room
  void onTripStatusUpdated(Function(Map<String, dynamic>) callback) {
    if (_socket == null) {
      print('[SocketService] ❌ Cannot listen - socket not initialized');
      return;
    }

    print('[SocketService] 👂 Setting up listener for trip_status_updated');

    // Remove any existing listeners first
    _socket!.off('trip_status_updated');

    _socket!.on('trip_status_updated', (data) {
      print(
          '[SocketService] 🔔🔔🔔 RECEIVED trip_status_updated EVENT! 🔔🔔🔔');
      print('[SocketService] 📦 Raw data: $data');
      print('[SocketService] 📦 Data type: ${data.runtimeType}');

      try {
        if (data is Map<String, dynamic>) {
          print('[SocketService] ✅ Valid data format - calling callback');
          print('[SocketService] 📋 TripId: ${data['tripId']}');
          print('[SocketService] 📋 Status: ${data['status']}');
          callback(data);
        } else if (data is List && data.isNotEmpty) {
          print('[SocketService] ✅ Data is list - extracting first element');
          final firstElement = data[0];
          if (firstElement is Map<String, dynamic>) {
            print('[SocketService] 📋 TripId: ${firstElement['tripId']}');
            print('[SocketService] 📋 Status: ${firstElement['status']}');
            callback(firstElement);
          } else {
            print(
                '[SocketService] ⚠️ First element is not a Map: ${firstElement.runtimeType}');
          }
        } else {
          print('[SocketService] ⚠️ Invalid data format: $data');
        }
      } catch (e) {
        print('[SocketService] ❌ Error processing event: $e');
      }
    });

    print('[SocketService] ✅ Listener registered successfully');
  }

  /// Remove listener for trip_status_updated
  void offTripStatusUpdated() {
    _socket?.off('trip_status_updated');
  }

  /// Disconnect socket immediately when screen is disposed
  void disconnect() {
    if (_socket == null) {
      return;
    }

    print('[SocketService] Disconnecting socket');

    // Leave room before disconnect
    if (_currentTripId != null) {
      leaveTripRoom();
    }

    _socket!.disconnect();
    _socket!.dispose();
    _socket = null;
    _isConnected = false;
    _currentTripId = null;
  }
}

// DONE: Real-time socket integration with proper event handling
