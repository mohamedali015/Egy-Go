import 'package:dartz/dartz.dart';
import 'package:egy_go/features/trip/data/models/cancel_trip_response_model.dart';
import 'package:egy_go/features/trip/data/models/end_call_response_model.dart';
import 'package:egy_go/features/trip/data/models/initiate_call_response_model.dart';
import 'package:egy_go/features/trip/data/models/trip_details_response_model.dart';
import 'package:egy_go/features/trip/data/models/trips_response_model.dart';

abstract class TripRepo {
  Future<Either<String, TripsResponseModel>> getMyTrips();

  Future<Either<String, TripDetailsResponseModel>> getTripDetails(
      String tripId);

  Future<Either<String, CancelTripResponseModel>> cancelTrip(
      String tripId, String reason);

  Future<Either<String, InitiateCallResponseModel>> initiateCall(
      String tripId, String guideId);

  Future<Either<String, EndCallResponseModel>> endCall(
      String callId,
      String endReason,
      String summary,
      double? negotiatedPrice,
      bool agreedToTerms);
}
