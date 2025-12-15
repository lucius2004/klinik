// lib/pages/admin/staff/staff_detail_page.dart
// DESAIN MEDICAL THEME - Minimalist dengan Animasi & Warna Medical

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../providers/staff_provider.dart';
import '../../../models/staff_model.dart';
import 'staff_form_page.dart';

class StaffDetailPage extends StatelessWidget {
  final String staffId;

  const StaffDetailPage({super.key, required this.staffId});

  @override
  Widget build(BuildContext context) {
    final staffProvider = Provider.of<StaffProvider>(context);
    final staff = staffProvider.getStaffById(staffId);

    if (staff == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: const Center(child: Text('Data tidak ditemukan')),
      );
    }

    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final dateFormat = DateFormat('dd MMMM yyyy', 'id_ID');

    Color posisiColor;
    IconData posisiIcon;

    switch (staff.posisi) {
      case 'Perawat':
        posisiColor = const Color(0xFF0EA5E9);
        posisiIcon = Icons.medical_services;
        break;
      case 'Administrasi':
        posisiColor = const Color(0xFF8B5CF6);
        posisiIcon = Icons.admin_panel_settings;
        break;
      case 'Apoteker':
        posisiColor = const Color(0xFF10B981);
        posisiIcon = Icons.medication;
        break;
      case 'Laboratorium':
        posisiColor = const Color(0xFF06B6D4);
        posisiIcon = Icons.science;
        break;
      case 'Kasir':
        posisiColor = const Color(0xFFF97316);
        posisiIcon = Icons.payments;
        break;
      default:
        posisiColor = const Color(0xFF64748B);
        posisiIcon = Icons.work;
    }

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
                          'Detail Staff',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F172A),
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Informasi lengkap staff',
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
                            builder: (context) => StaffFormPage(staff: staff),
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
                        _showDeleteDialog(context, staff, staffProvider);
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
                          colors: [posisiColor, posisiColor.withValues(alpha: 0.8)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: posisiColor.withValues(alpha: 0.3),
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
                            child: Icon(posisiIcon, size: 48, color: posisiColor),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            staff.nama,
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
                              staff.posisi,
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
                              _buildHeaderStat(Icons.badge, 'NIP', staff.nip),
                              Container(
                                height: 40,
                                width: 1,
                                color: Colors.white.withValues(alpha: 0.3),
                                margin: const EdgeInsets.symmetric(horizontal: 20),
                              ),
                              _buildHeaderStat(Icons.access_time, 'Shift', staff.shift),
                              Container(
                                height: 40,
                                width: 1,
                                color: Colors.white.withValues(alpha: 0.3),
                                margin: const EdgeInsets.symmetric(horizontal: 20),
                              ),
                              _buildHeaderStat(Icons.work_history, 'Pengalaman', '${staff.lamaBekerja} tahun'),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          _buildSectionCard('INFORMASI PRIBADI', Icons.person, [
                            _buildInfoRow('Jenis Kelamin', staff.jenisKelamin == 'L' ? 'Laki-laki' : 'Perempuan'),
                            _buildInfoRow('Tempat, Tanggal Lahir', '${staff.tempatLahir}, ${dateFormat.format(staff.tanggalLahir)}'),
                            _buildInfoRow('Usia', '${staff.umur} tahun'),
                            _buildInfoRow('Pendidikan', staff.pendidikan),
                          ]),
                          _buildSectionCard('KONTAK', Icons.contact_phone, [
                            _buildInfoRow('Alamat', staff.alamat),
                            _buildInfoRow('No. Telepon', staff.noTelepon),
                            if (staff.email.isNotEmpty) _buildInfoRow('Email', staff.email),
                          ]),
                          if (staff.kontakDarurat.isNotEmpty || staff.noKontakDarurat.isNotEmpty)
                            _buildSectionCard('KONTAK DARURAT', Icons.contact_emergency, [
                              if (staff.kontakDarurat.isNotEmpty) _buildInfoRow('Nama Kontak', staff.kontakDarurat),
                              if (staff.noKontakDarurat.isNotEmpty) _buildInfoRow('No. Telepon Darurat', staff.noKontakDarurat),
                            ]),
                          _buildSectionCard('INFORMASI PEKERJAAN', Icons.work, [
                            _buildInfoRow('Posisi', staff.posisi),
                            _buildInfoRow('Shift Kerja', staff.shift),
                            _buildInfoRow('Tanggal Bergabung', dateFormat.format(staff.tanggalBergabung)),
                            _buildInfoRow('Lama Bekerja', '${staff.lamaBekerja} tahun'),
                          ]),
                          _buildSectionCard('GAJI & REKENING', Icons.payments, [
                            _buildInfoRow('Gaji Pokok', currencyFormat.format(staff.gaji), valueColor: const Color(0xFF10B981)),
                            if (staff.namaBank.isNotEmpty) _buildInfoRow('Nama Bank', staff.namaBank),
                            if (staff.noRekening.isNotEmpty) _buildInfoRow('No. Rekening', staff.noRekening),
                          ]),
                          _buildSectionCard('METADATA', Icons.info, [
                            _buildInfoRow('Dibuat', '${dateFormat.format(staff.createdAt)}\n${DateFormat('HH:mm').format(staff.createdAt)} WIB'),
                            if (staff.updatedAt != null)
                              _buildInfoRow('Terakhir Diubah', '${dateFormat.format(staff.updatedAt!)}\n${DateFormat('HH:mm').format(staff.updatedAt!)} WIB'),
                            _buildInfoRow('Status', staff.isActive ? 'Aktif' : 'Nonaktif',
                                valueColor: staff.isActive ? const Color(0xFF10B981) : const Color(0xFFDC2626)),
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
                                        builder: (context) => StaffFormPage(staff: staff),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.edit, size: 20),
                                  label: const Text('EDIT DATA'),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    side: const BorderSide(color: Color(0xFFF97316)),
                                    foregroundColor: const Color(0xFFF97316),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    _showDeleteDialog(context, staff, staffProvider);
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
                  color: const Color(0xFFF97316).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: const Color(0xFFF97316), size: 20),
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

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
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
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: valueColor ?? const Color(0xFF0F172A),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, StaffModel staff, StaffProvider provider) {
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
              const Text('Hapus Staff', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF0F172A), letterSpacing: -0.5)),
              const SizedBox(height: 12),
              Column(
                children: [
                  const Text('Apakah Anda yakin ingin menghapus data staff berikut?', style: TextStyle(fontSize: 14, color: Color(0xFF64748B))),
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
                        Text(staff.nama, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Color(0xFF0F172A))),
                        const SizedBox(height: 4),
                        Text('NIP: ${staff.nip}', style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                        Text('Posisi: ${staff.posisi}', style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
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
                        final success = await provider.deleteStaff(staff.id);
                        if (context.mounted) {
                          Navigator.pop(context);
                          if (success) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Data staff berhasil dihapus'),
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