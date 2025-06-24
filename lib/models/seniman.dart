import '../config/api_config.dart';

class Seniman {
  final int id;
  final int? userId;
  final String nama;
  final String alamat;
  final String judul;
  final String foto;
  final String nomor;
  final String deskripsi;
  final String? fotoUrl; // Tambahkan field foto_url dari API
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Seniman({
    required this.id,
    this.userId,
    required this.nama,
    required this.alamat,
    required this.judul,
    required this.foto,
    required this.nomor,
    required this.deskripsi,
    this.fotoUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory Seniman.fromJson(Map<String, dynamic> json) {
    print('🔄 Parsing seniman from JSON: ${json['nama']}');
    print('🖼️ Original foto_url: ${json['foto_url']}');
    
    try {
      final seniman = Seniman(
        id: _parseInt(json['id']),
        userId: json['user_id'],
        nama: _parseString(json['nama']),
        alamat: _parseString(json['alamat']),
        judul: _parseString(json['judul']),
        foto: json['foto'] ?? '', // Field foto lama (untuk kompatibilitas)
        nomor: _parseString(json['nomor']),
        deskripsi: _parseString(json['deskripsi']),
        fotoUrl: json['foto_url'], // Field foto_url baru dari API
        createdAt: _parseDateTime(json['created_at']),
        updatedAt: _parseDateTime(json['updated_at']),
      );
      
      // Debug URL gambar
      if (seniman.fotoUrl != null) {
        final fullUrl = seniman.getFullImageUrl();
        print('🔗 Full image URL: $fullUrl');
      }
      
      return seniman;
    } catch (e) {
      print('❌ Error parsing seniman: $e');
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
      'user_id': userId,
      'nama': nama,
      'alamat': alamat,
      'judul': judul,
      'foto': foto,
      'nomor': nomor,
      'deskripsi': deskripsi,
      'foto_url': fotoUrl,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
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

  // Getter untuk kompatibilitas dengan kode lama
  String get photoUrl {
    return getFullImageUrl() ?? '';
  }

  // Helper untuk mendapatkan deskripsi tanpa HTML tags
  String get deskripsiClean {
    return deskripsi
        .replaceAll(RegExp(r'<[^>]*>'), '') // Remove HTML tags
        .replaceAll('&nbsp;', ' ')
        .trim();
  }

  // Helper untuk mendapatkan initial nama
  String get nameInitials {
    final words = nama.split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    } else if (words.isNotEmpty) {
      return words[0].substring(0, 1).toUpperCase();
    }
    return 'S';
  }

  @override
  String toString() {
    return 'Seniman{id: $id, nama: $nama, judul: $judul, hasPhoto: $hasPhoto}';
  }
}