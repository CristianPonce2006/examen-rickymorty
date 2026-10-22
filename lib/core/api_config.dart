class ApiConfig {
  static const String baseUrl = 'https://rickandmortyapi.com/api';
  static String charactersByIds(List<String> ids) => '$baseUrl/character/${ids.join(',')}';
}