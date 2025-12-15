// lib/models/dokter_model.dart

class DokterModel {
  final String id;
  final String nip;
  final String nama;
  final String jenisKelamin; // L/P
  final String spesialisasi; // Umum/Anak/Gigi/dll
  final String noSTR; // Surat Tanda Registrasi
  final String noSIP; // Surat Izin Praktik
  final String pendidikan;
  final String alamat;
  final String noTelepon;
  final String email;
  final DateTime tanggalLahir;
  final String tempatLahir;
  final double tarif; // Tarif konsultasi
  final String jamPraktik; // Format: "Senin-Jumat: 08:00-16:00"
  final String foto; // URL atau path foto
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isActive;

  DokterModel({
    required this.id,
    required this.nip,
    required this.nama,
    required this.jenisKelamin,
    required this.spesialisasi,
    required this.noSTR,
    required this.noSIP,
    required this.pendidikan,
    required this.alamat,
    required this.noTelepon,
    required this.email,
    required this.tanggalLahir,
    required this.tempatLahir,
    this.tarif = 0,
    this.jamPraktik = '',
    this.foto = '',
    DateTime? createdAt,
    this.updatedAt,
    this.isActive = true,
  }) : createdAt = createdAt ?? DateTime.now();

  int get umur {
    final now = DateTime.now();
    int age = now.year - tanggalLahir.year;
    if (now.month < tanggalLahir.month ||
        (now.month == tanggalLahir.month && now.day < tanggalLahir.day)) {
      age--;
    }
    return age;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nip': nip,
      'nama': nama,
      'jenisKelamin': jenisKelamin,
      'spesialisasi': spesialisasi,
      'noSTR': noSTR,
      'noSIP': noSIP,
      'pendidikan': pendidikan,
      'alamat': alamat,
      'noTelepon': noTelepon,
      'email': email,
      'tanggalLahir': tanggalLahir.toIso8601String(),
      'tempatLahir': tempatLahir,
      'tarif': tarif,
      'jamPraktik': jamPraktik,
      'foto': foto,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory DokterModel.fromMap(Map<String, dynamic> map) {
    return DokterModel(
      id: map['id'] ?? '',
      nip: map['nip'] ?? '',
      nama: map['nama'] ?? '',
      jenisKelamin: map['jenisKelamin'] ?? 'L',
      spesialisasi: map['spesialisasi'] ?? 'Umum',
      noSTR: map['noSTR'] ?? '',
      noSIP: map['noSIP'] ?? '',
      pendidikan: map['pendidikan'] ?? '',
      alamat: map['alamat'] ?? '',
      noTelepon: map['noTelepon'] ?? '',
      email: map['email'] ?? '',
      tanggalLahir: DateTime.parse(map['tanggalLahir']),
      tempatLahir: map['tempatLahir'] ?? '',
      tarif: (map['tarif'] ?? 0).toDouble(),
      jamPraktik: map['jamPraktik'] ?? '',
      foto: map['foto'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt:
          map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      isActive: map['isActive'] ?? true,
    );
  }

  DokterModel copyWith({
    String? id,
    String? nip,
    String? nama,
    String? jenisKelamin,
    String? spesialisasi,
    String? noSTR,
    String? noSIP,
    String? pendidikan,
    String? alamat,
    String? noTelepon,
    String? email,
    DateTime? tanggalLahir,
    String? tempatLahir,
    double? tarif,
    String? jamPraktik,
    String? foto,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return DokterModel(
      id: id ?? this.id,
      nip: nip ?? this.nip,
      nama: nama ?? this.nama,
      jenisKelamin: jenisKelamin ?? this.jenisKelamin,
      spesialisasi: spesialisasi ?? this.spesialisasi,
      noSTR: noSTR ?? this.noSTR,
      noSIP: noSIP ?? this.noSIP,
      pendidikan: pendidikan ?? this.pendidikan,
      alamat: alamat ?? this.alamat,
      noTelepon: noTelepon ?? this.noTelepon,
      email: email ?? this.email,
      tanggalLahir: tanggalLahir ?? this.tanggalLahir,
      tempatLahir: tempatLahir ?? this.tempatLahir,
      tarif: tarif ?? this.tarif,
      jamPraktik: jamPraktik ?? this.jamPraktik,
      foto: foto ?? this.foto,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}