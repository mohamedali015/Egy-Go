import 'package:egy_go/features/trip/data/models/trips_response_model.dart';

class TripDetailsResponseModel {
  bool? success;
  TripModel? trip;

  TripDetailsResponseModel({this.success, this.trip});

  TripDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    trip = json['data'] != null ? TripModel.fromJson(json['data']) : null;
  }
}
