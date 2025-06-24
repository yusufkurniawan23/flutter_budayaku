import 'category.dart';
import '../config/api_config.dart';

class Budaya {
  final int id;
  final int categoryId;
  final String tanggal;
  final String? fotoUrl;
  final String deskripsi;
  final String namaObjek;
  final Category? category;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Budaya({
    required this.id,
    required this.categoryId,
    required this.tanggal,
    this.fotoUrl,
    required this.deskripsi,
    required this.namaObjek,
    this.category,
    this.createdAt,
    this.updatedAt,
  });

  factory Budaya.fromJson(Map<String, dynamic> json) {
    print('🔄 Parsing budaya from JSON: ${json['nama_objek']}');
    print('🖼️ Original foto_url: ${json['foto_url']}');

    try {
      final budaya = Budaya(
        id: _parseInt(json['id']),
        categoryId: _parseInt(json['category_id']),
        tanggal: _parseString(json['tanggal']),
        fotoUrl: json['foto_url'], // Simpan URL asli dari API
        deskripsi: _parseString(json['deskripsi']),
        namaObjek: _parseString(json['nama_objek']),
        category: json['category'] != null
            ? Category.fromJson(json['category'])
            : null,
        createdAt: _parseDateTime(json['created_at']),
        updatedAt: _parseDateTime(json['updated_at']),
      );
      
      // Debug URL gambar
      if (budaya.fotoUrl != null) {
        final fullUrl = budaya.getFullImageUrl();
        print('🔗 Full image URL: $fullUrl');
      }
      
      return budaya;
    } catch (e) {
      print('❌ Error parsing budaya: $e');
      rethrow;
    }
  }

  // Helper methods untuk parsing yang aman
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static String _parseString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String && value.isNotEmpty) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        print('❌ Error parsing date: $value - $e');
        return null;
      }
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'tanggal': tanggal,
      'foto_url': fotoUrl,
      'deskripsi': deskripsi,
      'nama_objek': namaObjek,
      'category': category?.toJson(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Budaya{id: $id, namaObjek: $namaObjek, category: ${category?.name}}';
  }

  // Helper method untuk mendapatkan URL gambar yang lengkap
  String? getFullImageUrl() {
    if (fotoUrl == null || fotoUrl!.isEmpty) {
      return null;
    }
    
    return ApiConfig.getImageUrl(fotoUrl);
  }

  // Helper untuk cek apakah punya foto yang valid
  bool get hasPhoto {
    final fullUrl = getFullImageUrl();
    return fullUrl != null && fullUrl.isNotEmpty;
  }

  // Getter untuk kompatibilitas
  String? get validFotoUrl => getFullImageUrl();
  bool get hasValidPhoto => hasPhoto;

  // Helper method untuk mendapatkan kategori display
  String getCategoryDisplayName() {
    return category?.name ?? 'Tidak Berkategori';
  }

  // Helper method untuk format tanggal yang lebih baik
  String getFormattedDate() {
    try {
      final date = DateTime.parse(tanggal);
      final months = [
        '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
        'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
      ];
      return '${date.day} ${months[date.month]} ${date.year}';
    } catch (e) {
      return tanggal; // Fallback ke format asli jika parsing gagal
    }
  }

  // Helper untuk mendapatkan foto URL (untuk kompatibilitas)
  String get foto {
    return getFullImageUrl() ?? '';
  }

  // Helper untuk mendapatkan image URL (untuk kompatibilitas)
  String get imageUrl {
    return getFullImageUrl() ?? '';
  }

  // Helper untuk mendapatkan deskripsi tanpa HTML tags
  String get deskripsiClean {
    return deskripsi
        .replaceAll(RegExp(r'<[^>]*>'), '') // Remove HTML tags
        .replaceAll('&nbsp;', ' ')
        .trim();
  }

  // Helper untuk mendapatkan icon berdasarkan kategori
  String getCategoryIcon() {
    if (category == null) return '🏛️';
    
    switch (category!.name.toLowerCase()) {
      case 'cagar budaya':
        return '🏛️';
      case 'cagar alam':
        return '🌿';
      case 'seni tradisional':
        return '🎭';
      case 'arsitektur tradisional':
        return '🏘️';
      case 'kuliner tradisional':
        return '🍜';
      case 'pakaian adat':
        return '👘';
      case 'ritual adat':
        return '🕯️';
      case 'kerajinan tangan':
        return '🧶';
      default:
        return '🏛️';
    }
  }
}