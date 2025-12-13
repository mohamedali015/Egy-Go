class RegisterResponseModel {
  bool? success;
  String? message;
  String? userId;
  String? otp;

  RegisterResponseModel({this.success, this.message, this.userId, this.otp});

  RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    userId = json['userId'];
    otp = json['otp'];
  }
}
