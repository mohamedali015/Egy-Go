class PlacesResponseModel {
  bool? success;
  Data? data;

  PlacesResponseModel({this.success, this.data});

  PlacesResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  List<Place>? places;

  Data({this.places});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['places'] != null) {
      places = <Place>[];
      json['places'].forEach((v) {
        places!.add(Place.fromJson(v));
      });
    }
  }
}

class Place {
  String? sId;
  String? slug;
  num? iV;
  String? address;
  String? createdAt;
  String? description;
  String? email;
  String? eventDate;
  String? eventEndDate;
  List<String>? images;
  bool? isActive;
  Location? location;
  String? name;
  String? openingHours;
  String? phone;
  Province? province;
  num? rating;
  String? shortDescription;
  num? stars;
  List<String>? tags;
  num? ticketPrice;
  String? type;
  String? updatedAt;
  num? viewsCount;
  String? website;

  Place(
      {this.sId,
      this.slug,
      this.iV,
      this.address,
      this.createdAt,
      this.description,
      this.email,
      this.eventDate,
      this.eventEndDate,
      this.images,
      this.isActive,
      this.location,
      this.name,
      this.openingHours,
      this.phone,
      this.province,
      this.rating,
      this.shortDescription,
      this.stars,
      this.tags,
      this.ticketPrice,
      this.type,
      this.updatedAt,
      this.viewsCount,
      this.website});

  Place.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    slug = json['slug'];
    iV = json['__v'];
    address = json['address'];
    createdAt = json['createdAt'];
    description = json['description'];
    email = json['email'];
    eventDate = json['eventDate'];
    eventEndDate = json['eventEndDate'];
    images = json['images'].cast<String>();
    isActive = json['isActive'];
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    name = json['name'];
    openingHours = json['openingHours'];
    phone = json['phone'];
    province =
        json['province'] != null ? Province.fromJson(json['province']) : null;
    rating = json['rating'];
    shortDescription = json['shortDescription'];
    stars = json['stars'];
    tags = json['tags'].cast<String>();
    ticketPrice = json['ticketPrice'];
    type = json['type'];
    updatedAt = json['updatedAt'];
    viewsCount = json['viewsCount'];
    website = json['website'];
  }
}

class Location {
  String? type;
  List<num>? coordinates;

  Location({this.type, this.coordinates});

  Location.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<num>();
  }
}

class Province {
  String? sId;
  String? slug;
  String? name;

  Province({this.sId, this.slug, this.name});

  Province.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    slug = json['slug'];
    name = json['name'];
  }
}
