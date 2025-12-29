class AiMessageModel {
  final String id;
  final String message;
  final bool isUser;
  final DateTime timestamp;
  final List<PlaceReference>? places; // Added for clickable places

  AiMessageModel({
    required this.id,
    required this.message,
    required this.isUser,
    required this.timestamp,
    this.places,
  });

  factory AiMessageModel.fromJson(Map<String, dynamic> json) {
    return AiMessageModel(
      id: json['id'] ?? '',
      message: json['message'] ?? '',
      isUser: json['isUser'] ?? false,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      places: json['places'] != null
          ? (json['places'] as List)
              .map((p) => PlaceReference.fromJson(p))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
      'places': places?.map((p) => p.toJson()).toList(),
    };
  }

  // Convert to API format for conversation history
  Map<String, String> toHistoryJson() {
    return {
      'role': isUser ? 'user' : 'model',
      'content': message,
    };
  }
}

class PlaceReference {
  final String id;
  final String name;
  final String? province;
  final String? category;
  final String? description;
  final List<String>? images;
  final double? rating;
  final String? type;
  final String? slug;

  PlaceReference({
    required this.id,
    required this.name,
    this.province,
    this.category,
    this.description,
    this.images,
    this.rating,
    this.type,
    this.slug,
  });

  factory PlaceReference.fromJson(Map<String, dynamic> json) {
    // Extract province name from nested object or string
    String? provinceName;
    if (json['province'] != null) {
      if (json['province'] is Map) {
        provinceName = json['province']['name'] ?? json['province']['slug'];
      } else if (json['province'] is String) {
        provinceName = json['province'];
      }
    }

    // Extract images list
    List<String>? imagesList;
    if (json['images'] != null && json['images'] is List) {
      imagesList =
          (json['images'] as List).map((img) => img.toString()).toList();
    }

    return PlaceReference(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      province: provinceName,
      category: json['category'] ?? json['type'],
      description: json['description'],
      images: imagesList,
      rating:
          json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      type: json['type'],
      slug: json['slug'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'province': province,
      'category': category,
      'description': description,
      'images': images,
      'rating': rating,
      'type': type,
      'slug': slug,
    };
  }
}

class AiChatResponseModel {
  final bool success;
  final String? source; // "database" or "gemini"
  final String reply;
  final List<PlaceReference>? places;
  final String? error;

  AiChatResponseModel({
    required this.success,
    this.source,
    required this.reply,
    this.places,
    this.error,
  });

  factory AiChatResponseModel.fromJson(Map<String, dynamic> json) {
    print('[AiChatResponseModel] Parsing JSON: $json');

    // New API format: { success, source, reply }
    final replyText = json['reply'] ?? json['content'] ?? '';
    final source = json['source']; // 'database' or 'gemini'

    List<PlaceReference>? placesList;

    // Check multiple possible locations for places data
    if (json['places'] != null && json['places'] is List) {
      placesList = (json['places'] as List)
          .map((p) => PlaceReference.fromJson(p as Map<String, dynamic>))
          .toList();
    } else if (json['data'] != null && json['data'] is List) {
      // Backend might send places in 'data' field
      placesList = (json['data'] as List)
          .map((p) => PlaceReference.fromJson(p as Map<String, dynamic>))
          .toList();
    } else if (json['results'] != null && json['results'] is List) {
      // Or in 'results' field
      placesList = (json['results'] as List)
          .map((p) => PlaceReference.fromJson(p as Map<String, dynamic>))
          .toList();
    }

    print(
        '[AiChatResponseModel] Source: $source, Reply length: ${replyText.length}, Places: ${placesList?.length ?? 0}');

    return AiChatResponseModel(
      success: json['success'] ?? false,
      source: source,
      reply: replyText,
      places: placesList,
      error: json['error'],
    );
  }
}
