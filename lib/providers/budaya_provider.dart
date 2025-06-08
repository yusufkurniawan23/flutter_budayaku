import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/budaya.dart';
import '../services/budaya_service.dart';

final budayaServiceProvider = Provider<BudayaService>((ref) {
  return BudayaService();
});

final budayaListProvider = FutureProvider<List<Budaya>>((ref) {
  final budayaService = ref.watch(budayaServiceProvider);
  return budayaService.getAllBudaya();
});

final budayaDetailProvider = FutureProvider.family<Budaya, int>((ref, id) {
  final budayaService = ref.watch(budayaServiceProvider);
  return budayaService.getBudayaDetail(id);
});

final cagarBudayaProvider = FutureProvider<List<Budaya>>((ref) {
  final budayaService = ref.watch(budayaServiceProvider);
  return budayaService.getCagarBudaya();
});

final cagarAlamProvider = FutureProvider<List<Budaya>>((ref) {
  final budayaService = ref.watch(budayaServiceProvider);
  return budayaService.getCagarAlam();
});
