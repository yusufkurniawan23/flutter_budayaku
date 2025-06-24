import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/seniman_service.dart';
import '../models/seniman.dart';

/// Provider untuk SenimanService
final senimanServiceProvider = Provider<SenimanService>((ref) {
  return SenimanService();
});

/// Provider untuk mendapatkan daftar semua seniman
final senimanListProvider = FutureProvider<List<Seniman>>((ref) async {
  final senimanService = ref.watch(senimanServiceProvider);
  return senimanService.getAllSeniman();
});

/// Provider untuk mendapatkan detail seniman berdasarkan ID
final senimanDetailProvider =
    FutureProvider.family<Seniman, int>((ref, id) async {
  final senimanService = ref.watch(senimanServiceProvider);
  return senimanService.getSenimanDetail(id);
});

/// Provider untuk mendapatkan daftar seniman berdasarkan bidang seni
final senimanByBidangProvider =
    FutureProvider.family<List<Seniman>, String>((ref, bidang) async {
  final senimanService = ref.watch(senimanServiceProvider);
  final allSeniman = await senimanService.getAllSeniman();

  // Filter seniman berdasarkan bidang seni 
  if (bidang.toLowerCase() == 'semua') {
    return allSeniman;
  }

  return allSeniman
      .where((seniman) => 
          seniman.judul.toLowerCase().contains(bidang.toLowerCase()) ||
          seniman.deskripsi.toLowerCase().contains(bidang.toLowerCase()))
      .toList();
});

/// Provider untuk pencarian seniman berdasarkan kata kunci
final searchSenimanProvider =
    FutureProvider.family<List<Seniman>, String>((ref, query) async {
  if (query.isEmpty) {
    return [];
  }

  final senimanService = ref.watch(senimanServiceProvider);
  final allSeniman = await senimanService.getAllSeniman();

  final lowercaseQuery = query.toLowerCase();
  return allSeniman
      .where((seniman) => 
          seniman.nama.toLowerCase().contains(lowercaseQuery) ||
          seniman.judul.toLowerCase().contains(lowercaseQuery) ||
          seniman.deskripsi.toLowerCase().contains(lowercaseQuery))
      .toList();
});
