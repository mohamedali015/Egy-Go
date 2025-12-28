import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/shared_widgets/svg_wrapper.dart';
import 'package:egy_go/core/utils/app_assets.dart';
import 'package:egy_go/core/utils/app_colors.dart';
import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:egy_go/features/ai_chat/data/models/ai_message_model.dart';
import 'package:egy_go/features/ai_chat/manager/ai_chat_cubit/ai_chat_cubit.dart';
import 'package:egy_go/features/ai_chat/manager/ai_chat_cubit/ai_chat_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AiChatView extends StatefulWidget {
  const AiChatView({super.key});

  @override
  State<AiChatView> createState() => _AiChatViewState();
}

class _AiChatViewState extends State<AiChatView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<AiChatCubit>().initializeChat();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      context.read<AiChatCubit>().sendMessage(message);
      _messageController.clear();
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: AppColors.primary,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.white,
              child: SvgWrapper(
                path: AppAssets.nefertiti,
                width: MyResponsive.fontSize(value: 30),
              ),
            ),
            SizedBox(width: MyResponsive.width(value: 12)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nefertiti',
                    style: TextStyle(
                      fontSize: MyResponsive.fontSize(value: 18),
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  Text(
                    'Your Smart Tour Guide',
                    style: TextStyle(
                      fontSize: MyResponsive.fontSize(value: 12),
                      color: AppColors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: AppColors.white),
            onPressed: () {
              context.read<AiChatCubit>().clearChat();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<AiChatCubit, AiChatState>(
              listener: (context, state) {
                _scrollToBottom();
              },
              builder: (context, state) {
                List<AiMessageModel> messages = [];
                bool showRetryButton = false;

                if (state is AiChatLoaded) {
                  messages = state.messages;
                } else if (state is AiChatLoading) {
                  messages = state.messages;
                } else if (state is AiChatError) {
                  messages = state.messages;
                  showRetryButton = state.failedMessage != null;
                }

                if (messages.isEmpty) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  );
                }

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.all(MyResponsive.width(value: 16)),
                        itemCount:
                            messages.length + (state is AiChatLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (state is AiChatLoading &&
                              index == messages.length) {
                            return _buildTypingIndicator();
                          }
                          return _buildMessageBubble(messages[index]);
                        },
                      ),
                    ),
                    if (showRetryButton) _buildRetryButton(context),
                  ],
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(AiMessageModel message) {
    return Column(
      crossAxisAlignment:
          message.isUser ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        // Show text message
        Align(
          alignment:
              message.isUser ? Alignment.centerLeft : Alignment.centerRight,
          child: Container(
            margin: EdgeInsets.only(bottom: MyResponsive.height(value: 12)),
            padding: EdgeInsets.symmetric(
              horizontal: MyResponsive.width(value: 16),
              vertical: MyResponsive.height(value: 12),
            ),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            decoration: BoxDecoration(
              color: message.isUser ? AppColors.primary : AppColors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(MyResponsive.width(value: 16)),
                topRight: Radius.circular(MyResponsive.width(value: 16)),
                bottomLeft: message.isUser
                    ? Radius.circular(MyResponsive.width(value: 16))
                    : Radius.zero,
                bottomRight: message.isUser
                    ? Radius.zero
                    : Radius.circular(MyResponsive.width(value: 16)),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.message,
                  style: TextStyle(
                    fontSize: MyResponsive.fontSize(value: 14),
                    color: message.isUser ? AppColors.white : AppColors.black,
                  ),
                ),
                SizedBox(height: MyResponsive.height(value: 4)),
                Text(
                  DateFormat('HH:mm').format(message.timestamp),
                  style: TextStyle(
                    fontSize: MyResponsive.fontSize(value: 10),
                    color: message.isUser
                        ? AppColors.white.withValues(alpha: 0.7)
                        : AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Show place cards if available
        if (!message.isUser &&
            message.places != null &&
            message.places!.isNotEmpty)
          ...message.places!
              .map((placeRef) => _buildPlaceCard(placeRef))
              .toList(),
      ],
    );
  }

  Widget _buildPlaceCard(PlaceReference placeRef) {
    return Container(
      margin: EdgeInsets.only(
        bottom: MyResponsive.height(value: 12),
        left: MyResponsive.width(value: 16),
        right: MyResponsive.width(value: 16),
      ),
      child: Container(
        height: MyResponsive.height(value: 200),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(MyResponsive.radius(value: 16)),
          border: Border.all(
            color: AppColors.black.withValues(alpha: .2),
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            // Background gradient (since we don't have image URL from backend)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary.withValues(alpha: 0.8),
                      AppColors.primary,
                    ],
                  ),
                ),
              ),
            ),
            // Dark overlay for better text readability
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.6),
                    ],
                    stops: const [0.3, 1.0],
                  ),
                ),
              ),
            ),
            // Category icon
            Positioned(
              top: MyResponsive.height(value: 16),
              right: MyResponsive.width(value: 16),
              child: Container(
                padding: EdgeInsets.all(MyResponsive.width(value: 10)),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.25),
                  borderRadius:
                      BorderRadius.circular(MyResponsive.radius(value: 10)),
                ),
                child: Icon(
                  _getCategoryIcon(placeRef.category),
                  color: AppColors.white,
                  size: MyResponsive.fontSize(value: 28),
                ),
              ),
            ),
            // Place info
            Positioned(
              left: MyResponsive.width(value: 16),
              right: MyResponsive.width(value: 16),
              bottom: MyResponsive.height(value: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Place name
                  Text(
                    placeRef.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bold20.copyWith(
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: MyResponsive.height(value: 8)),
                  // Location
                  if (placeRef.province != null)
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.white.withValues(alpha: 0.95),
                          size: MyResponsive.fontSize(value: 16),
                        ),
                        SizedBox(width: MyResponsive.width(value: 6)),
                        Expanded(
                          child: Text(
                            placeRef.province!,
                            style: AppTextStyles.medium14.copyWith(
                              color: Colors.white.withValues(alpha: .95),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  // Description (if available)
                  if (placeRef.description != null &&
                      placeRef.description!.isNotEmpty) ...[
                    SizedBox(height: MyResponsive.height(value: 6)),
                    Text(
                      placeRef.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.regular12.copyWith(
                        color: Colors.white.withValues(alpha: .85),
                        height: 1.3,
                      ),
                    ),
                  ],
                  SizedBox(height: MyResponsive.height(value: 8)),
                  // Category badge
                  if (placeRef.category != null)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: MyResponsive.width(value: 10),
                        vertical: MyResponsive.height(value: 5),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(
                            MyResponsive.radius(value: 12)),
                        border: Border.all(
                          color: AppColors.white.withValues(alpha: 0.4),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getCategoryIcon(placeRef.category),
                            size: MyResponsive.fontSize(value: 12),
                            color: Colors.white,
                          ),
                          SizedBox(width: MyResponsive.width(value: 4)),
                          Text(
                            _getCategoryName(placeRef.category!),
                            style: AppTextStyles.medium12.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String? category) {
    switch (category?.toLowerCase()) {
      case 'archaeological':
        return Icons.account_balance;
      case 'entertainment':
        return Icons.celebration;
      case 'hotel':
      case 'hotels':
        return Icons.hotel;
      case 'event':
      case 'events':
        return Icons.event;
      default:
        return Icons.place;
    }
  }

  String _getCategoryName(String category) {
    switch (category.toLowerCase()) {
      case 'archaeological':
        return 'archaeological';
      case 'entertainment':
        return 'entertainment';
      case 'hotel':
      case 'hotels':
        return 'hotel';
      case 'event':
      case 'events':
        return 'event';
      default:
        return category;
    }
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(bottom: MyResponsive.height(value: 12)),
        padding: EdgeInsets.symmetric(
          horizontal: MyResponsive.width(value: 16),
          vertical: MyResponsive.height(value: 12),
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(MyResponsive.width(value: 16)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDot(0),
            SizedBox(width: MyResponsive.width(value: 4)),
            _buildDot(1),
            SizedBox(width: MyResponsive.width(value: 4)),
            _buildDot(2),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return TweenAnimationBuilder(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600),
      builder: (context, double value, child) {
        return Opacity(
          opacity: (value + index * 0.3) % 1.0,
          child: Container(
            width: MyResponsive.width(value: 8),
            height: MyResponsive.height(value: 8),
            decoration: BoxDecoration(
              color: AppColors.grey,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(MyResponsive.width(value: 12)),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type your message here...',
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(MyResponsive.width(value: 24)),
                    borderSide: BorderSide(color: AppColors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(MyResponsive.width(value: 24)),
                    borderSide: BorderSide(
                        color: AppColors.grey.withValues(alpha: 0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(MyResponsive.width(value: 24)),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: MyResponsive.width(value: 16),
                    vertical: MyResponsive.height(value: 12),
                  ),
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            SizedBox(width: MyResponsive.width(value: 8)),
            CircleAvatar(
              backgroundColor: AppColors.primary,
              radius: MyResponsive.width(value: 24),
              child: IconButton(
                icon: Icon(
                  Icons.send,
                  color: AppColors.white,
                  size: MyResponsive.fontSize(value: 20),
                ),
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRetryButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MyResponsive.width(value: 16),
        vertical: MyResponsive.height(value: 8),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            color: AppColors.red,
            size: MyResponsive.fontSize(value: 40),
          ),
          SizedBox(height: MyResponsive.height(value: 8)),
          ElevatedButton.icon(
            onPressed: () {
              context.read<AiChatCubit>().retryLastMessage();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(
                vertical: MyResponsive.height(value: 12),
                horizontal: MyResponsive.width(value: 24),
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(MyResponsive.width(value: 24)),
              ),
            ),
            icon: Icon(
              Icons.refresh,
              color: AppColors.white,
              size: MyResponsive.fontSize(value: 18),
            ),
            label: Text(
              'Try Again',
              style: TextStyle(
                fontSize: MyResponsive.fontSize(value: 14),
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
