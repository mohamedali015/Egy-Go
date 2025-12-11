class GovernoratesResponseModel {
  bool? success;
  List<Governorate>? governorates;

  GovernoratesResponseModel({this.success, this.governorates});

  GovernoratesResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      governorates = <Governorate>[];
      json['data'].forEach((v) {
        governorates!.add(Governorate.fromJson(v));
      });
    }
  }
}

class Governorate {
  String? sId;
  String? slug;
  String? coverImage;
  String? description;
  Location? location;
  String? name;

  Governorate(
      {this.sId,
      this.slug,
      this.coverImage,
      this.description,
      this.location,
      this.name});

  Governorate.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    slug = json['slug'];
    coverImage = json['coverImage'];
    description = json['description'];
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    name = json['name'];
  }
}

class Location {
  String? type;
  List<double>? coordinates;

  Location({this.type, this.coordinates});

  Location.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
  }
}
