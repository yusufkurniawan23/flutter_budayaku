import 'category.dart';

class Budaya {
  final int id;
  final int categoryId;
  final String tanggal;
  final String foto;
  final String deskripsi;
  final String namaObjek;
  final Category? category;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Budaya({
    required this.id,
    required this.categoryId,
    required this.tanggal,
    required this.foto,
    required this.deskripsi,
    required this.namaObjek,
    this.category,
    this.createdAt,
    this.updatedAt,
  });

  factory Budaya.fromJson(Map<String, dynamic> json) {
    return Budaya(
      id: json['id'],
      categoryId: json['category_id'],
      tanggal: json['tanggal'],
      foto: json['foto'],
      deskripsi: json['deskripsi'],
      namaObjek: json['nama_objek'],
      category:
          json['category'] != null ? Category.fromJson(json['category']) : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }
}
