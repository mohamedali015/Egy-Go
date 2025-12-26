class TripGuidesResponseModel {
  bool? success;
  List<Guide>? guides;
  Pagination? pagination;
  TripInfo? trip;

  TripGuidesResponseModel({
    this.success,
    this.guides,
    this.pagination,
    this.trip,
  });

  TripGuidesResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      guides = <Guide>[];
      json['data'].forEach((v) {
        guides!.add(Guide.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    trip = json['trip'] != null ? TripInfo.fromJson(json['trip']) : null;
  }
}

class Guide {
  String? sId;
  String? name;
  String? slug;
  bool? isVerified;
  bool? isActive;
  bool? canEnterArchaeologicalSites;
  bool? isLicensed;
  List<String>? languages;
  int? pricePerHour;
  String? bio;
  double? rating;
  int? ratingCount;
  int? totalTrips;
  Photo? photo;
  GuideLocation? location;
  GuideUser? user;
  List<Province>? provinces;
  List<Document>? documents;
  List<dynamic>? gallery;
  List<dynamic>? availability;
  String? createdAt;
  String? updatedAt;

  Guide({
    this.sId,
    this.name,
    this.slug,
    this.isVerified,
    this.isActive,
    this.canEnterArchaeologicalSites,
    this.isLicensed,
    this.languages,
    this.pricePerHour,
    this.bio,
    this.rating,
    this.ratingCount,
    this.totalTrips,
    this.photo,
    this.location,
    this.user,
    this.provinces,
    this.documents,
    this.gallery,
    this.availability,
    this.createdAt,
    this.updatedAt,
  });

  Guide.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    slug = json['slug'];
    isVerified = json['isVerified'];
    isActive = json['isActive'];
    canEnterArchaeologicalSites = json['canEnterArchaeologicalSites'];
    isLicensed = json['isLicensed'];
    if (json['languages'] != null && json['languages'] is List) {
      languages = (json['languages'] as List)
          .where((lang) => lang != null)
          .map((lang) => lang.toString())
          .toList();
    }
    pricePerHour = json['pricePerHour'];
    bio = json['bio'];
    rating = json['rating']?.toDouble();
    ratingCount = json['ratingCount'];
    totalTrips = json['totalTrips'];
    photo = json['photo'] != null ? Photo.fromJson(json['photo']) : null;
    location = json['location'] != null
        ? GuideLocation.fromJson(json['location'])
        : null;
    user = json['user'] != null ? GuideUser.fromJson(json['user']) : null;
    if (json['provinces'] != null) {
      provinces = <Province>[];
      json['provinces'].forEach((v) {
        provinces!.add(Province.fromJson(v));
      });
    }
    if (json['documents'] != null) {
      documents = <Document>[];
      json['documents'].forEach((v) {
        documents!.add(Document.fromJson(v));
      });
    }
    gallery = json['gallery'];
    availability = json['availability'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
}

class Photo {
  String? url;
  String? publicId;

  Photo({this.url, this.publicId});

  Photo.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    publicId = json['publicId'];
  }
}

class GuideLocation {
  String? type;
  List<double>? coordinates;

  GuideLocation({this.type, this.coordinates});

  GuideLocation.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    if (json['coordinates'] != null) {
      coordinates = json['coordinates'].cast<double>();
    }
  }
}

class GuideUser {
  String? sId;
  String? email;
  String? name;

  GuideUser({this.sId, this.email, this.name});

  GuideUser.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    email = json['email'];
    name = json['name'];
  }
}

class Province {
  String? sId;
  String? slug;
  String? name;
  String? id;

  Province({this.sId, this.slug, this.name, this.id});

  Province.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    slug = json['slug'];
    name = json['name'];
    id = json['id'];
  }
}

class Document {
  String? url;
  String? publicId;
  String? type;
  String? status;
  String? sId;
  String? uploadedAt;

  Document({
    this.url,
    this.publicId,
    this.type,
    this.status,
    this.sId,
    this.uploadedAt,
  });

  Document.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    publicId = json['publicId'];
    type = json['type'];
    status = json['status'];
    sId = json['_id'];
    uploadedAt = json['uploadedAt'];
  }
}

class Pagination {
  int? total;
  int? page;
  int? pages;

  Pagination({this.total, this.page, this.pages});

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    page = json['page'];
    pages = json['pages'];
  }
}

class TripInfo {
  String? id;
  String? startAt;
  String? meetingAddress;
  String? status;

  TripInfo({this.id, this.startAt, this.meetingAddress, this.status});

  TripInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startAt = json['startAt'];
    meetingAddress = json['meetingAddress'];
    status = json['status'];
  }
}
