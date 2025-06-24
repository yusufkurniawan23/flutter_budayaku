import '../models/agenda.dart';
import 'api_service.dart';

class AgendaService {
  final ApiService _apiService = ApiService();

  Future<List<Agenda>> getAllAgenda() async {
    print('⏳ getAllAgenda: Starting API request');
    try {
      final response = await _apiService.get('/agenda');
      print('✅ getAllAgenda: API response received');
      print('📄 Response data structure: ${response.data}');

      if (response.data == null) {
        print('❌ getAllAgenda: Response data is null');
        throw Exception('Response data is null');
      }

      List<Agenda> agendaList = [];
      
      if (response.data is Map && response.data['data'] != null) {
        final dataList = response.data['data'];
        print('📋 Response has data field with ${dataList.length} items');
        
        if (dataList is List) {
          for (var item in dataList) {
            if (item != null && item is Map<String, dynamic>) {
              try {
                agendaList.add(Agenda.fromJson(item));
                print('✅ Parsed agenda: ${item['judul']}');
              } catch (e) {
                print('❌ Error parsing agenda item: $e');
                print('🔍 Item data: $item');
                continue;
              }
            }
          }
        }
      }
      else if (response.data is List) {
        final dataList = response.data as List;
        print('📋 Response is direct array with ${dataList.length} items');
        
        for (var item in dataList) {
          if (item != null && item is Map<String, dynamic>) {
            try {
              agendaList.add(Agenda.fromJson(item));
              print('✅ Parsed agenda: ${item['judul']}');
            } catch (e) {
              print('❌ Error parsing agenda item: $e');
              continue;
            }
          }
        }
      }

      print('✅ getAllAgenda: Successfully retrieved ${agendaList.length} agenda');
      return agendaList;
    } catch (e) {
      print('❌ getAllAgenda: Error - $e');
      throw Exception('Gagal mengambil data agenda: ${e.toString()}');
    }
  }

  Future<Agenda> getAgendaDetail(int id) async {
    print('⏳ getAgendaDetail: Starting API request for agenda ID $id');
    try {
      final response = await _apiService.get('/agenda/$id');
      print('✅ getAgendaDetail: API response received for ID $id');
      print('📄 Response data: ${response.data}');
      
      if (response.data == null) {
        print('❌ getAgendaDetail: Response data is null for ID $id');
        throw Exception('Data agenda tidak ditemukan');
      }

      // Cek berbagai kemungkinan struktur response untuk detail
      dynamic agendaData;
      
      // Jika response berupa object dengan field 'data'
      if (response.data is Map && response.data['data'] != null) {
        agendaData = response.data['data'];
        print('📋 Response has data field');
      }
      // Jika response langsung berupa object agenda
      else if (response.data is Map && response.data.containsKey('id')) {
        agendaData = response.data;
        print('📋 Response is direct agenda object');
      }
      else {
        print('❌ Unknown response structure for detail');
        throw Exception('Format response tidak sesuai');
      }
      
      if (agendaData == null) {
        throw Exception('Data agenda tidak ditemukan dalam response');
      }
      
      print('✅ getAgendaDetail: Successfully parsed agenda data for ID $id');
      return Agenda.fromJson(agendaData);
    } catch (e) {
      print('❌ getAgendaDetail: Error getting details for ID $id - $e');
      
      if (e.toString().contains('404') || e.toString().contains('not found')) {
        throw Exception('Data agenda tidak ditemukan');
      }
      
      throw Exception('Gagal mengambil detail agenda: ${e.toString()}');
    }
  }
}
