class User {
  final int id;
  final String name;
  final String email;
  final String? alamat;
  final String? nomor;
  final String role;
  final String? token;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.alamat,
    this.nomor,
    required this.role,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      alamat: json['alamat'],
      nomor: json['nomor'],
      role: json['role'] ?? 'user',
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'alamat': alamat,
      'nomor': nomor,
      'role': role,
    };
  }
}