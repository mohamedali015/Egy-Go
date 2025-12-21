import 'package:egy_go/features/trip/data/models/trips_response_model.dart';

class EndCallResponseModel {
  bool? success;
  String? message;
  TripModel? trip;

  EndCallResponseModel({
    this.success,
    this.message,
    this.trip,
  });

  EndCallResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    trip = json['trip'] != null ? TripModel.fromJson(json['trip']) : null;
  }
}
