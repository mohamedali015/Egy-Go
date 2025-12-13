class PlacesCategoryResponseModel {
  bool? success;
  Data? data;

  PlacesCategoryResponseModel({this.success, this.data});

  PlacesCategoryResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  Province? province;
  List<Places>? places;
  Pagination? pagination;

  Data({this.province, this.places, this.pagination});

  Data.fromJson(Map<String, dynamic> json) {
    province =
        json['province'] != null ? Province.fromJson(json['province']) : null;
    if (json['places'] != null) {
      places = <Places>[];
      json['places'].forEach((v) {
        places!.add(Places.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }
}

class Province {
  String? name;
  String? slug;

  Province({this.name, this.slug});

  Province.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    slug = json['slug'];
  }
}

class Places {
  String? sId;
  String? slug;
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
  String? province;
  double? rating;
  String? shortDescription;
  String? stars;
  List<String>? tags;
  int? ticketPrice;
  String? type;
  String? updatedAt;
  int? viewsCount;
  String? website;
  String? googleMapsUrl;

  Places(
      {this.sId,
      this.slug,
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
      this.website,
      this.googleMapsUrl});

  Places.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    slug = json['slug'];
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
    province = json['province'];
    rating = json['rating'];
    shortDescription = json['shortDescription'];
    stars = json['stars'];
    tags = json['tags'].cast<String>();
    ticketPrice = json['ticketPrice'];
    type = json['type'];
    updatedAt = json['updatedAt'];
    viewsCount = json['viewsCount'];
    website = json['website'];
    googleMapsUrl = json['googleMapsUrl'];
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

class Pagination {
  int? page;
  int? limit;
  int? total;
  int? pages;

  Pagination({this.page, this.limit, this.total, this.pages});

  Pagination.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    limit = json['limit'];
    total = json['total'];
    pages = json['pages'];
  }
}
