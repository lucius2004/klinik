// lib/models/rekam_medis_model.dart

class RekamMedisModel {
  final String id;
  final String pendaftaranId;
  final String pasienId;
  final String pasienNama;
  final String pasienNoRm;
  final String dokterId;
  final String dokterNama;
  final String tanggalPeriksa;
  final String? anamnesa;
  final String? diagnosaPrimer;
  final String? diagnosaSekunder;
  final String? tindakan;
  final String? resepObat;
  final String? anjuran;
  final String? catatanDokter;
  final String? catatanPerawat;
  final String status; // draft, selesai
  final DateTime createdAt;
  final DateTime? updatedAt;

  RekamMedisModel({
    required this.id,
    required this.pendaftaranId,
    required this.pasienId,
    required this.pasienNama,
    required this.pasienNoRm,
    required this.dokterId,
    required this.dokterNama,
    required this.tanggalPeriksa,
    this.anamnesa,
    this.diagnosaPrimer,
    this.diagnosaSekunder,
    this.tindakan,
    this.resepObat,
    this.anjuran,
    this.catatanDokter,
    this.catatanPerawat,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  factory RekamMedisModel.fromJson(Map<String, dynamic> json) {
    return RekamMedisModel(
      id: json['id'] ?? '',
      pendaftaranId: json['pendaftaranId'] ?? '',
      pasienId: json['pasienId'] ?? '',
      pasienNama: json['pasienNama'] ?? '',
      pasienNoRm: json['pasienNoRm'] ?? '',
      dokterId: json['dokterId'] ?? '',
      dokterNama: json['dokterNama'] ?? '',
      tanggalPeriksa: json['tanggalPeriksa'] ?? '',
      anamnesa: json['anamnesa'],
      diagnosaPrimer: json['diagnosaPrimer'],
      diagnosaSekunder: json['diagnosaSekunder'],
      tindakan: json['tindakan'],
      resepObat: json['resepObat'],
      anjuran: json['anjuran'],
      catatanDokter: json['catatanDokter'],
      catatanPerawat: json['catatanPerawat'],
      status: json['status'] ?? 'draft',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pendaftaranId': pendaftaranId,
      'pasienId': pasienId,
      'pasienNama': pasienNama,
      'pasienNoRm': pasienNoRm,
      'dokterId': dokterId,
      'dokterNama': dokterNama,
      'tanggalPeriksa': tanggalPeriksa,
      'anamnesa': anamnesa,
      'diagnosaPrimer': diagnosaPrimer,
      'diagnosaSekunder': diagnosaSekunder,
      'tindakan': tindakan,
      'resepObat': resepObat,
      'anjuran': anjuran,
      'catatanDokter': catatanDokter,
      'catatanPerawat': catatanPerawat,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  RekamMedisModel copyWith({
    String? id,
    String? pendaftaranId,
    String? pasienId,
    String? pasienNama,
    String? pasienNoRm,
    String? dokterId,
    String? dokterNama,
    String? tanggalPeriksa,
    String? anamnesa,
    String? diagnosaPrimer,
    String? diagnosaSekunder,
    String? tindakan,
    String? resepObat,
    String? anjuran,
    String? catatanDokter,
    String? catatanPerawat,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RekamMedisModel(
      id: id ?? this.id,
      pendaftaranId: pendaftaranId ?? this.pendaftaranId,
      pasienId: pasienId ?? this.pasienId,
      pasienNama: pasienNama ?? this.pasienNama,
      pasienNoRm: pasienNoRm ?? this.pasienNoRm,
      dokterId: dokterId ?? this.dokterId,
      dokterNama: dokterNama ?? this.dokterNama,
      tanggalPeriksa: tanggalPeriksa ?? this.tanggalPeriksa,
      anamnesa: anamnesa ?? this.anamnesa,
      diagnosaPrimer: diagnosaPrimer ?? this.diagnosaPrimer,
      diagnosaSekunder: diagnosaSekunder ?? this.diagnosaSekunder,
      tindakan: tindakan ?? this.tindakan,
      resepObat: resepObat ?? this.resepObat,
      anjuran: anjuran ?? this.anjuran,
      catatanDokter: catatanDokter ?? this.catatanDokter,
      catatanPerawat: catatanPerawat ?? this.catatanPerawat,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}