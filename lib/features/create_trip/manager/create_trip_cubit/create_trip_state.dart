import 'package:egy_go/features/create_trip/data/models/create_trip_response_model.dart';

abstract class CreateTripState {}

class CreateTripInitial extends CreateTripState {}

class CreateTripLoading extends CreateTripState {}

class CreateTripSuccess extends CreateTripState {
  final CreateTripResponseModel response;

  CreateTripSuccess(this.response);
}

class CreateTripFailure extends CreateTripState {
  final String errorMessage;

  CreateTripFailure(this.errorMessage);
}
