class ApiConstants {
  static const String baseUrl = 'https://polyjuice.kong.fampay.co';
  static const String cardsEndpoint = '/mock/famapp/feed/home_section/';
  static const String cardsQueryParam = 'slugs=famx-paypage';
  
  static String get cardsUrl => '$baseUrl$cardsEndpoint?$cardsQueryParam';
}