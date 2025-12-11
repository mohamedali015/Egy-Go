import 'package:dartz/dartz.dart';
import 'package:egy_go/core/network/api_helper.dart';
import 'package:egy_go/core/network/api_response.dart';
import 'package:egy_go/core/network/end_points.dart';

import '../../models/governorates_response_model.dart';
import 'governorates_repo.dart';

class GovernoratesRepoImpl implements GovernoratesRepo {
  final ApiHelper apiHelper;

  GovernoratesRepoImpl({required this.apiHelper});

  @override
  Future<Either<String, List<Governorate>>> getGovernorates() async {
    try {
      ApiResponse response =
          await apiHelper.getRequest(endPoint: EndPoints.getGovernorates);
      GovernoratesResponseModel governoratesResponseModel =
          GovernoratesResponseModel.fromJson(response.data);
      if (governoratesResponseModel.success != null &&
          governoratesResponseModel.success == true) {
        if (governoratesResponseModel.governorates != null) {
          return Right(governoratesResponseModel.governorates!);
        } else {
          throw Exception("No governorates found.");
        }
      } else {
        throw Exception("Failed to fetch governorates.");
      }
    } catch (e) {
      ApiResponse errorResponse = ApiResponse.fromError(e);
      return Left(errorResponse.message);
    }
  }
}
