// lib/models/invoice_model.dart

class InvoiceItemModel {
  final String id;
  final String itemType; // layanan, tindakan, obat
  final String itemNama;
  final int jumlah;
  final double hargaSatuan;
  final double subtotal;

  InvoiceItemModel({
    required this.id,
    required this.itemType,
    required this.itemNama,
    required this.jumlah,
    required this.hargaSatuan,
    required this.subtotal,
  });

  factory InvoiceItemModel.fromJson(Map<String, dynamic> json) {
    return InvoiceItemModel(
      id: json['id'] ?? '',
      itemType: json['itemType'] ?? '',
      itemNama: json['itemNama'] ?? '',
      jumlah: json['jumlah'] ?? 1,
      hargaSatuan: (json['hargaSatuan'] ?? 0).toDouble(),
      subtotal: (json['subtotal'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemType': itemType,
      'itemNama': itemNama,
      'jumlah': jumlah,
      'hargaSatuan': hargaSatuan,
      'subtotal': subtotal,
    };
  }
}

class InvoiceModel {
  final String id;
  final String noInvoice;
  final String pendaftaranId;
  final String pasienId;
  final String pasienNama;
  final String pasienNoRm;
  final String tanggalInvoice;
  final List<InvoiceItemModel> items;
  final double totalBiaya;
  final double? diskon;
  final double? biayaAdmin;
  final double grandTotal;
  final String statusPembayaran; // belum, lunas, sebagian
  final double? jumlahDibayar;
  final String? metodePembayaran; // tunai, debit, kredit, transfer
  final String? catatanPembayaran;
  final String petugasId;
  final String petugasNama;
  final DateTime createdAt;
  final DateTime? paidAt;

  InvoiceModel({
    required this.id,
    required this.noInvoice,
    required this.pendaftaranId,
    required this.pasienId,
    required this.pasienNama,
    required this.pasienNoRm,
    required this.tanggalInvoice,
    required this.items,
    required this.totalBiaya,
    this.diskon,
    this.biayaAdmin,
    required this.grandTotal,
    required this.statusPembayaran,
    this.jumlahDibayar,
    this.metodePembayaran,
    this.catatanPembayaran,
    required this.petugasId,
    required this.petugasNama,
    required this.createdAt,
    this.paidAt,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    List<InvoiceItemModel> itemsList = [];
    if (json['items'] != null) {
      itemsList = (json['items'] as List)
          .map((item) => InvoiceItemModel.fromJson(item))
          .toList();
    }

    return InvoiceModel(
      id: json['id'] ?? '',
      noInvoice: json['noInvoice'] ?? '',
      pendaftaranId: json['pendaftaranId'] ?? '',
      pasienId: json['pasienId'] ?? '',
      pasienNama: json['pasienNama'] ?? '',
      pasienNoRm: json['pasienNoRm'] ?? '',
      tanggalInvoice: json['tanggalInvoice'] ?? '',
      items: itemsList,
      totalBiaya: (json['totalBiaya'] ?? 0).toDouble(),
      diskon: json['diskon']?.toDouble(),
      biayaAdmin: json['biayaAdmin']?.toDouble(),
      grandTotal: (json['grandTotal'] ?? 0).toDouble(),
      statusPembayaran: json['statusPembayaran'] ?? 'belum',
      jumlahDibayar: json['jumlahDibayar']?.toDouble(),
      metodePembayaran: json['metodePembayaran'],
      catatanPembayaran: json['catatanPembayaran'],
      petugasId: json['petugasId'] ?? '',
      petugasNama: json['petugasNama'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      paidAt: json['paidAt'] != null ? DateTime.parse(json['paidAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'noInvoice': noInvoice,
      'pendaftaranId': pendaftaranId,
      'pasienId': pasienId,
      'pasienNama': pasienNama,
      'pasienNoRm': pasienNoRm,
      'tanggalInvoice': tanggalInvoice,
      'items': items.map((item) => item.toJson()).toList(),
      'totalBiaya': totalBiaya,
      'diskon': diskon,
      'biayaAdmin': biayaAdmin,
      'grandTotal': grandTotal,
      'statusPembayaran': statusPembayaran,
      'jumlahDibayar': jumlahDibayar,
      'metodePembayaran': metodePembayaran,
      'catatanPembayaran': catatanPembayaran,
      'petugasId': petugasId,
      'petugasNama': petugasNama,
      'createdAt': createdAt.toIso8601String(),
      'paidAt': paidAt?.toIso8601String(),
    };
  }

  double get sisaPembayaran {
    return grandTotal - (jumlahDibayar ?? 0);
  }

  bool get isLunas {
    return statusPembayaran == 'lunas';
  }

  InvoiceModel copyWith({
    String? id,
    String? noInvoice,
    String? pendaftaranId,
    String? pasienId,
    String? pasienNama,
    String? pasienNoRm,
    String? tanggalInvoice,
    List<InvoiceItemModel>? items,
    double? totalBiaya,
    double? diskon,
    double? biayaAdmin,
    double? grandTotal,
    String? statusPembayaran,
    double? jumlahDibayar,
    String? metodePembayaran,
    String? catatanPembayaran,
    String? petugasId,
    String? petugasNama,
    DateTime? createdAt,
    DateTime? paidAt,
  }) {
    return InvoiceModel(
      id: id ?? this.id,
      noInvoice: noInvoice ?? this.noInvoice,
      pendaftaranId: pendaftaranId ?? this.pendaftaranId,
      pasienId: pasienId ?? this.pasienId,
      pasienNama: pasienNama ?? this.pasienNama,
      pasienNoRm: pasienNoRm ?? this.pasienNoRm,
      tanggalInvoice: tanggalInvoice ?? this.tanggalInvoice,
      items: items ?? this.items,
      totalBiaya: totalBiaya ?? this.totalBiaya,
      diskon: diskon ?? this.diskon,
      biayaAdmin: biayaAdmin ?? this.biayaAdmin,
      grandTotal: grandTotal ?? this.grandTotal,
      statusPembayaran: statusPembayaran ?? this.statusPembayaran,
      jumlahDibayar: jumlahDibayar ?? this.jumlahDibayar,
      metodePembayaran: metodePembayaran ?? this.metodePembayaran,
      catatanPembayaran: catatanPembayaran ?? this.catatanPembayaran,
      petugasId: petugasId ?? this.petugasId,
      petugasNama: petugasNama ?? this.petugasNama,
      createdAt: createdAt ?? this.createdAt,
      paidAt: paidAt ?? this.paidAt,
    );
  }
}