import 'package:egy_go/features/trip/data/models/trips_response_model.dart';
import 'package:egy_go/features/trip/data/repos/trip_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'trip_details_state.dart';

class TripDetailsCubit extends Cubit<TripDetailsState> {
  TripDetailsCubit(this.repo) : super(TripDetailsInitial());

  static TripDetailsCubit get(context) => BlocProvider.of(context);
  final TripRepo repo;

  TripModel? currentTrip;

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
}
