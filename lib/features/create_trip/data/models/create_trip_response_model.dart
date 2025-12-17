class CreateTripResponseModel {
  bool? success;
  String? message;
  List<Data>? data;
  Pagination? pagination;
  Trip? trip;
  String? nextStep;
  String? nextEndpoint;

  CreateTripResponseModel(
      {this.success,
      this.message,
      this.data,
      this.pagination,
      this.trip,
      this.nextStep,
      this.nextEndpoint});

  CreateTripResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    trip = json['trip'] != null ? Trip.fromJson(json['trip']) : null;
    nextStep = json['nextStep'];
    nextEndpoint = json['nextEndpoint'];
  }
}

class Data {
  Photo? photo;
  Location? location;
  String? sId;
  User? user;
  List<Provinces>? provinces;
  String? name;
  String? slug;
  bool? isVerified;
  bool? isActive;
  bool? canEnterArchaeologicalSites;
  bool? isLicensed;
  List<String>? languages;
  int? pricePerHour;
  String? bio;
  List<Documents>? documents;
  int? rating;
  int? ratingCount;
  int? totalTrips;
  List<dynamic>? gallery;
  List<dynamic>? availability;
  int? iV;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.photo,
      this.location,
      this.sId,
      this.user,
      this.provinces,
      this.name,
      this.slug,
      this.isVerified,
      this.isActive,
      this.canEnterArchaeologicalSites,
      this.isLicensed,
      this.languages,
      this.pricePerHour,
      this.bio,
      this.documents,
      this.rating,
      this.ratingCount,
      this.totalTrips,
      this.gallery,
      this.availability,
      this.iV,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    photo = json['photo'] != null ? Photo.fromJson(json['photo']) : null;
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    sId = json['_id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    if (json['provinces'] != null) {
      provinces = <Provinces>[];
      json['provinces'].forEach((v) {
        provinces!.add(Provinces.fromJson(v));
      });
    }
    name = json['name'];
    slug = json['slug'];
    isVerified = json['isVerified'];
    isActive = json['isActive'];
    canEnterArchaeologicalSites = json['canEnterArchaeologicalSites'];
    isLicensed = json['isLicensed'];
    languages = json['languages'].cast<String>();
    pricePerHour = json['pricePerHour'];
    bio = json['bio'];
    if (json['documents'] != null) {
      documents = <Documents>[];
      json['documents'].forEach((v) {
        documents!.add(Documents.fromJson(v));
      });
    }
    rating = json['rating'];
    ratingCount = json['ratingCount'];
    totalTrips = json['totalTrips'];
    gallery = json['gallery'];
    availability = json['availability'];
    iV = json['__v'];
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

class Location {
  String? type;
  List<double>? coordinates;

  Location({this.type, this.coordinates});

  Location.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
  }
}

class User {
  String? sId;
  String? email;
  String? name;

  User({this.sId, this.email, this.name});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    email = json['email'];
    name = json['name'];
  }
}

class Provinces {
  String? sId;
  String? slug;
  String? name;
  String? id;

  Provinces({this.sId, this.slug, this.name, this.id});

  Provinces.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    slug = json['slug'];
    name = json['name'];
    id = json['id'];
  }
}

class Documents {
  String? url;
  String? publicId;
  String? type;
  String? status;
  String? sId;
  String? uploadedAt;

  Documents(
      {this.url,
      this.publicId,
      this.type,
      this.status,
      this.sId,
      this.uploadedAt});

  Documents.fromJson(Map<String, dynamic> json) {
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

class Trip {
  String? tourist;
  String? guide;
  String? selectedGuide;
  List<dynamic>? candidateGuides;
  List<dynamic>? callSessions;
  List<dynamic>? itinerary;
  String? startAt;
  int? totalDurationMinutes;
  Location? meetingPoint;
  String? meetingAddress;
  String? provinceId;
  String? paymentStatus;
  String? stripeSessionId;
  String? stripePaymentIntentId;
  String? currency;
  String? status;
  Meta? meta;
  List<dynamic>? offers;
  List<dynamic>? proposalHistory;
  Review? review;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Trip(
      {this.tourist,
      this.guide,
      this.selectedGuide,
      this.candidateGuides,
      this.callSessions,
      this.itinerary,
      this.startAt,
      this.totalDurationMinutes,
      this.meetingPoint,
      this.meetingAddress,
      this.provinceId,
      this.paymentStatus,
      this.stripeSessionId,
      this.stripePaymentIntentId,
      this.currency,
      this.status,
      this.meta,
      this.offers,
      this.proposalHistory,
      this.review,
      this.sId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Trip.fromJson(Map<String, dynamic> json) {
    tourist = json['tourist'];
    guide = json['guide'];
    selectedGuide = json['selectedGuide'];
    candidateGuides = json['candidateGuides'];
    callSessions = json['callSessions'];
    itinerary = json['itinerary'];
    startAt = json['startAt'];
    totalDurationMinutes = json['totalDurationMinutes'];
    meetingPoint = json['meetingPoint'] != null
        ? Location.fromJson(json['meetingPoint'])
        : null;
    meetingAddress = json['meetingAddress'];
    provinceId = json['provinceId'];
    paymentStatus = json['paymentStatus'];
    stripeSessionId = json['stripeSessionId'];
    stripePaymentIntentId = json['stripePaymentIntentId'];
    currency = json['currency'];
    status = json['status'];
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    offers = json['offers'];
    proposalHistory = json['proposalHistory'];
    review = json['review'] != null ? Review.fromJson(json['review']) : null;
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }
}

class Meta {
  String? createdFromPlaceId;
  String? agreementSource;

  Meta({this.createdFromPlaceId, this.agreementSource});

  Meta.fromJson(Map<String, dynamic> json) {
    createdFromPlaceId = json['createdFromPlaceId'];
    agreementSource = json['agreementSource'];
  }
}

class Review {
  double? rating;
  String? comment;
  String? reviewedAt;

  Review({this.rating, this.comment, this.reviewedAt});

  Review.fromJson(Map<String, dynamic> json) {
    rating = json['rating'];
    comment = json['comment'];
    reviewedAt = json['reviewedAt'];
  }
}
