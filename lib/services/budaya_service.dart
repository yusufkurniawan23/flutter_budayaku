import '../models/budaya.dart';
import 'api_service.dart';

class BudayaService {
  final ApiService _apiService = ApiService();

  Future<List<Budaya>> getAllBudaya() async {
    print('⏳ getAllBudaya: Starting API request');
    try {
      final response = await _apiService.get('/budaya');
      print('✅ getAllBudaya: API response received');
      print('📄 Response data keys: ${response.data?.keys}');

      if (response.data == null) {
        print('❌ getAllBudaya: Response data is null');
        throw Exception('Data tidak ditemukan');
      }

      // Check untuk struktur response
      if (response.data['success'] != true) {
        throw Exception('Response tidak berhasil');
      }

      final List<dynamic> dataList = response.data['data'] as List<dynamic>;
      print('📊 getAllBudaya: Found ${dataList.length} items');

      List<Budaya> budayaList = [];
      for (var item in dataList) {
        try {
          final budaya = Budaya.fromJson(item as Map<String, dynamic>);
          budayaList.add(budaya);
          print('✅ Parsed budaya: ${budaya.namaObjek} - ${budaya.hasPhoto ? 'Dengan foto: ${budaya.fotoUrl}' : 'Tanpa foto'}');
        } catch (e) {
          print('❌ Error parsing item: $item - Error: $e');
          // Skip item yang error, tidak throw exception
          continue;
        }
      }

      print('✅ getAllBudaya: Successfully parsed ${budayaList.length} budaya items');
      return budayaList;
    } catch (e) {
      print('❌ getAllBudaya error: $e');
      throw Exception('Gagal mengambil data budaya: ${e.toString()}');
    }
  }

  Future<Budaya> getBudayaDetail(int id) async {
    print('⏳ getBudayaDetail: Starting API request for ID $id');
    try {
      final response = await _apiService.get('/budaya/$id');
      print('✅ getBudayaDetail: API response received for ID $id');

      if (response.data == null) {
        throw Exception('Detail budaya tidak ditemukan');
      }

      // Check struktur response
      if (response.data['success'] != true) {
        throw Exception('Response tidak berhasil');
      }

      final Map<String, dynamic> budayaData = response.data['data'];
      final budaya = Budaya.fromJson(budayaData);
      print('✅ getBudayaDetail: Successfully parsed ${budaya.namaObjek}');
      return budaya;
    } catch (e) {
      print('❌ getBudayaDetail error for ID $id: $e');
      throw Exception('Gagal mengambil detail budaya: ${e.toString()}');
    }
  }

  // Helper method untuk mendapatkan budaya berdasarkan kategori
  Future<List<Budaya>> getBudayaByCategory(String categoryName) async {
    try {
      final allBudaya = await getAllBudaya();
      return allBudaya.where((budaya) => 
        budaya.category?.name.toLowerCase() == categoryName.toLowerCase()
      ).toList();
    } catch (e) {
      throw Exception('Gagal mengambil data budaya berdasarkan kategori: ${e.toString()}');
    }
  }

  // Method untuk pencarian budaya
  Future<List<Budaya>> searchBudaya(String query) async {
    try {
      final allBudaya = await getAllBudaya();
      final lowerQuery = query.toLowerCase();
      
      return allBudaya.where((budaya) => 
        budaya.namaObjek.toLowerCase().contains(lowerQuery) ||
        budaya.deskripsiClean.toLowerCase().contains(lowerQuery) ||
        budaya.getCategoryDisplayName().toLowerCase().contains(lowerQuery)
      ).toList();
    } catch (e) {
      throw Exception('Gagal mencari data budaya: ${e.toString()}');
    }
  }

  // Method khusus untuk Cagar Budaya
  Future<List<Budaya>> getCagarBudaya() async {
    return getBudayaByCategory('Cagar Budaya');
  }

  // Method khusus untuk Cagar Alam
  Future<List<Budaya>> getCagarAlam() async {
    return getBudayaByCategory('Cagar Alam');
  }
}