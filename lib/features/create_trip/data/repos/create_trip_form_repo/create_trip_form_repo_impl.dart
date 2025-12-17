import 'package:dartz/dartz.dart';
import 'package:egy_go/core/network/api_helper.dart';
import 'package:egy_go/core/network/api_response.dart';
import 'package:egy_go/core/network/end_points.dart';
import 'package:egy_go/features/create_trip/data/models/create_trip_response_model.dart';
import 'package:egy_go/features/create_trip/data/repos/create_trip_form_repo/create_trip_form_repo.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateTripFormRepoImpl extends CreateTripFormRepo {
  ApiHelper apiHelper;

  CreateTripFormRepoImpl(this.apiHelper);

  @override
  Future<Either<String, CreateTripResponseModel>> createTrip(
      {required String dateTime,
      required int duration,
      required String meetingPoint,
      required LatLng meetingPointLatLng,
      required String notes,
      required String governorateId}) async {
    try {
      ApiResponse response = await apiHelper.postRequest(
        endPoint: EndPoints.createTrip,
        isProtected: true,
        data: {
          'startAt': dateTime,
          'meetingAddress': meetingPoint,
          "meetingPoint": {
            "type": "Point",
            "coordinates": [
              meetingPointLatLng.longitude,
              meetingPointLatLng.latitude
            ]
          },
          'totalDurationMinutes': duration,
          'provinceId': governorateId,
          'notes': notes,
        },
      );

      CreateTripResponseModel createTripResponseModel =
          CreateTripResponseModel.fromJson(response.data);

      if (createTripResponseModel.success == null ||
          createTripResponseModel.success == false) {
        throw Exception(createTripResponseModel.message!);
      }

      return Right(createTripResponseModel);
    } catch (e) {
      ApiResponse apiResponse = ApiResponse.fromError(e);
      return Left(apiResponse.message);
    }
  }
}
