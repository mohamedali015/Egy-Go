import 'package:egy_go/features/trip/data/models/initiate_call_response_model.dart';
import 'package:egy_go/features/trip/data/models/trips_response_model.dart';

abstract class CallState {}

class CallInitial extends CallState {}

class CallInitiating extends CallState {}

class CallInitiated extends CallState {
  final InitiateCallResponseModel callResponse;

  CallInitiated(this.callResponse);
}

class CallInitiationFailed extends CallState {
  final String errorMessage;

  CallInitiationFailed(this.errorMessage);
}

class CallEnding extends CallState {}

class CallEnded extends CallState {
  final TripModel trip;
  final String message;

  CallEnded(this.trip, this.message);
}

class CallEndFailed extends CallState {
  final String errorMessage;

  CallEndFailed(this.errorMessage);
}
