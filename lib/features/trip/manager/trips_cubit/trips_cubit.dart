import 'dart:async';
import 'package:egy_go/features/trip/data/models/trips_response_model.dart';
import 'package:egy_go/features/trip/data/repos/trip_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'trips_state.dart';

class TripsCubit extends Cubit<TripsState> {
  TripsCubit(this.repo) : super(TripsInitial());

  static TripsCubit get(context) => BlocProvider.of(context);
  final TripRepo repo;

  List<TripModel> allTrips = [];
  List<TripModel> filteredTrips = [];
  String selectedFilter = 'all';

  // Static stream controller to notify all instances when a trip status changes
  static final StreamController<String> _tripUpdateController =
      StreamController<String>.broadcast();

  static Stream<String> get tripUpdateStream => _tripUpdateController.stream;

  // Static method to notify that a trip was updated
  static void notifyTripUpdated(String tripId) {
    print('[TripsCubit] 📢 Broadcasting trip update notification: $tripId');
    _tripUpdateController.add(tripId);
  }

  StreamSubscription? _updateSubscription;

  // Listen for trip updates
  void listenForTripUpdates() {
    _updateSubscription = tripUpdateStream.listen((tripId) {
      print('[TripsCubit] 🔔 Received trip update notification: $tripId');
      print('[TripsCubit] 🔄 Refreshing trips list...');
      fetchTrips();
    });
  }

  Future<void> fetchTrips() async {
    emit(TripsLoading());
    final result = await repo.getMyTrips();
    result.fold(
      (error) {
        emit(TripsFailure(error));
      },
      (tripsData) {
        allTrips.clear();
        if (tripsData.trips != null) {
          allTrips.addAll(tripsData.trips!);
        }
        filteredTrips = List.from(allTrips);
        emit(TripsSuccess(filteredTrips));
      },
    );
  }

  void filterTrips(String filter) {
    selectedFilter = filter;

    if (filter == 'all') {
      filteredTrips = List.from(allTrips);
    } else if (filter == 'ongoing') {
      filteredTrips = allTrips.where((trip) {
        return trip.status != 'cancelled' && trip.status != 'completed';
      }).toList();
    } else if (filter == 'completed') {
      filteredTrips =
          allTrips.where((trip) => trip.status == 'completed').toList();
    } else if (filter == 'cancelled') {
      filteredTrips =
          allTrips.where((trip) => trip.status == 'cancelled').toList();
    }

    emit(TripsSuccess(filteredTrips));
  }

  @override
  Future<void> close() {
    _updateSubscription?.cancel();
    return super.close();
  }
}
