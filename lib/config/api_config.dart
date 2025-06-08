class ApiConfig {
  // Ganti URL dengan URL backend Laravel Anda
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
