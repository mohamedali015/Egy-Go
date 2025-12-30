import 'dart:async';
import 'package:egy_go/features/trip/data/models/trips_response_model.dart';
import 'package:egy_go/features/trip/data/repos/trip_repo.dart';
import 'package:egy_go/core/network/socket_service.dart';
import 'package:egy_go/features/trip/manager/trips_cubit/trips_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'trip_details_state.dart';

class TripDetailsCubit extends Cubit<TripDetailsState> {
  TripDetailsCubit(this.repo) : super(TripDetailsInitial());

  static TripDetailsCubit get(context) => BlocProvider.of(context);
  final TripRepo repo;
  final SocketService _socketService = SocketService();

  TripModel? currentTrip;
  TripDetailsState? _previousState; // Cache previous state
  bool _isSocketInitialized = false;
  Timer? _pollTimer; // Fallback polling timer

  /// Initialize socket connection and listen to status updates
  /// Called when Trip Details screen is mounted
  Future<void> initializeSocket(String tripId) async {
    if (_isSocketInitialized) {
      print('[TripDetailsCubit] ℹ️ Socket already initialized');
      return;
    }

    print(
        '[TripDetailsCubit] 🚀 Starting socket initialization for trip: $tripId');
    print('[TripDetailsCubit] 📍 Current trip status: ${currentTrip?.status}');

    try {
      // Step 1: Connect to socket
      print('[TripDetailsCubit] 📡 Step 1: Connecting to socket server...');
      await _socketService.connect();

      // Step 2: Wait for connection to establish
      print(
          '[TripDetailsCubit] ⏳ Step 2: Waiting for connection to establish...');
      await Future.delayed(Duration(milliseconds: 1500));

      if (!_socketService.isConnected) {
        print('[TripDetailsCubit] ❌ Socket connection failed - timeout');
        print('[TripDetailsCubit] ⚠️ Falling back to polling mechanism...');
        _startPollingFallback(tripId);
        return;
      }

      // Step 3: Set up event listener BEFORE joining room (CRITICAL!)
      print('[TripDetailsCubit] 👂 Step 3: Setting up event listener FIRST...');
      _socketService.onTripStatusUpdated((data) {
        print('[TripDetailsCubit] 🔔 Received status update callback!');
        _handleTripStatusUpdate(data);
      });

      // Step 4: Join trip room AFTER listener is set up
      print('[TripDetailsCubit] 🚪 Step 4: Joining trip room...');
      await _socketService.joinTripRoom(tripId);

      _isSocketInitialized = true;
      print(
          '[TripDetailsCubit] ✅ Socket initialization COMPLETE for trip: $tripId');
      print(
          '[TripDetailsCubit] 🎯 Now listening for status updates on trip: $tripId');
      print(
          '[TripDetailsCubit] 📡 Socket connected: ${_socketService.isConnected}');
      print(
          '[TripDetailsCubit] 🚪 Room joined: ${_socketService.isJoinedToRoom}');

      // Start polling as backup (every 15 seconds) to catch missed events
      print('[TripDetailsCubit] 🔄 Starting backup polling (15s interval)...');
      _startPollingFallback(tripId);
    } catch (e, stackTrace) {
      print('[TripDetailsCubit] ❌ Socket initialization failed: $e');
      print('[TripDetailsCubit] 📍 Stack trace: $stackTrace');
      print('[TripDetailsCubit] ⚠️ Falling back to polling mechanism...');
      _startPollingFallback(tripId);
    }
  }

