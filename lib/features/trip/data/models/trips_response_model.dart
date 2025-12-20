class TripsResponseModel {
  bool? success;
  List<TripModel>? trips;

  TripsResponseModel({this.success, this.trips});

  TripsResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      trips = <TripModel>[];
      (json['data'] as List).forEach((v) {
        trips!.add(TripModel.fromJson(v as Map<String, dynamic>));
      });
    }
  }
}

class TripModel {
  String? sId;
  TouristInfo? tourist;
  TripGuide? guide;
  TripGuide? selectedGuide;
  List<String>? candidateGuides;
  List<dynamic>? callSessions;
  List<dynamic>? itinerary;
  String? startAt;
  int? totalDurationMinutes;
  String? meetingAddress;
  String? provinceId;
  String? paymentStatus;
  String? stripeSessionId;
  String? stripePaymentIntentId;
  String? currency;
  String? status;
  String? createdAt;
  String? updatedAt;
  MeetingPoint? meetingPoint;
  Meta? meta;
  Review? review;
  String? cancellationReason;
  String? cancelledAt;
  String? cancelledBy;

  TripModel({
    this.sId,
    this.tourist,
    this.guide,
    this.selectedGuide,
    this.candidateGuides,
    this.callSessions,
    this.itinerary,
    this.startAt,
    this.totalDurationMinutes,
    this.meetingAddress,
    this.provinceId,
    this.paymentStatus,
    this.stripeSessionId,
    this.stripePaymentIntentId,
    this.currency,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.meetingPoint,
    this.meta,
    this.review,
    this.cancellationReason,
    this.cancelledAt,
    this.cancelledBy,
  });

  TripModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];

    // Parse tourist - check if it's a Map
    if (json['tourist'] != null && json['tourist'] is Map) {
      tourist = TouristInfo.fromJson(json['tourist'] as Map<String, dynamic>);
    }

    // Parse guide - can be null, check if it's a Map
    if (json['guide'] != null && json['guide'] is Map) {
      guide = TripGuide.fromJson(json['guide'] as Map<String, dynamic>);
    }

    // Parse selectedGuide - can be null, check if it's a Map
    if (json['selectedGuide'] != null && json['selectedGuide'] is Map) {
      selectedGuide =
          TripGuide.fromJson(json['selectedGuide'] as Map<String, dynamic>);
    }

    // Parse candidateGuides - array of strings
    if (json['candidateGuides'] != null && json['candidateGuides'] is List) {
      candidateGuides =
          (json['candidateGuides'] as List).map((e) => e.toString()).toList();
    }

    callSessions = json['callSessions'];
    itinerary = json['itinerary'];
    startAt = json['startAt'];
    totalDurationMinutes = json['totalDurationMinutes'];
    meetingAddress = json['meetingAddress'];
    provinceId = json['provinceId'];
    paymentStatus = json['paymentStatus'];
    stripeSessionId = json['stripeSessionId'];
    stripePaymentIntentId = json['stripePaymentIntentId'];
    currency = json['currency'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];

    // Parse meetingPoint - check if it's a Map
    if (json['meetingPoint'] != null && json['meetingPoint'] is Map) {
      meetingPoint =
          MeetingPoint.fromJson(json['meetingPoint'] as Map<String, dynamic>);
    }

    // Parse meta - check if it's a Map
    if (json['meta'] != null && json['meta'] is Map) {
      meta = Meta.fromJson(json['meta'] as Map<String, dynamic>);
    }

    // Parse review - check if it's a Map
    if (json['review'] != null && json['review'] is Map) {
      review = Review.fromJson(json['review'] as Map<String, dynamic>);
    }

    cancellationReason = json['cancellationReason'];
    cancelledAt = json['cancelledAt'];
    cancelledBy = json['cancelledBy'];
  }
}

class TouristInfo {
  String? sId;
  String? email;
  String? name;
  String? phone;

  TouristInfo({this.sId, this.email, this.name, this.phone});

  TouristInfo.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    email = json['email'];
    name = json['name'];
    phone = json['phone'];
  }
}

