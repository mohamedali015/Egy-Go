import 'package:egy_go/features/trip/data/models/trips_response_model.dart';

abstract class TripDetailsState {}

class TripDetailsInitial extends TripDetailsState {}

class TripDetailsLoading extends TripDetailsState {}

class TripDetailsSuccess extends TripDetailsState {
  final TripModel trip;

  TripDetailsSuccess(this.trip);
}

class TripDetailsFailure extends TripDetailsState {
  final String errorMessage;

  TripDetailsFailure(this.errorMessage);
}

class TripCancelling extends TripDetailsState {}

class TripCancelled extends TripDetailsState {
  final TripModel trip;
  final String message;

  TripCancelled(this.trip, this.message);
}
