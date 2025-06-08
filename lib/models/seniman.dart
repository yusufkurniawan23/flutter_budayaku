class Seniman {
  final int id;
  final int? userId;
  final String nama;
  final String alamat;
  final String judul;
  final String foto;
  final String nomor;
  final String deskripsi;
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
    this.createdAt,
    this.updatedAt,
  });

  factory Seniman.fromJson(Map<String, dynamic> json) {
    return Seniman(
      id: json['id'],
      userId: json['user_id'],
      nama: json['nama'],
      alamat: json['alamat'],
      judul: json['judul'],
      foto: json['foto'],
      nomor: json['nomor'],
      deskripsi: json['deskripsi'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }
}