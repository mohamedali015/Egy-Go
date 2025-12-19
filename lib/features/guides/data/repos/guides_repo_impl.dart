import 'package:dartz/dartz.dart';
import 'package:egy_go/core/network/api_helper.dart';
import 'package:egy_go/core/network/api_response.dart';
import 'package:egy_go/core/network/end_points.dart';
import 'package:egy_go/features/guides/data/models/trip_guides_response_model.dart';
import 'package:egy_go/features/guides/data/repos/guides_repo.dart';

class GuidesRepoImpl implements GuidesRepo {
  final ApiHelper apiHelper;

  GuidesRepoImpl({required this.apiHelper});

  @override
  Future<Either<String, TripGuidesResponseModel>> getTripGuides(
      String tripId) async {
    try {
      ApiResponse response = await apiHelper.getRequest(
        endPoint: EndPoints.getTripGuides(tripId),
        isProtected: true,
      );
      TripGuidesResponseModel tripGuidesResponseModel =
          TripGuidesResponseModel.fromJson(response.data);
      if (tripGuidesResponseModel.success != null &&
          tripGuidesResponseModel.success == true) {
        return Right(tripGuidesResponseModel);
      } else {
        throw Exception("Failed to fetch guides.");
      }
    } catch (e) {
      ApiResponse errorResponse = ApiResponse.fromError(e);
      return Left(errorResponse.message);
    }
  }
}
