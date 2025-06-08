import '../models/budaya.dart';
import 'api_service.dart';

class BudayaService {
  final ApiService _apiService = ApiService();

  Future<List<Budaya>> getAllBudaya() async {
    try {
      final response = await _apiService.get('/budaya');

      List<Budaya> budayaList = [];
      for (var item in response.data['data']) {
        budayaList.add(Budaya.fromJson(item));
      }

      return budayaList;
    } catch (e) {
      throw Exception('Gagal mengambil data budaya: ${e.toString()}');
    }
  }

  Future<Budaya> getBudayaDetail(int id) async {
    try {
      final response = await _apiService.get('/budaya/$id');
      return Budaya.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Gagal mengambil detail budaya: ${e.toString()}');
    }
  }

  Future<List<Budaya>> getCagarBudaya() async {
    try {
      final response = await _apiService.get('/cagar-budaya');

      List<Budaya> budayaList = [];
      for (var item in response.data['data']) {
        budayaList.add(Budaya.fromJson(item));
      }

      return budayaList;
    } catch (e) {
      throw Exception('Gagal mengambil data cagar budaya: ${e.toString()}');
    }
  }

  Future<List<Budaya>> getCagarAlam() async {
    try {
      final response = await _apiService.get('/cagar-alam');

      List<Budaya> budayaList = [];
      for (var item in response.data['data']) {
        budayaList.add(Budaya.fromJson(item));
      }

      return budayaList;
    } catch (e) {
      throw Exception('Gagal mengambil data cagar alam: ${e.toString()}');
    }
  }
}
