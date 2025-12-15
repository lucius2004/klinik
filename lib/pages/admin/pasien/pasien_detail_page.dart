// lib/pages/admin/pasien/pasien_detail_page.dart
// DESAIN MEDICAL THEME - Minimalist dengan Animasi & Warna Medical

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../../providers/pasien_provider.dart';
import '../../../../../models/pasien_model.dart';
import 'pasien_form_page.dart';

class PasienDetailPage extends StatelessWidget {
  final PasienModel pasien;

  const PasienDetailPage({super.key, required this.pasien});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMMM yyyy', 'id_ID');

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, size: 22),
                      color: const Color(0xFF475569),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Detail Pasien',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F172A),
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Informasi lengkap pasien',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.edit, size: 22),
                      color: const Color(0xFF475569),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PasienFormPage(pasien: pasien),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEE2E2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.delete, size: 22),
                      color: const Color(0xFFDC2626),
                      onPressed: () {
                        _showDeleteDialog(context, pasien);
                      },
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Profile Header Card
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: pasien.jenisKelamin == 'L'
                              ? [const Color(0xFF0EA5E9), const Color(0xFF06B6D4)]
                              : [const Color(0xFFEC4899), const Color(0xFFF472B6)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: (pasien.jenisKelamin == 'L' ? const Color(0xFF0EA5E9) : const Color(0xFFEC4899)).withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Text(
                                pasien.nama.split(' ').map((e) => e[0]).take(2).join().toUpperCase(),
                                style: TextStyle(
                                  color: pasien.jenisKelamin == 'L' ? const Color(0xFF0EA5E9) : const Color(0xFFEC4899),
                                  fontSize: 32,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            pasien.nama,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              pasien.noRM,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildHeaderStat(Icons.cake, 'Usia', '${pasien.umur} tahun'),
                              Container(
                                height: 40,
                                width: 1,
                                color: Colors.white.withValues(alpha: 0.3),
                                margin: const EdgeInsets.symmetric(horizontal: 20),
                              ),
                              _buildHeaderStat(Icons.bloodtype, 'Gol. Darah', pasien.golonganDarah),
                              Container(
                                height: 40,
                                width: 1,
                                color: Colors.white.withValues(alpha: 0.3),
                                margin: const EdgeInsets.symmetric(horizontal: 20),
                              ),
                              _buildHeaderStat(Icons.health_and_safety, 'Asuransi', pasien.asuransi),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          _buildSectionCard('DATA IDENTITAS', Icons.badge, [
                            _buildInfoRow('NIK (KTP)', pasien.nik, canCopy: true),
                            _buildInfoRow('Nama Lengkap', pasien.nama),
                            _buildInfoRow('Jenis Kelamin', pasien.jenisKelamin == 'L' ? 'Laki-laki' : 'Perempuan'),
                            _buildInfoRow('Tempat, Tanggal Lahir', '${pasien.tempatLahir}, ${dateFormat.format(pasien.tanggalLahir)}'),
                            _buildInfoRow('Umur', '${pasien.umur} tahun'),
                            _buildInfoRow('Golongan Darah', pasien.golonganDarah),
                            _buildInfoRow('Status Perkawinan', pasien.statusPerkawinan),
                          ]),
                          _buildSectionCard('KONTAK', Icons.contact_phone, [
                            _buildInfoRow('Alamat', pasien.alamat),
                            _buildInfoRow('No. Telepon', pasien.noTelepon, canCopy: true),
                            if (pasien.email.isNotEmpty) _buildInfoRow('Email', pasien.email, canCopy: true),
                          ]),
                          if (pasien.pekerjaan.isNotEmpty)
                            _buildSectionCard('PEKERJAAN', Icons.work, [
                              _buildInfoRow('Pekerjaan', pasien.pekerjaan),
                            ]),
                          if (pasien.namaWali.isNotEmpty || pasien.noTeleponWali.isNotEmpty)
                            _buildSectionCard('WALI / KELUARGA', Icons.people, [
                              if (pasien.namaWali.isNotEmpty) _buildInfoRow('Nama Wali', pasien.namaWali),
                              if (pasien.noTeleponWali.isNotEmpty) _buildInfoRow('No. Telepon Wali', pasien.noTeleponWali, canCopy: true),
                            ]),
                          _buildSectionCard('ASURANSI', Icons.health_and_safety, [
                            _buildInfoRow('Jenis Asuransi', pasien.asuransi),
                            if (pasien.noAsuransi.isNotEmpty) _buildInfoRow('No. Asuransi/BPJS', pasien.noAsuransi, canCopy: true),
                          ]),
                          _buildSectionCard('METADATA', Icons.info, [
                            _buildInfoRow('Terdaftar', '${dateFormat.format(pasien.createdAt)}\n${DateFormat('HH:mm').format(pasien.createdAt)} WIB'),
                            if (pasien.updatedAt != null)
                              _buildInfoRow('Terakhir Diubah', '${dateFormat.format(pasien.updatedAt!)}\n${DateFormat('HH:mm').format(pasien.updatedAt!)} WIB'),
                            _buildInfoRow('Status', pasien.isActive ? 'Aktif' : 'Nonaktif',
                                valueColor: pasien.isActive ? const Color(0xFF10B981) : const Color(0xFFDC2626)),
                          ]),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PasienFormPage(pasien: pasien),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.edit, size: 20),
                                  label: const Text('EDIT DATA'),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    side: const BorderSide(color: Color(0xFF10B981)),
                                    foregroundColor: const Color(0xFF10B981),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    _showDeleteDialog(context, pasien);
                                  },
                                  icon: const Icon(Icons.delete, size: 20),
                                  label: const Text('HAPUS'),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    backgroundColor: const Color(0xFFDC2626),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    elevation: 0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderStat(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _buildSectionCard(String title, IconData icon, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: const Color(0xFF10B981), size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const Divider(height: 24, color: Color(0xFFE2E8F0)),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor, bool canCopy = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: valueColor ?? const Color(0xFF0F172A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (canCopy)
                IconButton(
                  icon: const Icon(Icons.copy, size: 18, color: Color(0xFF64748B)),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: value));
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: 'Salin',
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, PasienModel pasien) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(color: Color(0xFFFEE2E2), shape: BoxShape.circle),
                child: const Icon(Icons.delete_outline, color: Color(0xFFDC2626), size: 40),
              ),
              const SizedBox(height: 20),
              const Text('Hapus Pasien', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF0F172A), letterSpacing: -0.5)),
              const SizedBox(height: 12),
              Column(
                children: [
                  const Text('Apakah Anda yakin ingin menghapus data pasien berikut?', style: TextStyle(fontSize: 14, color: Color(0xFF64748B))),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(pasien.nama, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Color(0xFF0F172A))),
                        const SizedBox(height: 4),
                        Text('No. RM: ${pasien.noRM}', style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                        Text('NIK: ${pasien.nik}', style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('Data yang dihapus tidak dapat dikembalikan.', style: TextStyle(color: Color(0xFFDC2626), fontSize: 12, fontWeight: FontWeight.w500)),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Color(0xFFE2E8F0)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('BATAL', style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final provider = Provider.of<PasienProvider>(context, listen: false);
                        final success = await provider.deletePasien(pasien.id);
                        if (context.mounted) {
                          Navigator.pop(context);
                          if (success) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Data pasien berhasil dihapus'),
                                backgroundColor: const Color(0xFF10B981),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(provider.errorMessage ?? 'Gagal menghapus data'),
                                backgroundColor: const Color(0xFFDC2626),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: const Color(0xFFDC2626),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text('HAPUS', style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}