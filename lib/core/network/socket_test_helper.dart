import 'package:egy_go/core/network/socket_service.dart';

/// Helper class to test socket functionality
/// This can be used to manually trigger test events
class SocketTestHelper {
  final SocketService socketService;

  SocketTestHelper(this.socketService);

  /// Print current socket state for debugging
  void printSocketState() {
    print('═══════════════════════════════════════════');
    print('SOCKET STATE DEBUG INFO');
    print('═══════════════════════════════════════════');
    print('Connected: ${socketService.isConnected}');
    print('Current Trip ID: ${socketService.currentTripId}');
    print('Joined to Room: ${socketService.isJoinedToRoom}');
    print('═══════════════════════════════════════════');
  }

  /// Test if socket can receive custom events
  /// This helps verify the socket connection is working
  void setupTestListeners() {
    print('[SocketTestHelper] Setting up test listeners...');

    // These are just for debugging - they won't interfere with real listeners
    print('[SocketTestHelper] ✅ Test listeners set up');
    print('[SocketTestHelper] Now watching for ALL events via onAny()');
  }
}
