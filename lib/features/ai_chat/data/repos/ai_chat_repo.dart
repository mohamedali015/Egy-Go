import 'package:dartz/dartz.dart';
import 'package:egy_go/features/ai_chat/data/models/ai_message_model.dart';

abstract class AiChatRepo {
  /// Send a message to the AI assistant and get a response
  Future<Either<String, AiChatResponseModel>> sendMessage(String message);
}