  /// Start polling as fallback mechanism
  /// This ensures status updates are caught even if socket fails
  void _startPollingFallback(String tripId) {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(Duration(seconds: 15), (timer) async {
      print('[TripDetailsCubit] 🔄 Polling for trip updates...');
      try {
        final result = await repo.getTripDetails(tripId);
        result.fold(
          (error) {
            print('[TripDetailsCubit] ⚠️ Polling failed: $error');
            // Don't emit error state during polling to avoid disrupting UI
            // Just log and continue
          },
          (tripDetailsData) {
            final newStatus = tripDetailsData.trip?.status;
            final currentStatus = currentTrip?.status;

            if (newStatus != null && newStatus != currentStatus) {
              print('[TripDetailsCubit] 🔔 POLLING: Status changed!');
              print('[TripDetailsCubit]    Old: $currentStatus');
              print('[TripDetailsCubit]    New: $newStatus');

              currentTrip = tripDetailsData.trip;

              // Notify trips screen to refresh
              TripsCubit.notifyTripUpdated(tripId);
              print(
                  '[TripDetailsCubit] 📢 Notified trips screen to refresh (polling)');

              emit(TripDetailsSuccess(tripDetailsData.trip!));
            } else {
              print('[TripDetailsCubit] ℹ️ No status change detected');
            }
          },
        );
      } catch (e) {
        print('[TripDetailsCubit] ⚠️ Polling error: $e');
        // Continue polling even if there's an error
      }
    });
    print('[TripDetailsCubit] ✅ Polling fallback started');
  }

