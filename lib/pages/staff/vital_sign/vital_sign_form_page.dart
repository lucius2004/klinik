// lib/pages/staff/vital_sign/vital_sign_form_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../providers/pendaftaran_provider.dart';
import '../../../models/pendaftaran_model.dart';

class VitalSignFormPage extends StatefulWidget {
  const VitalSignFormPage({super.key});

  @override
  State<VitalSignFormPage> createState() => _VitalSignFormPageState();
}

class _VitalSignFormPageState extends State<VitalSignFormPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _sistolikController = TextEditingController();
  final _diastolikController = TextEditingController();
  final _suhuController = TextEditingController();
  final _nadiController = TextEditingController();
  final _pernapasanController = TextEditingController();
  final _beratBadanController = TextEditingController();
  final _tinggiBadanController = TextEditingController();
  final _saturasiController = TextEditingController();
  final _keluhanController = TextEditingController();
  final _catatanController = TextEditingController();

  String? _selectedPendaftaranId;
  PendaftaranModel? _selectedPendaftaran;

  @override
  void dispose() {
    _sistolikController.dispose();
    _diastolikController.dispose();
    _suhuController.dispose();
    _nadiController.dispose();
    _pernapasanController.dispose();
    _beratBadanController.dispose();
    _tinggiBadanController.dispose();
    _saturasiController.dispose();
    _keluhanController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  double? get bmi {
    final berat = double.tryParse(_beratBadanController.text);
    final tinggi = double.tryParse(_tinggiBadanController.text);
    if (berat != null && tinggi != null && tinggi > 0) {
      final tinggiMeter = tinggi / 100;
      return berat / (tinggiMeter * tinggiMeter);
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

  Color get bmiColor {
    final bmiValue = bmi;
    if (bmiValue == null) return Colors.grey;
    if (bmiValue < 18.5) return Colors.orange;
    if (bmiValue < 25) return Colors.green;
    if (bmiValue < 30) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final pendaftaranProvider = Provider.of<PendaftaranProvider>(context);
    final antreanList = pendaftaranProvider.antreanMenunggu;

    return Scaffold(
      appBar: AppBar(
        title: const Text('INPUT VITAL SIGN'),
        backgroundColor: const Color(0xFF2E7D32),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Card
              Card(
                color: Colors.red[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.favorite, color: Colors.red[700]),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Input tanda vital pasien sebelum pemeriksaan dokter',
                          style: TextStyle(color: Colors.red[900]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Pilih Pasien dari Antrean
              const Text(
                'Pilih Pasien',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _selectedPendaftaranId,
                decoration: InputDecoration(
                  labelText: 'Pasien yang akan diperiksa',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                items: antreanList.map((pendaftaran) {
                  return DropdownMenuItem(
                    value: pendaftaran.id,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Antrean ${pendaftaran.noAntrean} - ${pendaftaran.pasienNama}'),
                        Text(
                          'RM: ${pendaftaran.pasienNoRm} | ${pendaftaran.dokterNama}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPendaftaranId = value;
                    _selectedPendaftaran = pendaftaranProvider
                        .getPendaftaranById(value!);
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pilih pasien terlebih dahulu';
                  }
                  return null;
                },
              ),

              if (_selectedPendaftaran != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info, color: Colors.blue[700], size: 20),
                          const SizedBox(width: 8),
                          const Text(
                            'Informasi Pasien',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Keluhan: ${_selectedPendaftaran!.keluhan}'),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Tekanan Darah
              const Text(
                'Tekanan Darah (mmHg)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _sistolikController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: 'Sistolik',
                        hintText: '120',
                        prefixIcon: const Icon(Icons.arrow_upward),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Wajib diisi';
                        }
                        final val = int.tryParse(value);
                        if (val == null || val < 50 || val > 250) {
                          return 'Tidak valid';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    '/',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _diastolikController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: 'Diastolik',
                        hintText: '80',
                        prefixIcon: const Icon(Icons.arrow_downward),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Wajib diisi';
                        }
                        final val = int.tryParse(value);
                        if (val == null || val < 30 || val > 150) {
                          return 'Tidak valid';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Row 1: Suhu & Nadi
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _suhuController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Suhu Tubuh (°C)',
                        hintText: '36.5',
                        prefixIcon: const Icon(Icons.thermostat),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Wajib diisi';
                        }
                        final val = double.tryParse(value);
                        if (val == null || val < 30 || val > 45) {
                          return 'Tidak valid';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _nadiController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: 'Nadi (x/menit)',
                        hintText: '80',
                        prefixIcon: const Icon(Icons.favorite),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Wajib diisi';
                        }
                        final val = int.tryParse(value);
                        if (val == null || val < 40 || val > 200) {
                          return 'Tidak valid';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Row 2: Pernapasan & Saturasi
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _pernapasanController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: 'Napas (x/menit)',
                        hintText: '18',
                        prefixIcon: const Icon(Icons.air),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Wajib diisi';
                        }
                        final val = int.tryParse(value);
                        if (val == null || val < 10 || val > 60) {
                          return 'Tidak valid';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _saturasiController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: 'Saturasi O2 (%)',
                        hintText: '98',
                        prefixIcon: const Icon(Icons.healing),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          final val = int.tryParse(value);
                          if (val == null || val < 70 || val > 100) {
                            return 'Tidak valid';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Berat & Tinggi Badan
              const Text(
                'Antropometri',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _beratBadanController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Berat Badan (kg)',
                        hintText: '65',
                        prefixIcon: const Icon(Icons.monitor_weight),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      onChanged: (value) => setState(() {}),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Wajib diisi';
                        }
                        final val = double.tryParse(value);
                        if (val == null || val < 10 || val > 300) {
                          return 'Tidak valid';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _tinggiBadanController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Tinggi Badan (cm)',
                        hintText: '170',
                        prefixIcon: const Icon(Icons.height),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      onChanged: (value) => setState(() {}),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Wajib diisi';
                        }
                        final val = double.tryParse(value);
                        if (val == null || val < 50 || val > 250) {
                          return 'Tidak valid';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              // BMI Display
              if (bmi != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: bmiColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: bmiColor),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calculate, color: bmiColor),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Body Mass Index (BMI)',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                bmi!.toStringAsFixed(1),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: bmiColor,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: bmiColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  bmiCategory,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),

              // Catatan
              const Text(
                'Catatan Tambahan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _catatanController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Catatan tambahan (opsional)...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'SIMPAN VITAL SIGN',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 10),
            Text('Berhasil!'),
          ],
        ),
        content: const Text('Data vital sign berhasil disimpan'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}