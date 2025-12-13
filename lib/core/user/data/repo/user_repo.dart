import 'package:dartz/dartz.dart';
import 'package:egy_go/core/user/data/models/user_model.dart';

abstract class UserRepo {
  // get user data
  Future<Either<String, UserModel>> getUserData();
}
