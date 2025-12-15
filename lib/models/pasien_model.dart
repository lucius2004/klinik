// lib/models/pasien_model.dart

class PasienModel {
  final String id;
  final String noRM; // Nomor Rekam Medis
  final String nik;
  final String nama;
  final String jenisKelamin; // L/P
  final DateTime tanggalLahir;
  final String tempatLahir;
  final String alamat;
  final String noTelepon;
  final String email;
  final String golonganDarah; // A/B/AB/O
  final String statusPerkawinan; // Belum Kawin/Kawin/Cerai
  final String pekerjaan;
  final String namaWali; // Optional
  final String noTeleponWali; // Optional
  final String asuransi; // BPJS/Umum/Asuransi Lain
  final String noAsuransi; // Optional
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isActive;

  PasienModel({
    required this.id,
    required this.noRM,
    required this.nik,
    required this.nama,
    required this.jenisKelamin,
    required this.tanggalLahir,
    required this.tempatLahir,
    required this.alamat,
    required this.noTelepon,
    this.email = '',
    this.golonganDarah = '-',
    this.statusPerkawinan = 'Belum Kawin',
    this.pekerjaan = '',
    this.namaWali = '',
    this.noTeleponWali = '',
    this.asuransi = 'Umum',
    this.noAsuransi = '',
    DateTime? createdAt,
    this.updatedAt,
    this.isActive = true,
  }) : createdAt = createdAt ?? DateTime.now();

  // Hitung umur
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
      'noRM': noRM,
      'nik': nik,
      'nama': nama,
      'jenisKelamin': jenisKelamin,
      'tanggalLahir': tanggalLahir.toIso8601String(),
      'tempatLahir': tempatLahir,
      'alamat': alamat,
      'noTelepon': noTelepon,
      'email': email,
      'golonganDarah': golonganDarah,
      'statusPerkawinan': statusPerkawinan,
      'pekerjaan': pekerjaan,
      'namaWali': namaWali,
      'noTeleponWali': noTeleponWali,
      'asuransi': asuransi,
      'noAsuransi': noAsuransi,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory PasienModel.fromMap(Map<String, dynamic> map) {
    return PasienModel(
      id: map['id'] ?? '',
      noRM: map['noRM'] ?? '',
      nik: map['nik'] ?? '',
      nama: map['nama'] ?? '',
      jenisKelamin: map['jenisKelamin'] ?? 'L',
      tanggalLahir: DateTime.parse(map['tanggalLahir']),
      tempatLahir: map['tempatLahir'] ?? '',
      alamat: map['alamat'] ?? '',
      noTelepon: map['noTelepon'] ?? '',
      email: map['email'] ?? '',
      golonganDarah: map['golonganDarah'] ?? '-',
      statusPerkawinan: map['statusPerkawinan'] ?? 'Belum Kawin',
      pekerjaan: map['pekerjaan'] ?? '',
      namaWali: map['namaWali'] ?? '',
      noTeleponWali: map['noTeleponWali'] ?? '',
      asuransi: map['asuransi'] ?? 'Umum',
      noAsuransi: map['noAsuransi'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt:
          map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      isActive: map['isActive'] ?? true,
    );
  }

  PasienModel copyWith({
    String? id,
    String? noRM,
    String? nik,
    String? nama,
    String? jenisKelamin,
    DateTime? tanggalLahir,
    String? tempatLahir,
    String? alamat,
    String? noTelepon,
    String? email,
    String? golonganDarah,
    String? statusPerkawinan,
    String? pekerjaan,
    String? namaWali,
    String? noTeleponWali,
    String? asuransi,
    String? noAsuransi,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return PasienModel(
      id: id ?? this.id,
      noRM: noRM ?? this.noRM,
      nik: nik ?? this.nik,
      nama: nama ?? this.nama,
      jenisKelamin: jenisKelamin ?? this.jenisKelamin,
      tanggalLahir: tanggalLahir ?? this.tanggalLahir,
      tempatLahir: tempatLahir ?? this.tempatLahir,
      alamat: alamat ?? this.alamat,
      noTelepon: noTelepon ?? this.noTelepon,
      email: email ?? this.email,
      golonganDarah: golonganDarah ?? this.golonganDarah,
      statusPerkawinan: statusPerkawinan ?? this.statusPerkawinan,
      pekerjaan: pekerjaan ?? this.pekerjaan,
      namaWali: namaWali ?? this.namaWali,
      noTeleponWali: noTeleponWali ?? this.noTeleponWali,
      asuransi: asuransi ?? this.asuransi,
      noAsuransi: noAsuransi ?? this.noAsuransi,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}