  /// Stop polling timer
  void _stopPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
    print('[TripDetailsCubit] 🛑 Polling stopped');
  }

  /// Handle incoming trip status updates from socket
  /// Verifies tripId and updates UI immediately
  void _handleTripStatusUpdate(Map<String, dynamic> data) {
    try {
      print('[TripDetailsCubit] ═══════════════════════════════════════════');
      print('[TripDetailsCubit] 📨 PROCESSING STATUS UPDATE FROM SOCKET');
      print('[TripDetailsCubit] ═══════════════════════════════════════════');
      print('[TripDetailsCubit] 📦 Full data received: $data');

      final tripId = data['tripId'] as String?;
      final newStatus = data['status'] as String?;
      final timestamp = data['timestamp'] as String?;

      print('[TripDetailsCubit] 🔍 Extracted tripId: $tripId');
      print('[TripDetailsCubit] 🔍 Extracted status: $newStatus');
      print('[TripDetailsCubit] 🔍 Extracted timestamp: $timestamp');
      print('[TripDetailsCubit] 🔍 Current trip ID: ${currentTrip?.sId}');
      print(
          '[TripDetailsCubit] 🔍 Current trip status: ${currentTrip?.status}');

      // Verify tripId matches current trip
      if (tripId == null || tripId != currentTrip?.sId) {
        print('[TripDetailsCubit] ⚠️ Ignoring update - tripId mismatch!');
        print('[TripDetailsCubit]    Expected: ${currentTrip?.sId}');
        print('[TripDetailsCubit]    Received: $tripId');
        return;
      }

      if (newStatus == null || newStatus.isEmpty) {
        print(
            '[TripDetailsCubit] ❌ Invalid status in update - newStatus is null or empty');
        return;
      }

      print('[TripDetailsCubit] 🎯 Status update VALID!');
      print(
          '[TripDetailsCubit] 📊 Updating from "${currentTrip?.status}" to "$newStatus"');

      // Update local trip status immediately
      if (currentTrip != null) {
        final oldStatus = currentTrip!.status;
        currentTrip!.status = newStatus;

        print('[TripDetailsCubit] ✅ Local trip status updated!');
        print('[TripDetailsCubit]    Old: $oldStatus');
        print('[TripDetailsCubit]    New: $newStatus');

        // Update other relevant fields from socket data
        if (data['paymentStatus'] != null) {
          currentTrip!.paymentStatus = data['paymentStatus'] as String?;
          print(
              '[TripDetailsCubit] 💳 Payment status updated: ${data['paymentStatus']}');
        }

        // Notify trips screen to refresh
        TripsCubit.notifyTripUpdated(tripId);
        print('[TripDetailsCubit] 📢 Notified trips screen to refresh');

        // Trigger UI rebuild with updated trip
        print(
            '[TripDetailsCubit] 🔄 Emitting TripDetailsSuccess to rebuild UI...');
        emit(TripDetailsSuccess(currentTrip!));

        print('[TripDetailsCubit] ✅ UI update triggered successfully!');
        print('[TripDetailsCubit] ═══════════════════════════════════════════');
      } else {
        print('[TripDetailsCubit] ⚠️ currentTrip is null - cannot update');
        print('[TripDetailsCubit] ═══════════════════════════════════════════');
      }
    } catch (e, stackTrace) {
      print('[TripDetailsCubit] ❌ Error handling status update: $e');
      print('[TripDetailsCubit] 📍 Stack trace: $stackTrace');
      print('[TripDetailsCubit] ═══════════════════════════════════════════');
    }
  }

  /// Disconnect socket when screen is disposed
  void disposeSocket() {
    if (_isSocketInitialized) {
      _socketService.offTripStatusUpdated();
      _socketService.disconnect();
      _isSocketInitialized = false;
      print('[TripDetailsCubit] Socket disposed');
    }
    _stopPolling();
  }

  /// Fetch trip details from REST API (initial load only)
  Future<void> fetchTripDetails(String tripId) async {
    emit(TripDetailsLoading());
    final result = await repo.getTripDetails(tripId);
    result.fold(
      (error) {
        emit(TripDetailsFailure(error));
      },
      (tripDetailsData) {
        currentTrip = tripDetailsData.trip;
        emit(TripDetailsSuccess(tripDetailsData.trip!));

        // Initialize socket after successful initial load
        initializeSocket(tripId);
      },
    );
  }

  Future<void> cancelTrip(String tripId, String reason) async {
    emit(TripCancelling());
    final result = await repo.cancelTrip(tripId, reason);
    result.fold(
      (error) {
        emit(TripDetailsFailure(error));
      },
      (cancelResponse) {
        currentTrip = cancelResponse.trip;
        emit(TripCancelled(cancelResponse.trip!,
            cancelResponse.message ?? 'Trip cancelled successfully'));
      },
    );
  }

  Future<void> initiateCall(String tripId, String guideId) async {
    // Cache current state before call initiation
    if (state is TripDetailsSuccess) {
      _previousState = state;
    }

    emit(CallInitiating());
    final result = await repo.initiateCall(tripId, guideId);
    result.fold(
      (error) {
        // Restore previous state on failure
        restoreTripDetailsState();
        emit(CallInitiationFailed(error));
      },
      (callResponse) {
        emit(CallInitiatedSuccess(callResponse));
      },
    );
  }

  // Restore TripDetails state after call operations
  void restoreTripDetailsState() {
    if (currentTrip != null) {
      emit(TripDetailsSuccess(currentTrip!));
    } else if (_previousState != null) {
      emit(_previousState!);
    }
  }

  bool canCancelTrip() {
    if (currentTrip == null) return false;

    // Check if trip is already cancelled or completed
    if (currentTrip!.status == 'cancelled' ||
        currentTrip!.status == 'completed') {
      return false;
    }

    // Check if trip starts in less than 24 hours
    if (currentTrip!.startAt != null) {
      DateTime startTime = DateTime.parse(currentTrip!.startAt!);
      DateTime now = DateTime.now();
      Duration difference = startTime.difference(now);

      if (difference.inHours < 24) {
        return false;
      }
    }

    return true;
  }

  String getCancellationMessage() {
    if (currentTrip?.startAt != null) {
      DateTime startTime = DateTime.parse(currentTrip!.startAt!);
      DateTime now = DateTime.now();
      Duration difference = startTime.difference(now);

      if (difference.inHours < 24) {
        return 'Cannot cancel trip within 24 hours of start time';
      }
    }
    return '';
  }

  @override
  Future<void> close() {
    disposeSocket();
    return super.close();
  }
}

// DONE: TripDetails state preserved
// DONE: Real-time socket integration
