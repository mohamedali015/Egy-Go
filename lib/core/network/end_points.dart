abstract class EndPoints {
  static const String baseUrl = 'http://10.0.2.2:5000/api/';

  static const String getGovernorates = 'provinces';
  static const String getPlaces = 'places?page=1&limit=20';

  static String searchHome(String query) {
    return 'places/search?q=$query';
  }
}
