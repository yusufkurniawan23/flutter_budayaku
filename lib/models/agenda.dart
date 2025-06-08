// filepath: d:\budayaku\budayaku\lib\models\agenda.dart
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
    return Agenda(
      id: json['id'],
      judul: json['judul'],
      lokasi: json['lokasi'],
      tanggalMulai: DateTime.parse(json['tanggal_mulai']),
      tanggalSelesai: DateTime.parse(json['tanggal_selesai']),
      deskripsi: json['deskripsi'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }
}
