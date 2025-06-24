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

// Provider untuk detail agenda 
final agendaDetailProvider = FutureProvider.family<Agenda, int>((ref, id) {
  final agendaService = ref.watch(agendaServiceProvider);
  return agendaService.getAgendaDetail(id);
});