class Agenda {
  final int id;
  final String judul;
  final String lokasi;
  final DateTime tanggalMulai;
  final DateTime tanggalSelesai;
  final String deskripsi;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Agenda({
    required this.id,
    required this.judul,
    required this.lokasi,
    required this.tanggalMulai,
    required this.tanggalSelesai,
    required this.deskripsi,
    this.createdAt,
    this.updatedAt,
  });

  factory Agenda.fromJson(Map<String, dynamic> json) {
    print('🔄 Parsing agenda from JSON: $json');

    try {
      return Agenda(
        id: _parseInt(json['id']),
        judul: _parseString(json['judul']),
        lokasi: _parseString(json['lokasi']),
        tanggalMulai: _parseDateTime(json['tanggal_mulai']) ?? DateTime.now(),
        tanggalSelesai: _parseDateTime(json['tanggal_selesai']) ?? DateTime.now(),
        deskripsi: _parseString(json['deskripsi']),
        createdAt: _parseDateTime(json['created_at']),
        updatedAt: _parseDateTime(json['updated_at']),
      );
    } catch (e) {
      print('❌ Error parsing agenda: $e');
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
      'judul': judul,
      'lokasi': lokasi,
      'tanggal_mulai': tanggalMulai.toIso8601String(),
      'tanggal_selesai': tanggalSelesai.toIso8601String(),
      'deskripsi': deskripsi,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Agenda{id: $id, judul: $judul, lokasi: $lokasi, tanggalMulai: $tanggalMulai, tanggalSelesai: $tanggalSelesai}';
  }

  // Helper method untuk mendapatkan status agenda
  String getStatus() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final startDate = DateTime(tanggalMulai.year, tanggalMulai.month, tanggalMulai.day);
    final endDate = DateTime(tanggalSelesai.year, tanggalSelesai.month, tanggalSelesai.day);

    if (today.isBefore(startDate)) {
      return 'Akan Datang';
    } else if (today.isAfter(endDate)) {
      return 'Selesai';
    } else {
      return 'Berlangsung';
    }
  }

  // Helper method untuk mendapatkan durasi dalam hari
  int getDurationInDays() {
    return tanggalSelesai.difference(tanggalMulai).inDays + 1;
  }
}