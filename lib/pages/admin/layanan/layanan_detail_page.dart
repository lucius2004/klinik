// lib/pages/admin/layanan/layanan_detail_page.dart
// DESAIN MEDICAL THEME - Minimalist dengan Animasi & Warna Medical

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../providers/layanan_provider.dart';
import '../../../models/layanan_model.dart';
import 'layanan_form_page.dart';

class LayananDetailPage extends StatelessWidget {
  final String layananId;

  const LayananDetailPage({super.key, required this.layananId});

  @override
  Widget build(BuildContext context) {
    final layananProvider = Provider.of<LayananProvider>(context);
    final layanan = layananProvider.getLayananById(layananId);

    if (layanan == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: const Center(child: Text('Data tidak ditemukan')),
      );
    }

    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final dateFormat = DateFormat('dd MMMM yyyy', 'id_ID');
    final kategoriData = _getKategoriData(layanan.kategori);

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
                          'Detail Layanan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F172A),
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Informasi lengkap layanan',
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
                            builder: (context) => LayananFormPage(layanan: layanan),
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
                        _showDeleteDialog(context, layanan, layananProvider);
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
                          colors: [kategoriData['color'], kategoriData['color'].withValues(alpha: 0.8)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: kategoriData['color'].withValues(alpha: 0.3),
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
                            child: Icon(kategoriData['icon'], size: 48, color: kategoriData['color']),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            layanan.nama,
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
                              layanan.kategori,
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
                              _buildHeaderStat(Icons.code, 'Kode', layanan.kode),
                              Container(
                                height: 40,
                                width: 1,
                                color: Colors.white.withValues(alpha: 0.3),
                                margin: const EdgeInsets.symmetric(horizontal: 20),
                              ),
                              _buildHeaderStat(Icons.access_time, 'Durasi', layanan.durasi),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              currencyFormat.format(layanan.tarif),
                              style: TextStyle(
                                color: kategoriData['color'],
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          _buildSectionCard('INFORMASI LAYANAN', Icons.info, [
                            _buildInfoRow('Kode Layanan', layanan.kode),
                            _buildInfoRow('Nama Layanan', layanan.nama),
                            _buildInfoRow('Kategori', layanan.kategori),
                            _buildInfoRow('Unit Pelayanan', layanan.unitPelayanan),
                            if (layanan.deskripsi.isNotEmpty)
                              _buildInfoRow('Deskripsi', layanan.deskripsi),
                          ]),

                          _buildSectionCard('TARIF & DURASI', Icons.payments, [
                            _buildInfoRow(
                              'Tarif Layanan',
                              currencyFormat.format(layanan.tarif),
                              valueColor: const Color(0xFF10B981),
                            ),
                            _buildInfoRow('Durasi', layanan.durasi),
                          ]),

                          _buildSectionCard('KEBUTUHAN SUMBER DAYA', Icons.people, [
                            _buildCheckRow('Membutuhkan Dokter', layanan.membutuhkanDokter, Icons.person, const Color(0xFF0EA5E9)),
                            _buildCheckRow('Membutuhkan Perawat', layanan.membutuhkanPerawat, Icons.healing, const Color(0xFF3B82F6)),
                            _buildCheckRow('Membutuhkan Alat Khusus', layanan.membutuhkanAlat, Icons.build, const Color(0xFFF59E0B)),
                            if (layanan.membutuhkanAlat && layanan.keteranganAlat.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: const Color(0xFFE2E8F0)),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: const Icon(Icons.build_circle, size: 16, color: Color(0xFFF59E0B)),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text('Keterangan Alat', style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                                            const SizedBox(height: 2),
                                            Text(layanan.keteranganAlat, style: const TextStyle(fontSize: 13, color: Color(0xFF0F172A), fontWeight: FontWeight.w600)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ]),

                          _buildSectionCard('METADATA', Icons.info, [
                            _buildInfoRow(
                              'Dibuat',
                              '${dateFormat.format(layanan.createdAt)}\n${DateFormat('HH:mm').format(layanan.createdAt)} WIB',
                            ),
                            if (layanan.updatedAt != null)
                              _buildInfoRow(
                                'Terakhir Diubah',
                                '${dateFormat.format(layanan.updatedAt!)}\n${DateFormat('HH:mm').format(layanan.updatedAt!)} WIB',
                              ),
                            _buildInfoRow(
                              'Status',
                              layanan.isActive ? 'Aktif' : 'Nonaktif',
                              valueColor: layanan.isActive ? const Color(0xFF10B981) : const Color(0xFFDC2626),
                            ),
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
                                        builder: (context) => LayananFormPage(layanan: layanan),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.edit, size: 20),
                                  label: const Text('EDIT DATA'),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    side: const BorderSide(color: Color(0xFF0EA5E9)),
                                    foregroundColor: const Color(0xFF0EA5E9),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    _showDeleteDialog(context, layanan, layananProvider);
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
                  color: const Color(0xFF0EA5E9).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: const Color(0xFF0EA5E9), size: 20),
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

  Widget _buildCheckRow(String label, bool value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: value ? color.withValues(alpha: 0.1) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: value ? color : const Color(0xFF94A3B8)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF0F172A),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: value ? const Color(0xFF10B981).withValues(alpha: 0.1) : const Color(0xFFDC2626).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              value ? Icons.check_circle : Icons.cancel,
              color: value ? const Color(0xFF10B981) : const Color(0xFFDC2626),
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getKategoriData(String kategori) {
    switch (kategori) {
      case 'Pemeriksaan':
        return {'color': const Color(0xFF3B82F6), 'icon': Icons.medical_services};
      case 'Tindakan':
        return {'color': const Color(0xFFF59E0B), 'icon': Icons.healing};
      case 'Laboratorium':
        return {'color': const Color(0xFF8B5CF6), 'icon': Icons.science};
      case 'Radiologi':
        return {'color': const Color(0xFF06B6D4), 'icon': Icons.camera_alt};
      default:
        return {'color': const Color(0xFF64748B), 'icon': Icons.local_hospital};
    }
  }

  void _showDeleteDialog(BuildContext context, LayananModel layanan, LayananProvider provider) {
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
              const Text('Hapus Layanan', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF0F172A), letterSpacing: -0.5)),
              const SizedBox(height: 12),
              Column(
                children: [
                  const Text('Apakah Anda yakin ingin menghapus layanan berikut?', style: TextStyle(fontSize: 14, color: Color(0xFF64748B)), textAlign: TextAlign.center),
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
                        Text(layanan.nama, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Color(0xFF0F172A))),
                        const SizedBox(height: 4),
                        Text('Kode: ${layanan.kode}', style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                        Text('Kategori: ${layanan.kategori}', style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
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
                        final success = await provider.deleteLayanan(layanan.id);
                        if (context.mounted) {
                          Navigator.pop(context);
                          if (success) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Data layanan berhasil dihapus'),
                                backgroundColor: Color(0xFF10B981),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(provider.errorMessage ?? 'Gagal menghapus data'),
                                backgroundColor: const Color(0xFFDC2626),
                                behavior: SnackBarBehavior.floating,
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