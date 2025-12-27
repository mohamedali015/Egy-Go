import 'package:egy_go/core/network/chat_socket_service.dart';
import 'package:egy_go/features/trip/data/models/chat_message_model.dart';

abstract class TripChatState {}

class TripChatInitial extends TripChatState {}

class TripChatLoading extends TripChatState {}

class ChatAccessChecking extends TripChatState {}

class ChatAccessDenied extends TripChatState {
  final String message;

  ChatAccessDenied(this.message);
}

class ChatAccessGranted extends TripChatState {}

class ChatMessagesLoaded extends TripChatState {
  final List<ChatMessageModel> messages;

  ChatMessagesLoaded(this.messages);
}

class ChatMessagesUpdated extends TripChatState {
  final List<ChatMessageModel> messages;
  final DateTime timestamp;

  ChatMessagesUpdated(this.messages) : timestamp = DateTime.now();
}

class ChatMessageSending extends TripChatState {
  final List<ChatMessageModel> messages;

  ChatMessageSending(this.messages);
}

class ChatError extends TripChatState {
  final String errorMessage;
  final List<ChatMessageModel> messages;

  ChatError(this.errorMessage, this.messages);
}

class ChatSocketDisconnected extends TripChatState {
  final List<ChatMessageModel> messages;

  ChatSocketDisconnected(this.messages);
}
