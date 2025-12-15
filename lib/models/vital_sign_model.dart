// lib/models/vital_sign_model.dart

class VitalSignModel {
  final String id;
  final String pendaftaranId;
  final String pasienId;
  final String pasienNama;
  final String pasienNoRm;
  final double? tekananDarahSistolik;
  final double? tekananDarahDiastolik;
  final double? suhuTubuh; // Celsius
  final int? denyutNadi; // per menit
  final int? lajuPernapasan; // per menit
  final double? beratBadan; // kg
  final double? tinggiBadan; // cm
  final double? saturasiOksigen; // %
  final String? keluhan;
  final String? catatan;
  final String petugasId;
  final String petugasNama;
  final DateTime tanggalInput;

  VitalSignModel({
    required this.id,
    required this.pendaftaranId,
    required this.pasienId,
    required this.pasienNama,
    required this.pasienNoRm,
    this.tekananDarahSistolik,
    this.tekananDarahDiastolik,
    this.suhuTubuh,
    this.denyutNadi,
    this.lajuPernapasan,
    this.beratBadan,
    this.tinggiBadan,
    this.saturasiOksigen,
    this.keluhan,
    this.catatan,
    required this.petugasId,
    required this.petugasNama,
    required this.tanggalInput,
  });

  factory VitalSignModel.fromJson(Map<String, dynamic> json) {
    return VitalSignModel(
      id: json['id'] ?? '',
      pendaftaranId: json['pendaftaranId'] ?? '',
      pasienId: json['pasienId'] ?? '',
      pasienNama: json['pasienNama'] ?? '',
      pasienNoRm: json['pasienNoRm'] ?? '',
      tekananDarahSistolik: json['tekananDarahSistolik']?.toDouble(),
      tekananDarahDiastolik: json['tekananDarahDiastolik']?.toDouble(),
      suhuTubuh: json['suhuTubuh']?.toDouble(),
      denyutNadi: json['denyutNadi'],
      lajuPernapasan: json['lajuPernapasan'],
      beratBadan: json['beratBadan']?.toDouble(),
      tinggiBadan: json['tinggiBadan']?.toDouble(),
      saturasiOksigen: json['saturasiOksigen']?.toDouble(),
      keluhan: json['keluhan'],
      catatan: json['catatan'],
      petugasId: json['petugasId'] ?? '',
      petugasNama: json['petugasNama'] ?? '',
      tanggalInput: json['tanggalInput'] != null
          ? DateTime.parse(json['tanggalInput'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pendaftaranId': pendaftaranId,
      'pasienId': pasienId,
      'pasienNama': pasienNama,
      'pasienNoRm': pasienNoRm,
      'tekananDarahSistolik': tekananDarahSistolik,
      'tekananDarahDiastolik': tekananDarahDiastolik,
      'suhuTubuh': suhuTubuh,
      'denyutNadi': denyutNadi,
      'lajuPernapasan': lajuPernapasan,
      'beratBadan': beratBadan,
      'tinggiBadan': tinggiBadan,
      'saturasiOksigen': saturasiOksigen,
      'keluhan': keluhan,
      'catatan': catatan,
      'petugasId': petugasId,
      'petugasNama': petugasNama,
      'tanggalInput': tanggalInput.toIso8601String(),
    };
  }

  String get tekananDarah {
    if (tekananDarahSistolik != null && tekananDarahDiastolik != null) {
      return '${tekananDarahSistolik!.toInt()}/${tekananDarahDiastolik!.toInt()} mmHg';
    }
    return '-';
  }

  double? get bmi {
    if (beratBadan != null && tinggiBadan != null && tinggiBadan! > 0) {
      double tinggiMeter = tinggiBadan! / 100;
      return beratBadan! / (tinggiMeter * tinggiMeter);
    }
    return null;
  }

  String get bmiCategory {
    final bmiValue = bmi;
    if (bmiValue == null) return '-';
    
    if (bmiValue < 18.5) return 'Kurus';
    if (bmiValue < 25) return 'Normal';
    if (bmiValue < 30) return 'Gemuk';
    return 'Obesitas';
  }
}