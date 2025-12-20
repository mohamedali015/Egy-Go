import 'package:egy_go/features/trip/data/models/trips_response_model.dart';

class CancelTripResponseModel {
  bool? success;
  String? message;
  TripModel? trip;

  CancelTripResponseModel({this.success, this.message, this.trip});

  CancelTripResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    trip = json['trip'] != null ? TripModel.fromJson(json['trip']) : null;
  }
}
