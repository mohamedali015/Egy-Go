class ChatMessageModel {
  final String id;
  final String tripId;
  final String senderId;
  final String senderRole;
  final String message;
  final String createdAt;

  ChatMessageModel({
    required this.id,
    required this.tripId,
    required this.senderId,
    required this.senderRole,
    required this.message,
    required this.createdAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    // Backend returns messages in this format:
    // {
    //   "_id": "...",
    //   "sender": {"user": "userId", "role": "tourist"},
    //   "receiver": {"user": "userId", "role": "guide"},
    //   "message": "text",
    //   "createdAt": "..."
    // }

    final senderId = json['sender']?['user'] ?? json['senderId'] ?? '';
    final senderRole = json['sender']?['role'] ?? json['senderRole'] ?? '';

    // For tripId, we might need to extract it differently
    final tripId = json['tripId'] ?? json['trip'] ?? '';

    return ChatMessageModel(
      id: json['_id'] ?? json['id'] ?? '',
      tripId: tripId,
      senderId: senderId,
      senderRole: senderRole,
      message: json['message'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'tripId': tripId,
      'senderId': senderId,
      'senderRole': senderRole,
      'message': message,
      'createdAt': createdAt,
    };
  }
}

class ChatAccessResponseModel {
  final bool success;
  final bool hasAccess;
  final String? message;

  ChatAccessResponseModel({
    required this.success,
    required this.hasAccess,
    this.message,
  });

  factory ChatAccessResponseModel.fromJson(Map<String, dynamic> json) {
    // Debug logging
    print('[ChatAccessResponseModel] 🔍 Parsing response:');
    print('[ChatAccessResponseModel] - Full JSON: $json');
    print('[ChatAccessResponseModel] - json[\'data\']: ${json['data']}');

    // The backend returns: {success: true, data: {canAccess: true, tripId: ...}}
    // So we need to access json['data']['canAccess']
    final dataObject = json['data'];
    final canAccessValue = dataObject != null ? dataObject['canAccess'] : null;

    print(
        '[ChatAccessResponseModel] - canAccess value: $canAccessValue (type: ${canAccessValue.runtimeType})');

    // Convert to bool explicitly
    final hasAccessBool = canAccessValue == true;
    print('[ChatAccessResponseModel] - hasAccess final: $hasAccessBool');

    return ChatAccessResponseModel(
      success: json['success'] == true,
      hasAccess: hasAccessBool,
      message: json['message']?.toString(),
    );
  }
}

class ChatMessagesResponseModel {
  final bool success;
  final List<ChatMessageModel>? messages;

  ChatMessagesResponseModel({
    required this.success,
    this.messages,
  });

  factory ChatMessagesResponseModel.fromJson(Map<String, dynamic> json) {
    print('[ChatMessagesResponseModel] 📨 Parsing messages response');
    print('[ChatMessagesResponseModel] - Success: ${json['success']}');

    final messagesList = json['data']?['messages'] as List? ?? [];
    print(
        '[ChatMessagesResponseModel] - Found ${messagesList.length} messages');

    final parsedMessages = messagesList.map((msg) {
      try {
        return ChatMessageModel.fromJson(msg as Map<String, dynamic>);
      } catch (e) {
        print('[ChatMessagesResponseModel] ❌ Error parsing message: $e');
        print('[ChatMessagesResponseModel] - Message data: $msg');
        rethrow;
      }
    }).toList();

    print(
        '[ChatMessagesResponseModel] - Successfully parsed ${parsedMessages.length} messages');

    return ChatMessagesResponseModel(
      success: json['success'] ?? false,
      messages: parsedMessages,
    );
  }
}
