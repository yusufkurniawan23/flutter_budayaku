import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiConfig {
  // Gunakan IP yang sesuai dengan platform
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://192.168.1.79:8000/api';
    } else if (Platform.isAndroid) {
      return 'http://192.168.1.79:8000/api';
    } else {
      return 'http://192.168.1.79:8000/api';
    }
  }
  
  static String get storageUrl {
    if (kIsWeb) {
      return 'http://192.168.1.79:8000';
    } else if (Platform.isAndroid) {
      return 'http://192.168.1.79:8000';
    } else {
      return 'http://192.168.1.79:8000';
    }
  }
  
  // Method untuk mendapatkan IP device
  static String getDeviceIP() {
    return '192.168.1.79';
  }
  
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Helper untuk mendapatkan URL gambar yang lengkap
  static String getImageUrl(String? relativePath) {
    if (relativePath == null || relativePath.isEmpty) {
      print('⚠️ getImageUrl: relativePath is null or empty');
      return '';
    }
    
    print('🔧 getImageUrl input: $relativePath');
    
    String finalUrl = '';
    
    // Jika sudah URL lengkap dengan protocol
    if (relativePath.startsWith('http://') || relativePath.startsWith('https://')) {
      print('✅ getImageUrl: Already full URL');
      
      // Replace 127.0.0.1 dengan IP yang tepat jika ada
      if (relativePath.contains('127.0.0.1')) {
        finalUrl = relativePath.replaceAll('127.0.0.1', getDeviceIP());
        print('🔄 getImageUrl result (replaced 127.0.0.1): $finalUrl');
      } else {
        finalUrl = relativePath;
        print('✅ getImageUrl result (no change): $finalUrl');
      }
    }
    // Jika berupa IP:port/storage (tanpa protocol) - kasus yang sering terjadi
    else if (relativePath.contains('${getDeviceIP()}:8000/storage/')) {
      finalUrl = 'http://$relativePath';
      print('🔄 getImageUrl result (added http to IP:port): $finalUrl');
    }
    // Jika berupa 127.0.0.1:port/storage (tanpa protocol)
    else if (relativePath.contains('127.0.0.1:8000/storage/')) {
      final corrected = relativePath.replaceAll('127.0.0.1', getDeviceIP());
      finalUrl = 'http://$corrected';
      print('🔄 getImageUrl result (corrected 127.0.0.1): $finalUrl');
    }
    // Jika path dimulai dengan /storage
    else if (relativePath.startsWith('/storage')) {
      finalUrl = '$storageUrl$relativePath';
      print('🔄 getImageUrl result (added storageUrl): $finalUrl');
    }
    // Jika path dimulai dengan storage (tanpa /)
    else if (relativePath.startsWith('storage')) {
      finalUrl = '$storageUrl/$relativePath';
      print('🔄 getImageUrl result (added storageUrl with slash): $finalUrl');
    }
    // Default: gabungkan dengan storage URL
    else {
      finalUrl = '$storageUrl/storage/$relativePath';
      print('🔄 getImageUrl result (default): $finalUrl');
    }
    
    // Tambahkan cache buster untuk web development
    if (kIsWeb && kDebugMode) {
      final separator = finalUrl.contains('?') ? '&' : '?';
      finalUrl = '$finalUrl${separator}v=${DateTime.now().millisecondsSinceEpoch}';
      print('🌐 Added cache buster for web: $finalUrl');
    }
    
    return finalUrl;
  }
}