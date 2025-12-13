import 'package:dartz/dartz.dart';
import 'package:egy_go/core/user/data/models/user_model.dart';

abstract class AuthRepo {
  Future<Either<String, String>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  });

  Future<Either<String, UserModel>> login({
    required String email,
    required String password,
  });

  Future<Either<String, String>> verifyOtp({
    required String email,
    required String otp,
  });

  Future<Either<String, String>> resendOtp({
    required String email,
  });
}
