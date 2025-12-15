// lib/models/jadwal_model.dart

class JadwalModel {
  final String id;
  final String dokterId;
  final String dokterNama;
  final String spesialisasi;
  final String hari; // Senin, Selasa, etc
  final String jamMulai; // HH:mm format
  final String jamSelesai;
  final String ruangan;
  final int kuotaPasien;
  final bool isActive;
  final String? keterangan;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  JadwalModel({
    required this.id,
    required this.dokterId,
    required this.dokterNama,
    required this.spesialisasi,
    required this.hari,
    required this.jamMulai,
    required this.jamSelesai,
    required this.ruangan,
    required this.kuotaPasien,
    this.isActive = true,
    this.keterangan,
    this.createdAt,
    this.updatedAt,
  });

  String get waktuPraktik => '$jamMulai - $jamSelesai';

  factory JadwalModel.fromJson(Map<String, dynamic> json) {
    return JadwalModel(
      id: json['id'] ?? '',
      dokterId: json['dokterId'] ?? '',
      dokterNama: json['dokterNama'] ?? '',
      spesialisasi: json['spesialisasi'] ?? '',
      hari: json['hari'] ?? '',
      jamMulai: json['jamMulai'] ?? '',
      jamSelesai: json['jamSelesai'] ?? '',
      ruangan: json['ruangan'] ?? '',
      kuotaPasien: json['kuotaPasien'] ?? 0,
      isActive: json['isActive'] ?? true,
      keterangan: json['keterangan'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dokterId': dokterId,
      'dokterNama': dokterNama,
      'spesialisasi': spesialisasi,
      'hari': hari,
      'jamMulai': jamMulai,
      'jamSelesai': jamSelesai,
      'ruangan': ruangan,
      'kuotaPasien': kuotaPasien,
      'isActive': isActive,
      'keterangan': keterangan,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  JadwalModel copyWith({
    String? id,
    String? dokterId,
    String? dokterNama,
    String? spesialisasi,
    String? hari,
    String? jamMulai,
    String? jamSelesai,
    String? ruangan,
    int? kuotaPasien,
    bool? isActive,
    String? keterangan,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return JadwalModel(
      id: id ?? this.id,
      dokterId: dokterId ?? this.dokterId,
      dokterNama: dokterNama ?? this.dokterNama,
      spesialisasi: spesialisasi ?? this.spesialisasi,
      hari: hari ?? this.hari,
      jamMulai: jamMulai ?? this.jamMulai,
      jamSelesai: jamSelesai ?? this.jamSelesai,
      ruangan: ruangan ?? this.ruangan,
      kuotaPasien: kuotaPasien ?? this.kuotaPasien,
      isActive: isActive ?? this.isActive,
      keterangan: keterangan ?? this.keterangan,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}