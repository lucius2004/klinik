// lib/models/layanan_model.dart

class LayananModel {
  final String id;
  final String kode;
  final String nama;
  final String kategori; // Pemeriksaan/Tindakan/Laboratorium/Radiologi/dll
  final String deskripsi;
  final double tarif;
  final int durasiMenit; // Estimasi durasi layanan dalam menit
  final bool membutuhkanDokter;
  final bool membutuhkanPerawat;
  final bool membutuhkanAlat;
  final String keteranganAlat; // Alat yang dibutuhkan
  final String unitPelayanan; // Poli Umum/Poli Gigi/Laboratorium/dll
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isActive;

  LayananModel({
    required this.id,
    required this.kode,
    required this.nama,
    required this.kategori,
    this.deskripsi = '',
    required this.tarif,
    this.durasiMenit = 30,
    this.membutuhkanDokter = true,
    this.membutuhkanPerawat = false,
    this.membutuhkanAlat = false,
    this.keteranganAlat = '',
    this.unitPelayanan = 'Poli Umum',
    DateTime? createdAt,
    this.updatedAt,
    this.isActive = true,
  }) : createdAt = createdAt ?? DateTime.now();

  String get durasi {
    if (durasiMenit < 60) {
      return '$durasiMenit menit';
    } else {
      final jam = durasiMenit ~/ 60;
      final menit = durasiMenit % 60;
      if (menit == 0) {
        return '$jam jam';
      }
      return '$jam jam $menit menit';
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'kode': kode,
      'nama': nama,
      'kategori': kategori,
      'deskripsi': deskripsi,
      'tarif': tarif,
      'durasiMenit': durasiMenit,
      'membutuhkanDokter': membutuhkanDokter,
      'membutuhkanPerawat': membutuhkanPerawat,
      'membutuhkanAlat': membutuhkanAlat,
      'keteranganAlat': keteranganAlat,
      'unitPelayanan': unitPelayanan,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory LayananModel.fromMap(Map<String, dynamic> map) {
    return LayananModel(
      id: map['id'] ?? '',
      kode: map['kode'] ?? '',
      nama: map['nama'] ?? '',
      kategori: map['kategori'] ?? 'Pemeriksaan',
      deskripsi: map['deskripsi'] ?? '',
      tarif: (map['tarif'] ?? 0).toDouble(),
      durasiMenit: map['durasiMenit'] ?? 30,
      membutuhkanDokter: map['membutuhkanDokter'] ?? true,
      membutuhkanPerawat: map['membutuhkanPerawat'] ?? false,
      membutuhkanAlat: map['membutuhkanAlat'] ?? false,
      keteranganAlat: map['keteranganAlat'] ?? '',
      unitPelayanan: map['unitPelayanan'] ?? 'Poli Umum',
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt:
          map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      isActive: map['isActive'] ?? true,
    );
  }

  LayananModel copyWith({
    String? id,
    String? kode,
    String? nama,
    String? kategori,
    String? deskripsi,
    double? tarif,
    int? durasiMenit,
    bool? membutuhkanDokter,
    bool? membutuhkanPerawat,
    bool? membutuhkanAlat,
    String? keteranganAlat,
    String? unitPelayanan,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return LayananModel(
      id: id ?? this.id,
      kode: kode ?? this.kode,
      nama: nama ?? this.nama,
      kategori: kategori ?? this.kategori,
      deskripsi: deskripsi ?? this.deskripsi,
      tarif: tarif ?? this.tarif,
      durasiMenit: durasiMenit ?? this.durasiMenit,
      membutuhkanDokter: membutuhkanDokter ?? this.membutuhkanDokter,
      membutuhkanPerawat: membutuhkanPerawat ?? this.membutuhkanPerawat,
      membutuhkanAlat: membutuhkanAlat ?? this.membutuhkanAlat,
      keteranganAlat: keteranganAlat ?? this.keteranganAlat,
      unitPelayanan: unitPelayanan ?? this.unitPelayanan,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}