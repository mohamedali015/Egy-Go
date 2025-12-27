import 'package:dartz/dartz.dart';
import 'package:egy_go/features/trip/data/models/chat_message_model.dart';

abstract class ChatRepo {
  /// Check if user has access to chat for this trip
  Future<Either<String, ChatAccessResponseModel>> checkChatAccess(
      String tripId);

  /// Get message history for a trip
  Future<Either<String, ChatMessagesResponseModel>> getChatMessages(
      String tripId);
}
