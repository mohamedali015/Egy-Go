import 'package:dartz/dartz.dart';
import 'package:egy_go/features/trip/data/models/cancel_trip_response_model.dart';
import 'package:egy_go/features/trip/data/models/trip_details_response_model.dart';
import 'package:egy_go/features/trip/data/models/trips_response_model.dart';

abstract class TripRepo {
  Future<Either<String, TripsResponseModel>> getMyTrips();

  Future<Either<String, TripDetailsResponseModel>> getTripDetails(
      String tripId);

  Future<Either<String, CancelTripResponseModel>> cancelTrip(
      String tripId, String reason);
}
