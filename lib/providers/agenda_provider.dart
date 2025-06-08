import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/agenda.dart';
import '../services/agenda_service.dart';

// Provider untuk AgendaService
final agendaServiceProvider = Provider<AgendaService>((ref) {
  return AgendaService();
});

// Provider untuk daftar agenda
final agendaListProvider = FutureProvider<List<Agenda>>((ref) async {
  final agendaService = ref.watch(agendaServiceProvider);
  return agendaService.getAllAgenda();
});

// Provider untuk detail agenda (menggunakan family provider)
final agendaDetailProvider = FutureProvider.family<Agenda, int>((ref, id) {
  final agendaService = ref.watch(agendaServiceProvider);
  return agendaService.getAgendaDetail(id);
});

// Provider untuk mengelola agenda baru/update (untuk admin)
final agendaFormProvider =
    StateNotifierProvider<AgendaFormNotifier, AsyncValue<void>>((ref) {
  final agendaService = ref.watch(agendaServiceProvider);
  return AgendaFormNotifier(agendaService);
});

class AgendaFormNotifier extends StateNotifier<AsyncValue<void>> {
  final AgendaService _agendaService;

  AgendaFormNotifier(this._agendaService) : super(const AsyncValue.data(null));

  Future<void> createAgenda({
    required String judul,
    required String lokasi,
    required DateTime tanggalMulai,
    required DateTime tanggalSelesai,
    required String deskripsi,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _agendaService.createAgenda(
        judul: judul,
        lokasi: lokasi,
        tanggalMulai: tanggalMulai,
        tanggalSelesai: tanggalSelesai,
        deskripsi: deskripsi,
      );
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
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
    state = const AsyncValue.loading();
    try {
      await _agendaService.updateAgenda(
        id: id,
        judul: judul,
        lokasi: lokasi,
        tanggalMulai: tanggalMulai,
        tanggalSelesai: tanggalSelesai,
        deskripsi: deskripsi,
      );
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> deleteAgenda(int id) async {
    state = const AsyncValue.loading();
    try {
      await _agendaService.deleteAgenda(id);
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
