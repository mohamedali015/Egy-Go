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
}

class PlaceReference {
  final String id;
  final String name;
  final String? province;
  final String? category;
  final String? description;

  PlaceReference({
    required this.id,
    required this.name,
    this.province,
    this.category,
    this.description,
  });

  factory PlaceReference.fromJson(Map<String, dynamic> json) {
    return PlaceReference(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      province: json['province'],
      category: json['category'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'province': province,
      'category': category,
      'description': description,
    };
  }
}

class AiChatResponseModel {
  final bool success;
  final String? type; // "text" or "places"
  final String reply;
  final List<PlaceReference>? places;
  final String? error;

  AiChatResponseModel({
    required this.success,
    this.type,
    required this.reply,
    this.places,
    this.error,
  });

  factory AiChatResponseModel.fromJson(Map<String, dynamic> json) {
    print('[AiChatResponseModel] Parsing JSON: $json');

    final responseType = json['type'] ?? 'text';
    String replyText = '';
    List<PlaceReference>? placesList;

    if (responseType == 'text') {
      // Handle text response: content contains the text message
      replyText = json['content'] ?? json['reply'] ?? '';
    } else if (responseType == 'places') {
      // Handle places response: content contains array of places
      final contentData = json['content'];

      if (contentData is List) {
        placesList = contentData
            .map((p) => PlaceReference.fromJson(p as Map<String, dynamic>))
            .toList();

        // Create a reply text showing the places count
        replyText =
            'I found ${placesList.length} places that might interest you:';
      }
    }

    print(
        '[AiChatResponseModel] Type: $responseType, Reply: $replyText, Places: ${placesList?.length ?? 0}');

    return AiChatResponseModel(
      success: json['success'] ?? false,
      type: responseType,
      reply: replyText,
      places: placesList,
      error: json['error'],
    );
  }
}
