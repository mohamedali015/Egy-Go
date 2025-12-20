class SelectGuideResponseModel {
  bool? success;
  String? message;
  Trip? trip;
  GuideInfo? guide;
  String? nextStep;
  String? nextEndpoint;

  SelectGuideResponseModel({
    this.success,
    this.message,
    this.trip,
    this.guide,
    this.nextStep,
    this.nextEndpoint,
  });

  SelectGuideResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    trip = json['trip'] != null ? Trip.fromJson(json['trip']) : null;
    guide = json['guide'] != null ? GuideInfo.fromJson(json['guide']) : null;
    nextStep = json['nextStep'];
    nextEndpoint = json['nextEndpoint'];
  }
}

class Trip {
  String? sId;
  String? status;

  Trip({this.sId, this.status});

  Trip.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    status = json['status'];
  }
}

class GuideInfo {
  String? id;
  String? name;
  int? pricePerHour;
  List<String>? languages;
  double? rating;

  GuideInfo({
    this.id,
    this.name,
    this.pricePerHour,
    this.languages,
    this.rating,
  });

  GuideInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    pricePerHour = json['pricePerHour'];
    if (json['languages'] != null) {
      languages = json['languages'].cast<String>();
    }
    rating = json['rating']?.toDouble();
  }
}
