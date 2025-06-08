import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/budaya_provider.dart';
import '../providers/seniman_provider.dart';
import '../services/agenda_service.dart';

/// Provider untuk AgendaService
final agendaServiceProvider = Provider<AgendaService>((ref) {
  return AgendaService();
});

/// Provider untuk budaya yang ditampilkan di halaman utama
final featuredBudayaProvider = FutureProvider((ref) async {
  final budayaService = ref.watch(budayaServiceProvider);
  final budayaList = await budayaService.getAllBudaya();

  // Ambil hanya beberapa item untuk featured section
  return budayaList.take(5).toList();
});

/// Provider untuk seniman yang ditampilkan di halaman utama
final featuredSenimanProvider = FutureProvider((ref) async {
  final senimanService = ref.watch(senimanServiceProvider);
  final senimanList = await senimanService.getAllSeniman();

  // Ambil hanya beberapa item untuk featured section
  return senimanList.take(5).toList();
});

/// Provider untuk agenda mendatang yang ditampilkan di halaman utama
final upcomingAgendaProvider = FutureProvider((ref) async {
  final agendaService = ref.watch(agendaServiceProvider);
  final agendaList = await agendaService.getAllAgenda();

  // Urutkan berdasarkan tanggal dan ambil event mendatang
  final now = DateTime.now();
  return agendaList.where((agenda) => agenda.tanggalMulai.isAfter(now)).toList()
    ..sort((a, b) => a.tanggalMulai.compareTo(b.tanggalMulai));
});
