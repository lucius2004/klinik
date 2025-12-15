// lib/models/pendaftaran_model.dart

class PendaftaranModel {
  final String id;
  final String noPendaftaran;
  final String pasienId;
  final String pasienNama;
  final String pasienNoRm;
  final String dokterId;
  final String dokterNama;
  final String spesialisasi;
  final String layananId;
  final String layananNama;
  final String tanggalDaftar;
  final String jamDaftar;
  final int noAntrean;
  final String keluhan;
  final String status; // menunggu, dipanggil, selesai, batal
  final String? ruangan;
  final String? catatan;
  final DateTime createdAt;

  PendaftaranModel({
    required this.id,
    required this.noPendaftaran,
    required this.pasienId,
    required this.pasienNama,
    required this.pasienNoRm,
    required this.dokterId,
    required this.dokterNama,
    required this.spesialisasi,
    required this.layananId,
    required this.layananNama,
    required this.tanggalDaftar,
    required this.jamDaftar,
    required this.noAntrean,
    required this.keluhan,
    required this.status,
    this.ruangan,
    this.catatan,
    required this.createdAt,
  });

  factory PendaftaranModel.fromJson(Map<String, dynamic> json) {
    return PendaftaranModel(
      id: json['id'] ?? '',
      noPendaftaran: json['noPendaftaran'] ?? '',
      pasienId: json['pasienId'] ?? '',
      pasienNama: json['pasienNama'] ?? '',
      pasienNoRm: json['pasienNoRm'] ?? '',
      dokterId: json['dokterId'] ?? '',
      dokterNama: json['dokterNama'] ?? '',
      spesialisasi: json['spesialisasi'] ?? '',
      layananId: json['layananId'] ?? '',
      layananNama: json['layananNama'] ?? '',
      tanggalDaftar: json['tanggalDaftar'] ?? '',
      jamDaftar: json['jamDaftar'] ?? '',
      noAntrean: json['noAntrean'] ?? 0,
      keluhan: json['keluhan'] ?? '',
      status: json['status'] ?? 'menunggu',
      ruangan: json['ruangan'],
      catatan: json['catatan'],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'noPendaftaran': noPendaftaran,
      'pasienId': pasienId,
      'pasienNama': pasienNama,
      'pasienNoRm': pasienNoRm,
      'dokterId': dokterId,
      'dokterNama': dokterNama,
      'spesialisasi': spesialisasi,
      'layananId': layananId,
      'layananNama': layananNama,
      'tanggalDaftar': tanggalDaftar,
      'jamDaftar': jamDaftar,
      'noAntrean': noAntrean,
      'keluhan': keluhan,
      'status': status,
      'ruangan': ruangan,
      'catatan': catatan,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  PendaftaranModel copyWith({
    String? id,
    String? noPendaftaran,
    String? pasienId,
    String? pasienNama,
    String? pasienNoRm,
    String? dokterId,
    String? dokterNama,
    String? spesialisasi,
    String? layananId,
    String? layananNama,
    String? tanggalDaftar,
    String? jamDaftar,
    int? noAntrean,
    String? keluhan,
    String? status,
    String? ruangan,
    String? catatan,
    DateTime? createdAt,
  }) {
    return PendaftaranModel(
      id: id ?? this.id,
      noPendaftaran: noPendaftaran ?? this.noPendaftaran,
      pasienId: pasienId ?? this.pasienId,
      pasienNama: pasienNama ?? this.pasienNama,
      pasienNoRm: pasienNoRm ?? this.pasienNoRm,
      dokterId: dokterId ?? this.dokterId,
      dokterNama: dokterNama ?? this.dokterNama,
      spesialisasi: spesialisasi ?? this.spesialisasi,
      layananId: layananId ?? this.layananId,
      layananNama: layananNama ?? this.layananNama,
      tanggalDaftar: tanggalDaftar ?? this.tanggalDaftar,
      jamDaftar: jamDaftar ?? this.jamDaftar,
      noAntrean: noAntrean ?? this.noAntrean,
      keluhan: keluhan ?? this.keluhan,
      status: status ?? this.status,
      ruangan: ruangan ?? this.ruangan,
      catatan: catatan ?? this.catatan,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}