import '../models/agenda.dart';
import 'api_service.dart';

class AgendaService {
  final ApiService _apiService = ApiService();

  Future<List<Agenda>> getAllAgenda() async {
    try {
      final response = await _apiService.get('/agenda');

      List<Agenda> agendaList = [];
      for (var item in response.data['data']) {
        agendaList.add(Agenda.fromJson(item));
      }

      return agendaList;
    } catch (e) {
      throw Exception('Gagal mengambil data agenda: ${e.toString()}');
    }
  }

  Future<Agenda> getAgendaDetail(int id) async {
    try {
      final response = await _apiService.get('/agenda/$id');
      return Agenda.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Gagal mengambil detail agenda: ${e.toString()}');
    }
  }

  // Metode untuk admin
  Future<void> createAgenda({
    required String judul,
    required String lokasi,
    required DateTime tanggalMulai,
    required DateTime tanggalSelesai,
    required String deskripsi,
  }) async {
    try {
      await _apiService.post('/admin/agenda', data: {
        'judul': judul,
        'lokasi': lokasi,
        'tanggal_mulai': tanggalMulai.toIso8601String(),
        'tanggal_selesai': tanggalSelesai.toIso8601String(),
        'deskripsi': deskripsi,
      });
    } catch (e) {
      throw Exception('Gagal membuat agenda: ${e.toString()}');
    }
  }

  Future<void> updateAgenda({
    required int id,
    required String judul,
    required String lokasi,
    required DateTime tanggalMulai,
    required DateTime tanggalSelesai,
    required String deskripsi,
  }) async {
    try {
      await _apiService.put('/admin/agenda/$id', data: {
        'judul': judul,
        'lokasi': lokasi,
        'tanggal_mulai': tanggalMulai.toIso8601String(),
        'tanggal_selesai': tanggalSelesai.toIso8601String(),
        'deskripsi': deskripsi,
      });
    } catch (e) {
      throw Exception('Gagal mengupdate agenda: ${e.toString()}');
    }
  }

  Future<void> deleteAgenda(int id) async {
    try {
      await _apiService.delete('/admin/agenda/$id');
    } catch (e) {
      throw Exception('Gagal menghapus agenda: ${e.toString()}');
    }
  }
}
