class CheckoutSessionResponseModel {
  bool? success;
  String? message;
  CheckoutSessionData? data;

  CheckoutSessionResponseModel({this.success, this.message, this.data});

  CheckoutSessionResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null
        ? CheckoutSessionData.fromJson(json['data'])
        : null;
  }
}

class CheckoutSessionData {
  String? checkoutUrl;
  String? sessionId;

  CheckoutSessionData({this.checkoutUrl, this.sessionId});

  CheckoutSessionData.fromJson(Map<String, dynamic> json) {
    checkoutUrl = json['checkoutUrl'];
    sessionId = json['sessionId'];
  }
}
