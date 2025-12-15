// lib/models/staff_model.dart

class StaffModel {
  final String id;
  final String nip;
  final String nama;
  final String jenisKelamin; // L/P
  final String posisi; // Perawat/Administrasi/Apoteker/Laboratorium/Kasir/dll
  final String pendidikan;
  final String alamat;
  final String noTelepon;
  final String email;
  final DateTime tanggalLahir;
  final String tempatLahir;
  final String shift; // Pagi/Siang/Malam/Fleksibel
  final double gaji;
  final String noRekening;
  final String namaBank;
  final String kontakDarurat;
  final String noKontakDarurat;
  final String foto; // URL atau path foto
  final DateTime tanggalBergabung;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isActive;

  StaffModel({
    required this.id,
    required this.nip,
    required this.nama,
    required this.jenisKelamin,
    required this.posisi,
    required this.pendidikan,
    required this.alamat,
    required this.noTelepon,
    required this.email,
    required this.tanggalLahir,
    required this.tempatLahir,
    this.shift = 'Pagi',
    this.gaji = 0,
    this.noRekening = '',
    this.namaBank = '',
    this.kontakDarurat = '',
    this.noKontakDarurat = '',
    this.foto = '',
    DateTime? tanggalBergabung,
    DateTime? createdAt,
    this.updatedAt,
    this.isActive = true,
  })  : tanggalBergabung = tanggalBergabung ?? DateTime.now(),
        createdAt = createdAt ?? DateTime.now();

  int get umur {
    final now = DateTime.now();
    int age = now.year - tanggalLahir.year;
    if (now.month < tanggalLahir.month ||
        (now.month == tanggalLahir.month && now.day < tanggalLahir.day)) {
      age--;
    }
    return age;
  }

  int get lamaBekerja {
    final now = DateTime.now();
    int years = now.year - tanggalBergabung.year;
    if (now.month < tanggalBergabung.month ||
        (now.month == tanggalBergabung.month &&
            now.day < tanggalBergabung.day)) {
      years--;
    }
    return years;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nip': nip,
      'nama': nama,
      'jenisKelamin': jenisKelamin,
      'posisi': posisi,
      'pendidikan': pendidikan,
      'alamat': alamat,
      'noTelepon': noTelepon,
      'email': email,
      'tanggalLahir': tanggalLahir.toIso8601String(),
      'tempatLahir': tempatLahir,
      'shift': shift,
      'gaji': gaji,
      'noRekening': noRekening,
      'namaBank': namaBank,
      'kontakDarurat': kontakDarurat,
      'noKontakDarurat': noKontakDarurat,
      'foto': foto,
      'tanggalBergabung': tanggalBergabung.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory StaffModel.fromMap(Map<String, dynamic> map) {
    return StaffModel(
      id: map['id'] ?? '',
      nip: map['nip'] ?? '',
      nama: map['nama'] ?? '',
      jenisKelamin: map['jenisKelamin'] ?? 'L',
      posisi: map['posisi'] ?? 'Administrasi',
      pendidikan: map['pendidikan'] ?? '',
      alamat: map['alamat'] ?? '',
      noTelepon: map['noTelepon'] ?? '',
      email: map['email'] ?? '',
      tanggalLahir: DateTime.parse(map['tanggalLahir']),
      tempatLahir: map['tempatLahir'] ?? '',
      shift: map['shift'] ?? 'Pagi',
      gaji: (map['gaji'] ?? 0).toDouble(),
      noRekening: map['noRekening'] ?? '',
      namaBank: map['namaBank'] ?? '',
      kontakDarurat: map['kontakDarurat'] ?? '',
      noKontakDarurat: map['noKontakDarurat'] ?? '',
      foto: map['foto'] ?? '',
      tanggalBergabung: DateTime.parse(map['tanggalBergabung']),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt:
          map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      isActive: map['isActive'] ?? true,
    );
  }

  StaffModel copyWith({
    String? id,
    String? nip,
    String? nama,
    String? jenisKelamin,
    String? posisi,
    String? pendidikan,
    String? alamat,
    String? noTelepon,
    String? email,
    DateTime? tanggalLahir,
    String? tempatLahir,
    String? shift,
    double? gaji,
    String? noRekening,
    String? namaBank,
    String? kontakDarurat,
    String? noKontakDarurat,
    String? foto,
    DateTime? tanggalBergabung,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return StaffModel(
      id: id ?? this.id,
      nip: nip ?? this.nip,
      nama: nama ?? this.nama,
      jenisKelamin: jenisKelamin ?? this.jenisKelamin,
      posisi: posisi ?? this.posisi,
      pendidikan: pendidikan ?? this.pendidikan,
      alamat: alamat ?? this.alamat,
      noTelepon: noTelepon ?? this.noTelepon,
      email: email ?? this.email,
      tanggalLahir: tanggalLahir ?? this.tanggalLahir,
      tempatLahir: tempatLahir ?? this.tempatLahir,
      shift: shift ?? this.shift,
      gaji: gaji ?? this.gaji,
      noRekening: noRekening ?? this.noRekening,
      namaBank: namaBank ?? this.namaBank,
      kontakDarurat: kontakDarurat ?? this.kontakDarurat,
      noKontakDarurat: noKontakDarurat ?? this.noKontakDarurat,
      foto: foto ?? this.foto,
      tanggalBergabung: tanggalBergabung ?? this.tanggalBergabung,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}