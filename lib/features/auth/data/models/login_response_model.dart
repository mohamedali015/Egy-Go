import 'package:egy_go/core/user/data/models/user_model.dart';

class LoginResponseModel {
  bool? success;
  Data? data;
  String? message;

  LoginResponseModel({this.success, this.data, this.message});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
  }
}

class Data {
  UserModel? user;
  String? accessToken;
  String? refreshToken;

  Data({this.user, this.accessToken, this.refreshToken});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
  }
}
