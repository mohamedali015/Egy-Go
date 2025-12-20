import 'package:egy_go/features/trip/data/models/trips_response_model.dart';

abstract class TripsState {}

class TripsInitial extends TripsState {}

class TripsLoading extends TripsState {}

class TripsSuccess extends TripsState {
  final List<TripModel> trips;

  TripsSuccess(this.trips);
}

class TripsFailure extends TripsState {
  final String errorMessage;

  TripsFailure(this.errorMessage);
}
