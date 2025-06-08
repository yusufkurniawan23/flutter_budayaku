import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import 'api_service.dart';
import 'dart:developer' as developer; // Import untuk logging yang lebih baik

class AuthService {
  final ApiService _apiService = ApiService();
  final String tag = 'AuthService';

  // Helper method untuk logging
  void _log(String message, {bool isError = false}) {
    if (isError) {
      developer.log('[$tag] ERROR: $message', name: tag);
    } else {
      developer.log('[$tag] $message', name: tag);
    }
  }

  Future<User> login(String email, String password) async {
    _log('Attempting login for user: $email');
    try {
      _log('Sending login request to API');
      final response = await _apiService.post('/login', data: {
        'email': email,
        'password': password,
      });

      _log('Login API response received');
      final user = User.fromJson(response.data['user']);
      _log('User object created: ${user.name}');

      // Simpan token ke SharedPreferences
      _log('Storing authentication token');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', response.data['token']);
      _log('Login successful for user: ${user.email}');

      return user;
    } catch (e) {
      _log('Login failed: ${e.toString()}', isError: true);
      throw Exception('Login gagal: ${e.toString()}');
    }
  }

  Future<User> register(String name, String email, String password,
      String alamat, String nomor) async {
    _log('Attempting registration for user: $email');
    try {
      _log('Sending registration request to API');
      final response = await _apiService.post('/register', data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
        'alamat': alamat,
        'nomor': nomor,
      });

      _log('Registration API response received');
      final user = User.fromJson(response.data['user']);
      _log('User object created: ${user.name}');

      // Simpan token ke SharedPreferences
      _log('Storing authentication token');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', response.data['token']);
      _log('Registration successful for user: ${user.email}');

      return user;
    } catch (e) {
      _log('Registration failed: ${e.toString()}', isError: true);
      throw Exception('Registrasi gagal: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    _log('Attempting logout');
    try {
      _log('Sending logout request to API');
      await _apiService.post('/logout');

      // Hapus token dari SharedPreferences
      _log('Removing authentication token');
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      _log('Logout successful');
    } catch (e) {
      _log('Logout failed: ${e.toString()}', isError: true);
      throw Exception('Logout gagal: ${e.toString()}');
    }
  }

  Future<User> getCurrentUser() async {
    _log('Fetching current user data');
    try {
      _log('Sending user data request to API');
      final response = await _apiService.get('/user');
      _log('User data received from API');
      
      final user = User.fromJson(response.data);
      _log('Current user retrieved: ${user.name}');
      return user;
    } catch (e) {
      _log('Failed to get current user: ${e.toString()}', isError: true);
      throw Exception('Gagal mendapatkan data user: ${e.toString()}');
    }
  }

  Future<bool> isLoggedIn() async {
    _log('Checking login status');
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final loggedIn = token != null;
      _log('Login status: ${loggedIn ? 'Logged in' : 'Not logged in'}');
      return loggedIn;
    } catch (e) {
      _log('Error checking login status: ${e.toString()}', isError: true);
      return false;
    }
  }
}
