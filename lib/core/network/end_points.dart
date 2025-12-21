abstract class EndPoints {
  static const String baseUrl = 'https://1p1jgw5z-5000.euw.devtunnels.ms/api/';

  static const String register = 'auth/register';
  static const String login = 'auth/login';
  static const String verifyOtp = 'auth/verify-otp';
  static const String resendOtp = 'auth/resend-otp';
  static const String changePassword = 'auth/change-password';
  static const String getUserData = 'auth/me';
  static const String refreshToken = 'auth/refresh';
  static const String getGovernorates = 'provinces';
  static const String getPlaces = 'places?page=1&limit=20';
  static const String createTrip = 'tourist/trips';
  static const String getMyTrips = 'tourist/trips';

  static String searchHome(String query) {
    return 'places/search?q=$query';
  }

  static String getPlacesByCategory(String category, String governorate) {
    return 'provinces/$governorate/places?type=$category';
  }

  static String getTripGuides(String tripId) {
    return 'tourist/trips/$tripId/guides';
  }

  static String selectGuide(String tripId) {
    return 'tourist/trips/$tripId/select-guide';
  }

  static String getTripDetails(String tripId) {
    return 'tourist/trips/$tripId';
  }

  static String cancelTrip(String tripId) {
    return 'tourist/trips/$tripId/cancel';
  }

  static String initiateCallTrip(String tripId) {
    return 'trips/$tripId/calls/initiate';
  }

  static String endCallTrip(String callId) {
    return 'calls/$callId/end';
  }
}
