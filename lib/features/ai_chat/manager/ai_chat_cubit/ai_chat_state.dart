import 'package:egy_go/features/ai_chat/data/models/ai_message_model.dart';

abstract class AiChatState {}

class AiChatInitial extends AiChatState {}

class AiChatLoading extends AiChatState {
  final List<AiMessageModel> messages;

  AiChatLoading(this.messages);
}

class AiChatLoaded extends AiChatState {
  final List<AiMessageModel> messages;

  AiChatLoaded(this.messages);
}

class AiChatError extends AiChatState {
  final String error;
  final List<AiMessageModel> messages;
  final String? failedMessage;

  AiChatError(this.error, this.messages, this.failedMessage);
}
