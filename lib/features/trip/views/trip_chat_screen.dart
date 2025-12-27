import 'package:egy_go/core/helper/get_it.dart';
import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/shared_widgets/custom_loading_indicator.dart';
import 'package:egy_go/core/utils/app_colors.dart';
import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:egy_go/features/trip/data/models/chat_message_model.dart';
import 'package:egy_go/features/trip/data/models/trips_response_model.dart';
import 'package:egy_go/features/trip/data/repos/chat_repo.dart';
import 'package:egy_go/features/trip/manager/trip_chat_cubit/trip_chat_cubit.dart';
import 'package:egy_go/features/trip/manager/trip_chat_cubit/trip_chat_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TripChatScreen extends StatefulWidget {
  const TripChatScreen({super.key, required this.tripId, this.guide});

  final String tripId;
  final TripGuide? guide;
  static const String routeName = "tripChat";

  @override
  State<TripChatScreen> createState() => _TripChatScreenState();
}

class _TripChatScreenState extends State<TripChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(Duration(milliseconds: 300), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TripChatCubit(getIt<ChatRepo>())..initializeChat(widget.tripId),
      child: Scaffold(
        appBar: AppBar(
          title: widget.guide != null
              ? Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundImage: widget.guide!.photo?.url != null
                          ? NetworkImage(widget.guide!.photo!.url!)
                          : null,
                      child: widget.guide!.photo?.url == null
                          ? Icon(Icons.person, size: 20)
                          : null,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.guide!.name ?? 'Guide',
                            style: AppTextStyles.semiBold16,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (widget.guide!.isVerified == true)
                            Row(
                              children: [
                                Icon(Icons.verified,
                                    size: 12, color: Colors.blue),
                                SizedBox(width: 4),
                                Text(
                                  'Verified Guide',
                                  style: AppTextStyles.regular11.copyWith(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                )
              : Text(
                  'Chat with Guide',
                  style: AppTextStyles.semiBold20,
                ),
          centerTitle: widget.guide == null,
          actions: widget.guide != null
              ? [
                  Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Center(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: widget.guide!.isActive == true
                              ? Colors.green.withValues(alpha: 0.1)
                              : Colors.grey.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          widget.guide!.isActive == true ? 'Online' : 'Offline',
                          style: AppTextStyles.regular12.copyWith(
                            color: widget.guide!.isActive == true
                                ? Colors.green[700]
                                : Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ]
              : null,
        ),
        body: BlocConsumer<TripChatCubit, TripChatState>(
          listener: (context, state) {
            if (state is ChatMessagesLoaded || state is ChatMessagesUpdated) {
              _scrollToBottom();
            }

            if (state is ChatError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: Colors.red,
                ),
              );
            }

            if (state is ChatSocketDisconnected) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Chat disconnected. Messages may not be sent.'),
                  backgroundColor: Colors.orange,
                  duration: Duration(seconds: 3),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ChatAccessChecking || state is TripChatLoading) {
              return CustomLoadingIndicator();
            }

            if (state is ChatAccessDenied) {
              return _buildAccessDenied(state.message);
            }

            // Show chat UI for all states that have access
            if (state is ChatMessagesLoaded ||
                state is ChatMessagesUpdated ||
                state is ChatMessageSending ||
                state is ChatError ||
                state is ChatSocketDisconnected) {
              final cubit = context.read<TripChatCubit>();
              final messages = cubit.messages;
              final isSocketConnected = cubit.isSocketConnected;

              return Column(
                children: [
                  // Connection status banner
                  if (!isSocketConnected)
                    Container(
                      width: double.infinity,
                      padding: MyResponsive.paddingSymmetric(
                          horizontal: 16, vertical: 8),
                      color: Colors.orange.withValues(alpha: 0.2),
                      child: Row(
                        children: [
                          Icon(Icons.warning_amber_rounded,
                              color: Colors.orange, size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Chat is offline. Reconnecting...',
                              style: AppTextStyles.medium12
                                  .copyWith(color: Colors.orange[800]),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Messages list
                  Expanded(
                    child: messages.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            controller: _scrollController,
                            padding: MyResponsive.paddingSymmetric(
                                horizontal: 16, vertical: 16),
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final message = messages[index];
                              final isMyMessage = cubit.isMyMessage(message);
                              return _buildMessageBubble(message, isMyMessage);
                            },
                          ),
                  ),

                  // Message input
                  _buildMessageInput(context, isSocketConnected),
                ],
              );
            }

            return CustomLoadingIndicator();
          },
        ),
      ),
    );
  }

  Widget _buildAccessDenied(String message) {
    return Center(
      child: Padding(
        padding: MyResponsive.paddingSymmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.block, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text(
              'Access Denied',
              style: AppTextStyles.bold20,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              message,
              style: AppTextStyles.regular14,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No messages yet',
            style: AppTextStyles.semiBold16,
          ),
          SizedBox(height: 8),
          Text(
            'Start chatting with your guide',
            style: AppTextStyles.regular14.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessageModel message, bool isMyMessage) {
    final time = _formatMessageTime(message.createdAt);

    return Align(
      alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: MyResponsive.paddingOnly(bottom: 12),
        padding: MyResponsive.paddingSymmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MyResponsive.width(value: 280),
        ),
        decoration: BoxDecoration(
          color: isMyMessage ? AppColors.primary : Colors.grey[200],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(MyResponsive.radius(value: 16)),
            topRight: Radius.circular(MyResponsive.radius(value: 16)),
            bottomLeft: isMyMessage
                ? Radius.circular(MyResponsive.radius(value: 16))
                : Radius.zero,
            bottomRight: isMyMessage
                ? Radius.zero
                : Radius.circular(MyResponsive.radius(value: 16)),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.message,
              style: AppTextStyles.regular14.copyWith(
                color: isMyMessage ? Colors.white : Colors.black87,
              ),
            ),
            SizedBox(height: 4),
            Text(
              time,
              style: AppTextStyles.regular11.copyWith(
                color: isMyMessage ? Colors.white70 : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context, bool isSocketConnected) {
    return Container(
      padding: MyResponsive.paddingSymmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              enabled: isSocketConnected,
              decoration: InputDecoration(
                hintText: isSocketConnected
                    ? 'Type a message...'
                    : 'Chat is offline...',
                hintStyle: AppTextStyles.regular14.copyWith(
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(MyResponsive.radius(value: 24)),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(MyResponsive.radius(value: 24)),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(MyResponsive.radius(value: 24)),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
                contentPadding:
                    MyResponsive.paddingSymmetric(horizontal: 16, vertical: 12),
              ),
              maxLines: null,
              maxLength: 5000,
              buildCounter: (context,
                      {required currentLength,
                      required isFocused,
                      maxLength}) =>
                  null,
            ),
          ),
          SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: isSocketConnected ? AppColors.primary : Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.send, color: Colors.white),
              onPressed: isSocketConnected
                  ? () {
                      final message = _messageController.text;
                      if (message.trim().isNotEmpty) {
                        context
                            .read<TripChatCubit>()
                            .sendMessage(widget.tripId, message);
                        _messageController.clear();
                      }
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  String _formatMessageTime(String createdAt) {
    try {
      final dateTime = DateTime.parse(createdAt);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

      if (messageDate == today) {
        // Use 12-hour format with AM/PM
        return DateFormat('hh:mm a').format(dateTime);
      } else {
        // Show date with 12-hour time
        return DateFormat('MMM dd, hh:mm a').format(dateTime);
      }
    } catch (e) {
      return '';
    }
  }
}
