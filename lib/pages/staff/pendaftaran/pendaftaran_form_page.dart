// lib/pages/staff/pendaftaran/pendaftaran_form_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../providers/pendaftaran_provider.dart';
import '../../../providers/pasien_provider.dart';
import '../../../providers/dokter_provider.dart';
import '../../../providers/layanan_provider.dart';
import '../../../models/pendaftaran_model.dart';

class PendaftaranFormPage extends StatefulWidget {
  const PendaftaranFormPage({super.key});

  @override
  State<PendaftaranFormPage> createState() => _PendaftaranFormPageState();
}

class _PendaftaranFormPageState extends State<PendaftaranFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _keluhanController = TextEditingController();
  final _catatanController = TextEditingController();
  
  String? _selectedPasienId;
  String? _selectedDokterId;
  String? _selectedLayananId;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void dispose() {
    _keluhanController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pasienProvider = Provider.of<PasienProvider>(context);
    final dokterProvider = Provider.of<DokterProvider>(context);
    final layananProvider = Provider.of<LayananProvider>(context);
    final pendaftaranProvider = Provider.of<PendaftaranProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('PENDAFTARAN PASIEN'),
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
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.info, color: Colors.blue[700]),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Lengkapi form di bawah untuk mendaftarkan pasien',
                          style: TextStyle(color: Colors.blue[900]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Pilih Pasien
              const Text(
                'Data Pasien',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _selectedPasienId,
                decoration: InputDecoration(
                  labelText: 'Pilih Pasien',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                items: pasienProvider.pasienList.map((pasien) {
                  return DropdownMenuItem(
                    value: pasien.id,
                    child: Text('${pasien.nama} (${pasien.noRM})'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPasienId = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pilih pasien terlebih dahulu';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Pilih Layanan
              const Text(
                'Layanan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _selectedLayananId,
                decoration: InputDecoration(
                  labelText: 'Pilih Layanan',
                  prefixIcon: const Icon(Icons.medical_services),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                items: layananProvider.activeLayananList.map((layanan) {
                  return DropdownMenuItem(
                    value: layanan.id,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(layanan.nama),
                        Text(
                          layanan.kategori,
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
                    _selectedLayananId = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pilih layanan terlebih dahulu';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Pilih Dokter
              const Text(
                'Dokter',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _selectedDokterId,
                decoration: InputDecoration(
                  labelText: 'Pilih Dokter',
                  prefixIcon: const Icon(Icons.local_hospital),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                items: dokterProvider.activeDokterList.map((dokter) {
                  return DropdownMenuItem(
                    value: dokter.id,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(dokter.nama),
                        Text(
                          dokter.spesialisasi,
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
                    _selectedDokterId = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pilih dokter terlebih dahulu';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Tanggal & Waktu
              const Text(
                'Jadwal',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 30)),
                        );
                        if (date != null) {
                          setState(() {
                            _selectedDate = date;
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Tanggal',
                          prefixIcon: const Icon(Icons.calendar_today),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        child: Text(
                          DateFormat('dd MMMM yyyy', 'id_ID').format(_selectedDate),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: _selectedTime,
                        );
                        if (time != null) {
                          setState(() {
                            _selectedTime = time;
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Jam',
                          prefixIcon: const Icon(Icons.access_time),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        child: Text(_selectedTime.format(context)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Keluhan
              const Text(
                'Keluhan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _keluhanController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Tuliskan keluhan pasien...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Keluhan harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Catatan (Optional)
              const Text(
                'Catatan Tambahan (Opsional)',
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
                  hintText: 'Catatan tambahan...',
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
                  onPressed: pendaftaranProvider.isLoading
                      ? null
                      : () => _handleSubmit(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: pendaftaranProvider.isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'DAFTARKAN PASIEN',
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

  Future<void> _handleSubmit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final pendaftaranProvider =
        Provider.of<PendaftaranProvider>(context, listen: false);
    final pasienProvider = Provider.of<PasienProvider>(context, listen: false);
    final dokterProvider = Provider.of<DokterProvider>(context, listen: false);
    final layananProvider =
        Provider.of<LayananProvider>(context, listen: false);

    // Get selected data
    final pasien = pasienProvider.getPasienById(_selectedPasienId!);
    final dokter = dokterProvider.getDokterById(_selectedDokterId!);
    final layanan = layananProvider.getLayananById(_selectedLayananId!);

    if (pasien == null || dokter == null || layanan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data tidak lengkap'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final tanggal = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final jam = '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}';
    final noAntrean = pendaftaranProvider.getNextAntreanNumber(tanggal);

    final pendaftaran = PendaftaranModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      noPendaftaran: pendaftaranProvider.generateNoPendaftaran(),
      pasienId: pasien.id,
      pasienNama: pasien.nama,
      pasienNoRm: pasien.noRM,
      dokterId: dokter.id,
      dokterNama: dokter.nama,
      spesialisasi: dokter.spesialisasi,
      layananId: layanan.id,
      layananNama: layanan.nama,
      tanggalDaftar: tanggal,
      jamDaftar: jam,
      noAntrean: noAntrean,
      keluhan: _keluhanController.text,
      status: 'menunggu',
      catatan: _catatanController.text.isEmpty ? null : _catatanController.text,
      createdAt: DateTime.now(),
    );

    final success = await pendaftaranProvider.addPendaftaran(pendaftaran);

    if (context.mounted) {
      if (success) {
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
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Pasien berhasil didaftarkan'),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'No. Pendaftaran: ${pendaftaran.noPendaftaran}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text('Pasien: ${pendaftaran.pasienNama}'),
                      Text('Dokter: ${pendaftaran.dokterNama}'),
                      Text('No. Antrean: ${pendaftaran.noAntrean}'),
                    ],
                  ),
                ),
              ],
            ),
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
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                pendaftaranProvider.errorMessage ?? 'Gagal mendaftar pasien'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}