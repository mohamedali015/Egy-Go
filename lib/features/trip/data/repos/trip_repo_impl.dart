import 'package:dartz/dartz.dart';
import 'package:egy_go/core/network/api_helper.dart';
import 'package:egy_go/core/network/api_response.dart';
import 'package:egy_go/core/network/end_points.dart';
import 'package:egy_go/features/trip/data/models/cancel_trip_response_model.dart';
import 'package:egy_go/features/trip/data/models/checkout_session_response_model.dart';
import 'package:egy_go/features/trip/data/models/end_call_response_model.dart';
import 'package:egy_go/features/trip/data/models/initiate_call_response_model.dart';
import 'package:egy_go/features/trip/data/models/trip_details_response_model.dart';
import 'package:egy_go/features/trip/data/models/trips_response_model.dart';
import 'package:egy_go/features/trip/data/repos/trip_repo.dart';

class TripRepoImpl implements TripRepo {
  final ApiHelper apiHelper;

  TripRepoImpl({required this.apiHelper});

  @override
  Future<Either<String, TripsResponseModel>> getMyTrips() async {
    try {
      ApiResponse response = await apiHelper.getRequest(
        endPoint: EndPoints.getMyTrips,
        isProtected: true,
      );
      TripsResponseModel tripsResponseModel =
          TripsResponseModel.fromJson(response.data);
      if (tripsResponseModel.success != null &&
          tripsResponseModel.success == true) {
        return Right(tripsResponseModel);
      } else {
        throw Exception("Failed to fetch trips.");
      }
    } catch (e) {
      ApiResponse errorResponse = ApiResponse.fromError(e);
      return Left(errorResponse.message);
    }
  }

  @override
  Future<Either<String, TripDetailsResponseModel>> getTripDetails(
      String tripId) async {
    try {
      ApiResponse response = await apiHelper.getRequest(
        endPoint: EndPoints.getTripDetails(tripId),
        isProtected: true,
      );
      TripDetailsResponseModel tripDetailsResponseModel =
          TripDetailsResponseModel.fromJson(response.data);
      if (tripDetailsResponseModel.success != null &&
          tripDetailsResponseModel.success == true) {
        return Right(tripDetailsResponseModel);
      } else {
        throw Exception("Failed to fetch trip details.");
      }
    } catch (e) {
      ApiResponse errorResponse = ApiResponse.fromError(e);
      return Left(errorResponse.message);
    }
  }

  @override
  Future<Either<String, CancelTripResponseModel>> cancelTrip(
      String tripId, String reason) async {
    try {
      ApiResponse response = await apiHelper.putRequest(
        endPoint: EndPoints.cancelTrip(tripId),
        data: {
          "reason": reason,
        },
        isProtected: true,
      );
      CancelTripResponseModel cancelTripResponseModel =
          CancelTripResponseModel.fromJson(response.data);
      if (cancelTripResponseModel.success != null &&
          cancelTripResponseModel.success == true) {
        return Right(cancelTripResponseModel);
      } else {
        throw Exception("Failed to cancel trip.");
      }
    } catch (e) {
      ApiResponse errorResponse = ApiResponse.fromError(e);
      return Left(errorResponse.message);
    }
  }

  @override
  Future<Either<String, InitiateCallResponseModel>> initiateCall(
      String tripId, String guideId) async {
    try {
      ApiResponse response = await apiHelper.postRequest(
        endPoint: EndPoints.initiateCallTrip(tripId),
        isProtected: true,
      );
      InitiateCallResponseModel initiateCallResponseModel =
          InitiateCallResponseModel.fromJson(response.data);
      if (initiateCallResponseModel.success != null &&
          initiateCallResponseModel.success == true) {
        return Right(initiateCallResponseModel);
      } else {
        throw Exception("Failed to initiate call.");
      }
    } catch (e) {
      ApiResponse errorResponse = ApiResponse.fromError(e);
      return Left(errorResponse.message);
    }
  }

  @override
  Future<Either<String, EndCallResponseModel>> endCall(
      String callId,
      String endReason,
      String summary,
      double? negotiatedPrice,
      bool agreedToTerms) async {
    try {
      ApiResponse response = await apiHelper.postRequest(
        endPoint: EndPoints.endCallTrip(callId),
        data: {
          "endReason": endReason,
          "summary": summary,
          if (negotiatedPrice != null) "negotiatedPrice": negotiatedPrice,
          "agreedToTerms": agreedToTerms,
        },
        isProtected: true,
      );
      EndCallResponseModel endCallResponseModel =
          EndCallResponseModel.fromJson(response.data);
      if (endCallResponseModel.success != null &&
          endCallResponseModel.success == true) {
        return Right(endCallResponseModel);
      } else {
        throw Exception("Failed to end call.");
      }
    } catch (e) {
      ApiResponse errorResponse = ApiResponse.fromError(e);
      return Left(errorResponse.message);
    }
  }

  @override
  Future<Either<String, CheckoutSessionResponseModel>> createCheckoutSession(
      String tripId) async {
    try {
      ApiResponse response = await apiHelper.postRequest(
        endPoint: EndPoints.createCheckoutSession(tripId),
        isProtected: true,
      );
      CheckoutSessionResponseModel checkoutSessionResponseModel =
          CheckoutSessionResponseModel.fromJson(response.data);
      if (checkoutSessionResponseModel.success != null &&
          checkoutSessionResponseModel.success == true) {
        return Right(checkoutSessionResponseModel);
      } else {
        throw Exception("Failed to create checkout session.");
      }
    } catch (e) {
      ApiResponse errorResponse = ApiResponse.fromError(e);
      return Left(errorResponse.message);
    }
  }
}
