import '../models/seniman.dart';
import 'api_service.dart';

class SenimanService {
  final ApiService _apiService = ApiService();

  Future<List<Seniman>> getAllSeniman() async {
    try {
      final response = await _apiService.get('/seniman');

      List<Seniman> senimanList = [];
      for (var item in response.data['data']) {
        senimanList.add(Seniman.fromJson(item));
      }

      return senimanList;
    } catch (e) {
      throw Exception('Gagal mengambil data seniman: ${e.toString()}');
    }
  }

  Future<Seniman> getSenimanDetail(int id) async {
    try {
      final response = await _apiService.get('/seniman/$id');
      return Seniman.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Gagal mengambil detail seniman: ${e.toString()}');
    }
  }
}
