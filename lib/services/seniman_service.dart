import '../models/seniman.dart';
import 'api_service.dart';

class SenimanService {
  final ApiService _apiService = ApiService();

  Future<List<Seniman>> getAllSeniman() async {
    print('⏳ getAllSeniman: Starting API request');
    try {
      final response = await _apiService.get('/seniman');
      print('✅ getAllSeniman: API response received');
      print('📄 Response data structure: ${response.data}');

      // Periksa apakah response tidak null
      if (response.data == null) {
        print('❌ getAllSeniman: Response data is null');
        throw Exception('Response data is null');
      }

      List<Seniman> senimanList = [];
      
      // Cek berbagai kemungkinan struktur response
      dynamic dataList;
      
      // Jika response langsung berupa array
      if (response.data is List) {
        dataList = response.data;
        print('📋 Response is direct array with ${dataList.length} items');
      }
      // Jika response berupa object dengan field 'data'
      else if (response.data is Map && response.data['data'] != null) {
        dataList = response.data['data'];
        print('📋 Response has data field with ${dataList is List ? dataList.length : 0} items');
      }
      // Jika response berupa object dengan field 'seniman'
      else if (response.data is Map && response.data['seniman'] != null) {
        dataList = response.data['seniman'];
        print('📋 Response has seniman field with ${dataList is List ? dataList.length : 0} items');
      }
      else {
        print('❌ Unknown response structure');
        return [];
      }

      // Pastikan dataList adalah List
      if (dataList is List) {
        for (var item in dataList) {
          if (item != null && item is Map<String, dynamic>) {
            try {
              senimanList.add(Seniman.fromJson(item));
              print('✅ Parsed seniman: ${item['nama']}');
            } catch (e) {
              print('❌ Error parsing seniman item: $e');
              print('🔍 Item data: $item');
              continue;
            }
          }
        }
      }

      print('✅ getAllSeniman: Successfully retrieved ${senimanList.length} seniman');
      return senimanList;
    } catch (e) {
      print('❌ getAllSeniman: Error - $e');
      throw Exception('Gagal mengambil data seniman: ${e.toString()}');
    }
  }

  Future<Seniman> getSenimanDetail(int id) async {
    print('⏳ getSenimanDetail: Starting API request for seniman ID $id');
    try {
      final response = await _apiService.get('/seniman/$id');
      print('✅ getSenimanDetail: API response received for ID $id');
      print('📄 Response data: ${response.data}');
      
      if (response.data == null) {
        print('❌ getSenimanDetail: Response data is null for ID $id');
        throw Exception('Data seniman tidak ditemukan');
      }

      // Cek berbagai kemungkinan struktur response untuk detail
      dynamic senimanData;
      
      // Jika response langsung berupa object seniman
      if (response.data is Map && response.data.containsKey('id')) {
        senimanData = response.data;
        print('📋 Response is direct seniman object');
      }
      // Jika response berupa object dengan field 'data'
      else if (response.data is Map && response.data['data'] != null) {
        senimanData = response.data['data'];
        print('📋 Response has data field');
      }
      // Jika response berupa object dengan field 'seniman'
      else if (response.data is Map && response.data['seniman'] != null) {
        senimanData = response.data['seniman'];
        print('📋 Response has seniman field');
      }
      else {
        print('❌ Unknown response structure for detail');
        throw Exception('Format response tidak sesuai');
      }
      
      if (senimanData == null) {
        throw Exception('Data seniman tidak ditemukan dalam response');
      }
      
      print('✅ getSenimanDetail: Successfully parsed seniman data for ID $id');
      return Seniman.fromJson(senimanData);
    } catch (e) {
      print('❌ getSenimanDetail: Error getting details for ID $id - $e');
      
      if (e.toString().contains('404') || e.toString().contains('not found')) {
        throw Exception('Data seniman tidak ditemukan');
      }
      
      throw Exception('Gagal mengambil detail seniman: ${e.toString()}');
    }
  }
}