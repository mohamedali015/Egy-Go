import 'package:dartz/dartz.dart';
import 'package:egy_go/core/network/api_helper.dart';
import 'package:egy_go/core/network/api_response.dart';
import 'package:egy_go/core/network/end_points.dart';

import 'package:egy_go/features/places/data/models/places_response_model.dart';

import 'places_repo.dart';

class PlacesRepoImpl extends PlacesRepo {
  ApiHelper apiHelper;

  PlacesRepoImpl({required this.apiHelper});

  @override
  Future<Either<String, List<Place>>> getPlaces() async {
    try {
      ApiResponse response =
          await apiHelper.getRequest(endPoint: EndPoints.getPlaces);
      PlacesResponseModel placesResponseModel =
          PlacesResponseModel.fromJson(response.data);
      if (placesResponseModel.success != null &&
          placesResponseModel.success == true) {
        if (placesResponseModel.data!.places != null) {
          return Right(placesResponseModel.data!.places!);
        } else {
          throw Exception("No Places found.");
        }
      } else {
        throw Exception("Failed to fetch Places.");
      }
    } catch (e) {
      ApiResponse errorResponse = ApiResponse.fromError(e);
      return Left(errorResponse.message);
    }
  }

  @override
  Future<Either<String, List<Place>>> getPlacesByCategory(
      {required String category, required String governorate}) async {
    try {
      ApiResponse response = await apiHelper.getRequest(
          endPoint: EndPoints.getPlacesByCategory(
        category,
        governorate,
      ));
      PlacesResponseModel placesResponseModel =
          PlacesResponseModel.fromJson(response.data);
      if (placesResponseModel.success != null &&
          placesResponseModel.success == true) {
        if (placesResponseModel.data!.places != null) {
          return Right(placesResponseModel.data!.places!);
        } else {
          throw Exception("No Places found.");
        }
      } else {
        throw Exception("Failed to get $governorate Places.");
      }
    } catch (e) {
      ApiResponse errorResponse = ApiResponse.fromError(e);
      return Left(errorResponse.message);
    }
  }

  @override
  Future<Either<String, Place>> getPlaceById(String placeId) async {
    try {
      ApiResponse response = await apiHelper.getRequest(
        endPoint: 'places/$placeId',
        isProtected: false,
      );

      if (response.success) {
        // Parse the place from response
        final placeData = response.data['data'] ?? response.data;
        Place place = Place.fromJson(placeData);
        return Right(place);
      } else {
        throw Exception("Failed to fetch place details.");
      }
    } catch (e) {
      ApiResponse errorResponse = ApiResponse.fromError(e);
      return Left(errorResponse.message);
    }
  }
}
