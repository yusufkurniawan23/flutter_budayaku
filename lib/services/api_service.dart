import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class ApiService {
  late Dio _dio;

  ApiService() {
    _dio = Dio();
    _dio.options.baseUrl = ApiConfig.baseUrl;
    _dio.options.headers = ApiConfig.headers;
    
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.sendTimeout = const Duration(seconds: 30);

    // Interceptor untuk menambahkan token ke setiap request
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          print('🌐 API Request: ${options.method} ${options.baseUrl}${options.path}');
          
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('✅ API Response: ${response.statusCode} - ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          print('❌ API Error: ${error.response?.statusCode} - ${error.requestOptions.path}');
          print('❌ Error message: ${error.message}');
          
          // Handle error (seperti 401 Unauthorized)
          if (error.response?.statusCode == 401) {
            // Implementasi logout
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<Response> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    if (e.response != null) {
      final errorMessage = e.response?.data['message'] ?? 'Terjadi kesalahan';
      return Exception(errorMessage);
    } else {
      return Exception('Tidak dapat terhubung ke server');
    }
  }
  
  // Method khusus untuk mendapatkan URL gambar yang valid
  String getValidImageUrl(String? url) {
    return ApiConfig.getImageUrl(url);
  }
}