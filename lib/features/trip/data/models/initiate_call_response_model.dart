class InitiateCallResponseModel {
  bool? success;
  String? message;
  String? callId;
  String? tripId;
  AgoraToken? token;
  String? nextStep;

  InitiateCallResponseModel({
    this.success,
    this.message,
    this.callId,
    this.tripId,
    this.token,
    this.nextStep,
  });

  InitiateCallResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    callId = json['callId'];
    tripId = json['tripId'];
    token = json['token'] != null ? AgoraToken.fromJson(json['token']) : null;
    nextStep = json['nextStep'];
  }
}

class AgoraToken {
  String? appId;
  String? channelName;
  int? uid;
  String? token;
  String? expiresAt;
  int? maxDurationSeconds;

  AgoraToken({
    this.appId,
    this.channelName,
    this.uid,
    this.token,
    this.expiresAt,
    this.maxDurationSeconds,
  });

  AgoraToken.fromJson(Map<String, dynamic> json) {
    appId = json['appId'];
    channelName = json['channelName'];
    uid = json['uid'];
    token = json['token'];
    expiresAt = json['expiresAt'];
    maxDurationSeconds = json['maxDurationSeconds'];
  }
}
