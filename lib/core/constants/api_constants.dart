class ApiConstants {
  ApiConstants._();

  /// https://randomuser.me/api/?results=20
  static const String baseUrl = 'https://randomuser.me/api/';
  static const int homeResults = 20;

  static String usersEndpoint({int results = homeResults}) =>
      '$baseUrl?results=$results';
}
