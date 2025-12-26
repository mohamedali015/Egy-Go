import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/services.dart';

/// Deep Link Service
/// Handles incoming deep links from external sources (Stripe payment, etc.)
class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();

  factory DeepLinkService() => _instance;

  DeepLinkService._internal();

  final _appLinks = AppLinks();
  StreamSubscription? _linkSubscription;
  final _linkStreamController = StreamController<Uri>.broadcast();

  /// Stream of incoming deep links
  Stream<Uri> get linkStream => _linkStreamController.stream;

  /// Initialize deep link listener
  Future<void> initialize() async {
    try {
      // Check if app was opened via a link
      final initialLink = await _appLinks.getInitialLink();
      if (initialLink != null) {
        print(
            '[DeepLinkService] 🔗 App opened with initial link: $initialLink');
        _linkStreamController.add(initialLink);
      }

      // Listen for links while app is running
      _linkSubscription = _appLinks.uriLinkStream.listen(
        (Uri uri) {
          print('[DeepLinkService] 🔗 Received deep link: $uri');
          _linkStreamController.add(uri);
        },
        onError: (err) {
          print('[DeepLinkService] ❌ Deep link error: $err');
        },
      );

      print('[DeepLinkService] ✅ Deep link service initialized');
    } on PlatformException catch (e) {
      print('[DeepLinkService] ❌ Platform exception: $e');
    } catch (e) {
      print('[DeepLinkService] ❌ Error initializing deep links: $e');
    }
  }

  /// Dispose the service
  void dispose() {
    _linkSubscription?.cancel();
    _linkStreamController.close();
  }

  /// Parse payment callback from URI
  /// Supports both app scheme and https scheme
  /// Examples:
  /// - egygo://payment/success?session_id=xxx&trip_id=yyy
  /// - https://egygo.app/payment/success?session_id=xxx&trip_id=yyy
  PaymentCallback? parsePaymentCallback(Uri uri) {
    print('[DeepLinkService] 📝 Parsing URI: $uri');
    print('[DeepLinkService] 📝 Scheme: ${uri.scheme}');
    print('[DeepLinkService] 📝 Host: ${uri.host}');
    print('[DeepLinkService] 📝 Path: ${uri.path}');
    print('[DeepLinkService] 📝 Query params: ${uri.queryParameters}');

    // Check if this is a payment callback
    final isPaymentCallback =
        uri.path.contains('/payment/') || uri.path.contains('payment');

    if (!isPaymentCallback) {
      print('[DeepLinkService] ⚠️ Not a payment callback');
      return null;
    }

    // Determine success or cancel
    final isSuccess = uri.path.contains('success');
    final isCancel = uri.path.contains('cancel');

    // Extract parameters
    final sessionId =
        uri.queryParameters['session_id'] ?? uri.queryParameters['sessionId'];
    final tripId =
        uri.queryParameters['trip_id'] ?? uri.queryParameters['tripId'];

    print('[DeepLinkService] ✅ Payment callback parsed:');
    print('[DeepLinkService]    - Success: $isSuccess');
    print('[DeepLinkService]    - Cancel: $isCancel');
    print('[DeepLinkService]    - Session ID: $sessionId');
    print('[DeepLinkService]    - Trip ID: $tripId');

    return PaymentCallback(
      isSuccess: isSuccess,
      isCancel: isCancel,
      sessionId: sessionId,
      tripId: tripId,
    );
  }
}

/// Payment callback data
class PaymentCallback {
  final bool isSuccess;
  final bool isCancel;
  final String? sessionId;
  final String? tripId;

  PaymentCallback({
    required this.isSuccess,
    required this.isCancel,
    this.sessionId,
    this.tripId,
  });

  bool get hasSessionId => sessionId != null && sessionId!.isNotEmpty;

  bool get hasTripId => tripId != null && tripId!.isNotEmpty;
}
