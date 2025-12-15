// lib/pages/staff/rekam_medis/rekam_medis_form_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../providers/pendaftaran_provider.dart';
import '../../../models/pendaftaran_model.dart';

class RekamMedisFormPage extends StatefulWidget {
  const RekamMedisFormPage({super.key});

  @override
  State<RekamMedisFormPage> createState() => _RekamMedisFormPageState();
}

class _RekamMedisFormPageState extends State<RekamMedisFormPage> {
  final _formKey = GlobalKey<FormState>();
  
  final _anamnesaController = TextEditingController();
  final _diagnosaPrimerController = TextEditingController();
  final _diagnosaSekunderController = TextEditingController();
  final _tindakanController = TextEditingController();
  final _resepObatController = TextEditingController();
  final _anjuranController = TextEditingController();
  final _catatanPerawatController = TextEditingController();

  String? _selectedPendaftaranId;
  PendaftaranModel? _selectedPendaftaran;

  @override
  void dispose() {
    _anamnesaController.dispose();
    _diagnosaPrimerController.dispose();
    _diagnosaSekunderController.dispose();
    _tindakanController.dispose();
    _resepObatController.dispose();
    _anjuranController.dispose();
    _catatanPerawatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pendaftaranProvider = Provider.of<PendaftaranProvider>(context);
    final pendaftaranList = pendaftaranProvider.getPendaftaranByStatus('dipanggil');

    return Scaffold(
      appBar: AppBar(
        title: const Text('INPUT REKAM MEDIS'),
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
                color: Colors.teal[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.description, color: Colors.teal[700]),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Input data rekam medis dasar sebelum pemeriksaan dokter',
                          style: TextStyle(color: Colors.teal[900]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Pilih Pasien
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
                  labelText: 'Pasien yang sedang diperiksa',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                items: pendaftaranList.map((pendaftaran) {
                  return DropdownMenuItem(
                    value: pendaftaran.id,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${pendaftaran.pasienNama} (Antrean ${pendaftaran.noAntrean})'),
                        Text(
                          'Dokter: ${pendaftaran.dokterNama}',
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
                            'Informasi Kunjungan',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('No. RM: ${_selectedPendaftaran!.pasienNoRm}'),
                      Text('Layanan: ${_selectedPendaftaran!.layananNama}'),
                      Text('Keluhan: ${_selectedPendaftaran!.keluhan}'),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Anamnesa (Subjective)
              const Text(
                'Anamnesa / Keluhan Utama',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Riwayat keluhan dan gejala yang dialami pasien',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _anamnesaController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Contoh: Pasien mengeluh demam sejak 3 hari yang lalu, disertai batuk dan pilek...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Anamnesa harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Diagnosa Primer (Assessment)
              const Text(
                'Diagnosa Primer',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Diagnosa utama / diagnosis kerja',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _diagnosaPrimerController,
                decoration: InputDecoration(
                  hintText: 'Contoh: ISPA (Infeksi Saluran Pernapasan Akut)',
                  prefixIcon: const Icon(Icons.medical_information),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Diagnosa primer harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Diagnosa Sekunder (Optional)
              const Text(
                'Diagnosa Sekunder (Opsional)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Diagnosa tambahan jika ada',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _diagnosaSekunderController,
                decoration: InputDecoration(
                  hintText: 'Contoh: Gastritis',
                  prefixIcon: const Icon(Icons.medical_information_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
              const SizedBox(height: 24),

              // Tindakan Medis
              const Text(
                'Tindakan Medis',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tindakan yang dilakukan pada pasien',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _tindakanController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Contoh: Pemeriksaan fisik, pengukuran vital sign, injeksi...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
              const SizedBox(height: 24),

              // Resep Obat
              const Text(
                'Resep Obat',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Daftar obat yang diberikan',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _resepObatController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Contoh:\n1. Paracetamol 500mg - 3x1 tablet\n2. Amoxicillin 500mg - 3x1 kapsul\n3. OBH Sirup - 3x1 sendok makan',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
              const SizedBox(height: 24),

              // Anjuran
              const Text(
                'Anjuran / Edukasi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Saran dan edukasi untuk pasien',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _anjuranController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Contoh: Istirahat cukup, minum air putih minimal 8 gelas/hari, kontrol kembali jika keluhan tidak membaik...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
              const SizedBox(height: 24),

              // Catatan Perawat
              const Text(
                'Catatan Perawat',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Catatan tambahan dari perawat',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _catatanPerawatController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Catatan observasi perawat...',
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
                    'SIMPAN REKAM MEDIS',
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
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Rekam medis berhasil disimpan'),
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
                    'Pasien: ${_selectedPendaftaran?.pasienNama}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text('Diagnosa: ${_diagnosaPrimerController.text}'),
                  const SizedBox(height: 4),
                  Text('Tanggal: ${DateFormat('dd MMM yyyy', 'id_ID').format(DateTime.now())}'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('TUTUP'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to invoice creation
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Lanjut ke pembuatan invoice'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
            ),
            child: const Text('BUAT INVOICE'),
          ),
        ],
      ),
    );
  }
}