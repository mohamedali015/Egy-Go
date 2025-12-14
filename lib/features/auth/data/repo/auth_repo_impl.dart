import 'package:dartz/dartz.dart';
import 'package:egy_go/core/cache/cache_data.dart';
import 'package:egy_go/core/cache/cache_helper.dart';
import 'package:egy_go/core/cache/cache_key.dart';
import 'package:egy_go/core/helper/custom_logger.dart';
import 'package:egy_go/core/network/api_helper.dart';
import 'package:egy_go/core/network/api_response.dart';
import 'package:egy_go/core/network/end_points.dart';
import 'package:egy_go/core/user/data/models/user_model.dart';
import 'package:egy_go/features/auth/data/models/login_response_model.dart';
import 'package:egy_go/features/auth/data/models/register_response_model.dart';

import 'auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  ApiHelper apiHelper;

  AuthRepoImpl({required this.apiHelper});

  @override
  Future<Either<String, UserModel>> login(
      {required String email, required String password}) async {
    try {
      ApiResponse response = await apiHelper.postRequest(
        endPoint: EndPoints.login,
        data: {'email': email, 'password': password},
      );

      LoginResponseModel loginResponseModel =
          LoginResponseModel.fromJson(response.data);

      if (loginResponseModel.success == null ||
          loginResponseModel.success == false) {
        throw Exception(loginResponseModel.message!);
      }

      // store tokens
      await CacheHelper.saveData(
          key: CacheKeys.accessToken,
          value: loginResponseModel.data!.accessToken);
      await CacheHelper.saveData(
          key: CacheKeys.refreshToken,
          value: loginResponseModel.data!.refreshToken);
      CacheData.accessToken = loginResponseModel.data!.accessToken;
      CacheData.refreshToken = loginResponseModel.data!.refreshToken;

      return Right(loginResponseModel.data!.user!);
    } catch (e) {
      ApiResponse apiResponse = ApiResponse.fromError(e);
      return Left(apiResponse.message);
    }
  }

  @override
  Future<Either<String, String>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      ApiResponse response = await apiHelper.postRequest(
        endPoint: EndPoints.register,
        data: {
          'email': email,
          'password': password,
          'name': name,
          'phone': phone,
          'role': 'tourist',
        },
      );

      RegisterResponseModel registerResponseModel =
          RegisterResponseModel.fromJson(response.data);

      if (registerResponseModel.success == null ||
          registerResponseModel.success == false) {
        throw Exception(registerResponseModel.message!);
      }

      return Right(registerResponseModel.message!);
    } catch (e) {
      ApiResponse apiResponse = ApiResponse.fromError(e);
      return Left(apiResponse.message);
    }
  }

  @override
  Future<Either<String, String>> verifyOtp(
      {required String email, required String otp}) async {
    try {
      ApiResponse response = await apiHelper.postRequest(
        endPoint: EndPoints.verifyOtp,
        data: {
          'email': email,
          'otp': otp,
        },
      );

      if (response.success == false) {
        throw Exception(response.message);
      }

      return Right(response.message);
    } catch (e) {
      ApiResponse apiResponse = ApiResponse.fromError(e);
      return Left(apiResponse.message);
    }
  }

  @override
  Future<Either<String, String>> resendOtp({required String email}) async {
    try {
      ApiResponse response = await apiHelper.postRequest(
        endPoint: EndPoints.resendOtp,
        data: {
          'email': email,
        },
      );

      if (response.success == false) {
        throw Exception(response.message);
      }

      return Right(response.message);
    } catch (e) {
      ApiResponse apiResponse = ApiResponse.fromError(e);
      return Left(apiResponse.message);
    }
  }

  @override
  Future<Either<String, String>> resetPassword(
      {required String email, required String password}) {
    // TODO: implement resetPassword
    throw UnimplementedError();
  }

// @override
// Future<Either<String, String>> resetPassword(
//     {required String email, required String password}) async {
//   try {
//     ApiResponse response = await apiHelper.postRequest(
//       endPoint: EndPoints.resetPassword,
//       data: {
//         'email': email,
//         'password': password,
//         'confirmPassword': password,
//       },
//     );
//
//     if (response.success == false) {
//       throw Exception(response.message);
//     }
//
//     return Right(response.message);
//   } catch (e) {
//     ApiResponse apiResponse = ApiResponse.fromError(e);
//     return Left(apiResponse.message);
//   }
// }
}
