import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/helper/my_navigator.dart';
import 'package:egy_go/core/helper/get_it.dart';
import 'package:egy_go/core/shared_widgets/svg_wrapper.dart';
import 'package:egy_go/core/utils/app_assets.dart';
import 'package:egy_go/core/utils/app_colors.dart';
import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:egy_go/features/ai_chat/data/models/ai_message_model.dart';
import 'package:egy_go/features/ai_chat/manager/ai_chat_cubit/ai_chat_cubit.dart';
import 'package:egy_go/features/ai_chat/manager/ai_chat_cubit/ai_chat_state.dart';
import 'package:egy_go/features/places/data/repos/places_repo/places_repo.dart';
import 'package:egy_go/features/places/views/place_details_view.dart';
import 'package:egy_go/features/places/manager/places_cubit/places_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
        // Show text message only if there are no places or if it's a user message
        if (message.isUser ||
            (message.places == null || message.places!.isEmpty))
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
                gradient: message.isUser
                    ? LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primary.withValues(alpha: 0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: message.isUser ? null : AppColors.white,
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
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Use Markdown for AI responses, plain text for user messages
                  if (message.isUser)
                    Text(
                      message.message,
                      style: GoogleFonts.outfit(
                        fontSize: MyResponsive.fontSize(value: 14),
                        color: AppColors.white,
                      ),
                    )
                  else
                    MarkdownBody(
                      data: message.message,
                      styleSheet: MarkdownStyleSheet(
                        p: GoogleFonts.outfit(
                          fontSize: MyResponsive.fontSize(value: 14),
                          color: AppColors.black,
                        ),
                        strong: GoogleFonts.outfit(
                          fontSize: MyResponsive.fontSize(value: 14),
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                        h1: GoogleFonts.outfit(
                          fontSize: MyResponsive.fontSize(value: 20),
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                        h2: GoogleFonts.outfit(
                          fontSize: MyResponsive.fontSize(value: 18),
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                        h3: GoogleFonts.outfit(
                          fontSize: MyResponsive.fontSize(value: 16),
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                        listBullet: TextStyle(
                          color: AppColors.primary,
                          fontSize: MyResponsive.fontSize(value: 14),
                        ),
                        blockquote: GoogleFonts.outfit(
                          fontSize: MyResponsive.fontSize(value: 13),
                          color: AppColors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                        code: GoogleFonts.sourceCodePro(
                          fontSize: MyResponsive.fontSize(value: 12),
                          backgroundColor:
                              AppColors.grey.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                  SizedBox(height: MyResponsive.height(value: 4)),
                  Text(
                    DateFormat('HH:mm').format(message.timestamp),
                    style: GoogleFonts.outfit(
                      fontSize: MyResponsive.fontSize(value: 10),
                      color: message.isUser
                          ? AppColors.white.withValues(alpha: 0.7)
                          : AppColors.grey,
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(duration: 300.ms, curve: Curves.easeOut)
                .slideY(begin: 0.3, duration: 300.ms, curve: Curves.easeOut),
          ),

        // Show place cards if available (for AI responses with places)
        if (!message.isUser &&
            message.places != null &&
            message.places!.isNotEmpty) ...[
          // Header message for places
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              margin: EdgeInsets.only(
                bottom: MyResponsive.height(value: 8),
                left: MyResponsive.width(value: 40),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: MyResponsive.width(value: 16),
                vertical: MyResponsive.height(value: 10),
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius:
                    BorderRadius.circular(MyResponsive.radius(value: 12)),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.hotel,
                    color: AppColors.primary,
                    size: MyResponsive.fontSize(value: 18),
                  ),
                  SizedBox(width: MyResponsive.width(value: 8)),
                  Flexible(
                    child: Text(
                      'Found ${message.places!.length} ${message.places!.length == 1 ? 'place' : 'places'} for you',
                      style: GoogleFonts.outfit(
                        fontSize: MyResponsive.fontSize(value: 13),
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms),
          ),
          // Display each place as a card
          ...message.places!
              .asMap()
              .entries
              .map((entry) => _buildEnhancedPlaceCard(entry.value, entry.key))
              .toList(),
        ],
      ],
    );
  }

  Widget _buildEnhancedPlaceCard(PlaceReference place, int index) {
    final hasImages = place.images != null && place.images!.isNotEmpty;
    final imageUrl = hasImages ? place.images!.first : null;

    return Container(
      margin: EdgeInsets.only(
        bottom: MyResponsive.height(value: 16),
        left: MyResponsive.width(value: 8),
        right: MyResponsive.width(value: 8),
      ),
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(MyResponsive.radius(value: 20)),
        shadowColor: AppColors.primary.withValues(alpha: 0.2),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(MyResponsive.radius(value: 20)),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.15),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section with Category Badge Overlay
              if (hasImages)
                Stack(
                  children: [
                    // Hotel Image
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft:
                            Radius.circular(MyResponsive.radius(value: 20)),
                        topRight:
                            Radius.circular(MyResponsive.radius(value: 20)),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl!,
                        height: MyResponsive.height(value: 200),
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          height: MyResponsive.height(value: 200),
                          color: AppColors.grey.withValues(alpha: 0.2),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          height: MyResponsive.height(value: 200),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primary.withValues(alpha: 0.3),
                                AppColors.primary.withValues(alpha: 0.1),
                              ],
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _getCategoryIcon(place.category ?? place.type),
                                size: MyResponsive.fontSize(value: 48),
                                color: AppColors.primary,
                              ),
                              SizedBox(height: MyResponsive.height(value: 8)),
                              Text(
                                'No Image',
                                style: GoogleFonts.outfit(
                                  color: AppColors.grey,
                                  fontSize: MyResponsive.fontSize(value: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Gradient overlay for better text readability
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft:
                                Radius.circular(MyResponsive.radius(value: 20)),
                            topRight:
                                Radius.circular(MyResponsive.radius(value: 20)),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.4),
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.7),
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                    ),
                    // Category Badge - Top Right
                    if (place.category != null || place.type != null)
                      Positioned(
                        top: MyResponsive.height(value: 12),
                        right: MyResponsive.width(value: 12),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: MyResponsive.width(value: 12),
                            vertical: MyResponsive.height(value: 6),
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(
                                MyResponsive.radius(value: 20)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getCategoryIcon(place.category ?? place.type),
                                color: AppColors.white,
                                size: MyResponsive.fontSize(value: 14),
                              ),
                              SizedBox(width: MyResponsive.width(value: 4)),
                              Text(
                                _getCategoryName(
                                    place.category ?? place.type ?? 'Place'),
                                style: GoogleFonts.outfit(
                                  fontSize: MyResponsive.fontSize(value: 11),
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    // Rating Badge - Bottom Left on Image
                    if (place.rating != null)
                      Positioned(
                        bottom: MyResponsive.height(value: 12),
                        left: MyResponsive.width(value: 12),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: MyResponsive.width(value: 10),
                            vertical: MyResponsive.height(value: 6),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(
                                MyResponsive.radius(value: 12)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star_rounded,
                                color: Colors.amber,
                                size: MyResponsive.fontSize(value: 16),
                              ),
                              SizedBox(width: MyResponsive.width(value: 4)),
                              Text(
                                place.rating!.toStringAsFixed(1),
                                style: GoogleFonts.outfit(
                                  fontSize: MyResponsive.fontSize(value: 14),
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),

              // Content Section
              Padding(
                padding: EdgeInsets.all(MyResponsive.width(value: 16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hotel Name
                    Text(
                      place.name,
                      style: GoogleFonts.outfit(
                        fontSize: MyResponsive.fontSize(value: 20),
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: MyResponsive.height(value: 8)),

                    // Location with Icon
                    if (place.province != null)
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            color: AppColors.primary,
                            size: MyResponsive.fontSize(value: 18),
                          ),
                          SizedBox(width: MyResponsive.width(value: 6)),
                          Expanded(
                            child: Text(
                              place.province!,
                              style: GoogleFonts.outfit(
                                fontSize: MyResponsive.fontSize(value: 14),
                                color: AppColors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                    // Description
                    if (place.description != null &&
                        place.description!.isNotEmpty) ...[
                      SizedBox(height: MyResponsive.height(value: 12)),
                      Text(
                        place.description!,
                        style: GoogleFonts.outfit(
                          fontSize: MyResponsive.fontSize(value: 13),
                          color: AppColors.black.withValues(alpha: 0.7),
                          height: 1.5,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],

                    SizedBox(height: MyResponsive.height(value: 16)),

                    // Show More Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _navigateToPlaceDetails(place),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          padding: EdgeInsets.symmetric(
                            vertical: MyResponsive.height(value: 14),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                MyResponsive.radius(value: 14)),
                          ),
                          elevation: 2,
                          shadowColor: AppColors.primary.withValues(alpha: 0.4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Show More Details',
                              style: GoogleFonts.outfit(
                                fontSize: MyResponsive.fontSize(value: 15),
                                fontWeight: FontWeight.w600,
                                color: AppColors.white,
                              ),
                            ),
                            SizedBox(width: MyResponsive.width(value: 8)),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: MyResponsive.fontSize(value: 18),
                              color: AppColors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate(delay: (150 * index).ms)
        .fadeIn(duration: 500.ms, curve: Curves.easeOut)
        .slideY(begin: 0.2, duration: 500.ms, curve: Curves.easeOut)
        .scale(
            begin: const Offset(0.9, 0.9),
            duration: 500.ms,
            curve: Curves.easeOut);
  }

  Future<void> _navigateToPlaceDetails(PlaceReference place) async {
    try {
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                ),
              ),
              SizedBox(width: 16),
              Text('Loading ${place.name}...'),
            ],
          ),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      // Fetch full place details from places repo
      final placesRepo = getIt<PlacesRepo>();
      final result = await placesRepo.getPlaceById(place.id);

      result.fold(
        (error) {
          // Hide loading and show error
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.error_outline, color: AppColors.white),
                  SizedBox(width: 12),
                  Expanded(child: Text('Error: $error')),
                ],
              ),
              backgroundColor: AppColors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
        (placeDetails) {
          // Hide loading snackbar
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          // Set the selected place and navigate
          PlacesCubit.get(context).setSelectedPlace(placeDetails);
          MyNavigator.goTo(screen: PlaceDetailsView());
        },
      );
    } catch (e) {
      print('[AiChatView] Error loading place: $e');
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: AppColors.white),
              SizedBox(width: 12),
              Expanded(child: Text('Failed to load place details')),
            ],
          ),
          backgroundColor: AppColors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  Widget _buildPlaceCard(PlaceReference placeRef) {
    // Keep old implementation for backwards compatibility
    return Container(
      margin: EdgeInsets.only(
        bottom: MyResponsive.height(value: 12),
        left: MyResponsive.width(value: 16),
        right: MyResponsive.width(value: 16),
      ),
      child: InkWell(
        onTap: () async {
          try {
            // Show loading indicator
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Loading place details...'),
                duration: Duration(seconds: 1),
              ),
            );

            // Fetch full place details from places repo
            final placesRepo = getIt<PlacesRepo>();
            final result = await placesRepo.getPlaceById(placeRef.id);

            result.fold(
              (error) {
                // Show error message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: $error'),
                    backgroundColor: AppColors.red,
                  ),
                );
              },
              (place) {
                // Set the selected place and navigate
                PlacesCubit.get(context).setSelectedPlace(place);
                MyNavigator.goTo(screen: PlaceDetailsView());
              },
            );
          } catch (e) {
            print('[AiChatView] Error loading place: $e');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to load place details'),
                backgroundColor: AppColors.red,
              ),
            );
          }
        },
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
              // Background gradient
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
                        Colors.black.withValues(alpha: 0.7),
                      ],
                      stops: const [0.4, 1.0],
                    ),
                  ),
                ),
              ),
              // Category icon - smaller and less intrusive
              Positioned(
                top: MyResponsive.height(value: 12),
                right: MyResponsive.width(value: 12),
                child: Container(
                  padding: EdgeInsets.all(MyResponsive.width(value: 8)),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.2),
                    borderRadius:
                        BorderRadius.circular(MyResponsive.radius(value: 8)),
                  ),
                  child: Icon(
                    _getCategoryIcon(placeRef.category),
                    color: AppColors.white,
                    size: MyResponsive.fontSize(value: 22),
                  ),
                ),
              ),
              // Place info - centered vertically with better spacing
              Positioned(
                left: MyResponsive.width(value: 16),
                right: MyResponsive.width(value: 16),
                top: MyResponsive.height(value: 16),
                bottom: MyResponsive.height(value: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
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
                    SizedBox(height: MyResponsive.height(value: 10)),
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
                      SizedBox(height: MyResponsive.height(value: 8)),
                      Expanded(
                        child: Text(
                          placeRef.description!,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.regular12.copyWith(
                            color: Colors.white.withValues(alpha: .9),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                    SizedBox(height: MyResponsive.height(value: 10)),
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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAnimatedDot(0),
            SizedBox(width: MyResponsive.width(value: 4)),
            _buildAnimatedDot(1),
            SizedBox(width: MyResponsive.width(value: 4)),
            _buildAnimatedDot(2),
          ],
        ),
      )
          .animate(onPlay: (controller) => controller.repeat())
          .fadeIn(duration: 300.ms),
    );
  }

  Widget _buildAnimatedDot(int index) {
    return Container(
      width: MyResponsive.width(value: 8),
      height: MyResponsive.height(value: 8),
      decoration: BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
    )
        .animate(onPlay: (controller) => controller.repeat())
        .fadeIn(
          delay: (200 * index).ms,
          duration: 600.ms,
        )
        .then()
        .fadeOut(duration: 600.ms);
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