class TripGuide {
  String? sId;
  GuideUser? user;
  List<String>? provinces;
  String? name;
  String? slug;
  bool? isVerified;
  bool? isActive;
  bool? canEnterArchaeologicalSites;
  bool? isLicensed;
  List<String>? languages;
  int? pricePerHour;
  String? bio;
  GuidePhoto? photo;
  GuideLocation? location;
  List<GuideDocument>? documents;
  double? rating;
  int? ratingCount;
  int? totalTrips;
  List<dynamic>? gallery;
  List<dynamic>? availability;
  String? createdAt;
  String? updatedAt;

  TripGuide({
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
    this.photo,
    this.location,
    this.documents,
    this.rating,
    this.ratingCount,
    this.totalTrips,
    this.gallery,
    this.availability,
    this.createdAt,
    this.updatedAt,
  });

  TripGuide.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];

    // Parse user - check if it's a Map
    if (json['user'] != null && json['user'] is Map) {
      user = GuideUser.fromJson(json['user'] as Map<String, dynamic>);
    }

    // Parse provinces - array of strings
    if (json['provinces'] != null && json['provinces'] is List) {
      provinces = (json['provinces'] as List).map((e) => e.toString()).toList();
    }

    name = json['name'];
    slug = json['slug'];
    isVerified = json['isVerified'];
    isActive = json['isActive'];
    canEnterArchaeologicalSites = json['canEnterArchaeologicalSites'];
    isLicensed = json['isLicensed'];

    // Parse languages - array of strings
    if (json['languages'] != null && json['languages'] is List) {
      languages = (json['languages'] as List).map((e) => e.toString()).toList();
    }

    pricePerHour = json['pricePerHour'];
    bio = json['bio'];

    // Parse photo - check if it's a Map
    if (json['photo'] != null && json['photo'] is Map) {
      photo = GuidePhoto.fromJson(json['photo'] as Map<String, dynamic>);
    }

    // Parse location - check if it's a Map
    if (json['location'] != null && json['location'] is Map) {
      location =
          GuideLocation.fromJson(json['location'] as Map<String, dynamic>);
    }

    // Parse documents array
    if (json['documents'] != null && json['documents'] is List) {
      documents = <GuideDocument>[];
      (json['documents'] as List).forEach((v) {
        if (v is Map) {
          documents!.add(GuideDocument.fromJson(v as Map<String, dynamic>));
        }
      });
    }

    rating = json['rating']?.toDouble();
    ratingCount = json['ratingCount'];
    totalTrips = json['totalTrips'];
    gallery = json['gallery'];
    availability = json['availability'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
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

class GuidePhoto {
  String? url;
  String? publicId;

  GuidePhoto({this.url, this.publicId});

  GuidePhoto.fromJson(Map<String, dynamic> json) {
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
    if (json['coordinates'] != null && json['coordinates'] is List) {
      try {
        final coordsList = json['coordinates'] as List;
        coordinates = coordsList.map((e) {
          if (e is num) {
            return e.toDouble();
          } else if (e is String) {
            return double.tryParse(e) ?? 0.0;
          }
          return 0.0;
        }).toList();
      } catch (e) {
        coordinates = null;
      }
    }
  }
}

class GuideDocument {
  String? url;
  String? publicId;
  String? type;
  String? status;
  String? sId;
  String? uploadedAt;

  GuideDocument({
    this.url,
    this.publicId,
    this.type,
    this.status,
    this.sId,
    this.uploadedAt,
  });

  GuideDocument.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    publicId = json['publicId'];
    type = json['type'];
    status = json['status'];
    sId = json['_id'];
    uploadedAt = json['uploadedAt'];
  }
}

class MeetingPoint {
  String? type;
  List<double>? coordinates;

  MeetingPoint({this.type, this.coordinates});

  MeetingPoint.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    if (json['coordinates'] != null && json['coordinates'] is List) {
      try {
        final coordsList = json['coordinates'] as List;
        coordinates = coordsList.map((e) {
          if (e is num) {
            return e.toDouble();
          } else if (e is String) {
            return double.tryParse(e) ?? 0.0;
          }
          return 0.0;
        }).toList();
      } catch (e) {
        coordinates = null;
      }
    }
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
  dynamic rating;
  String? comment;
  String? reviewedAt;

  Review({this.rating, this.comment, this.reviewedAt});

  Review.fromJson(Map<String, dynamic> json) {
    rating = json['rating'];
    comment = json['comment'];
    reviewedAt = json['reviewedAt'];
  }
}
