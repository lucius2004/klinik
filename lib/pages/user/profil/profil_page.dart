// lib/pages/user/profil/profil_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/pasien_provider.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final pasienProvider = Provider.of<PasienProvider>(context);
    final user = authProvider.currentUser;
    
    // Get pasien data berdasarkan user ID
    final pasien = pasienProvider.getPasienById(user?.id ?? '');

    return Scaffold(
      appBar: AppBar(
        title: const Text('PROFIL SAYA'),
        backgroundColor: const Color(0xFF2E7D32),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fitur edit profil akan segera hadir'),
                ),
              );
            },
          ),
        ],
      ),
      body: pasien == null
          ? const Center(
              child: Text('Data pasien tidak ditemukan'),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          child: Text(
                            pasien.nama.substring(0, 1).toUpperCase(),
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          pasien.nama,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'No. RM: ${pasien.noRM}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Data Pribadi
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Data Pribadi'),
                        const SizedBox(height: 12),
                        _buildInfoCard([
                          _buildInfoRow('NIK', pasien.nik, Icons.badge),
                          _buildInfoRow('Tempat Lahir', pasien.tempatLahir,
                              Icons.location_city),
                          _buildInfoRow(
                            'Tanggal Lahir',
                            DateFormat('dd MMMM yyyy', 'id_ID')
                                .format(pasien.tanggalLahir),
                            Icons.cake,
                          ),
                          _buildInfoRow('Umur', '${pasien.umur} tahun',
                              Icons.calendar_today),
                          _buildInfoRow('Jenis Kelamin', pasien.jenisKelamin,
                              Icons.wc),
                          _buildInfoRow('Golongan Darah',
                              pasien.golonganDarah, Icons.bloodtype),
                          _buildInfoRow('Status Perkawinan',
                              pasien.statusPerkawinan, Icons.family_restroom),
                          _buildInfoRow(
                              'Pekerjaan', pasien.pekerjaan, Icons.work),
                        ]),
                        const SizedBox(height: 24),

                        // Kontak
                        _buildSectionTitle('Kontak'),
                        const SizedBox(height: 12),
                        _buildInfoCard([
                          _buildInfoRow(
                              'No. Telepon', pasien.noTelepon, Icons.phone),
                          _buildInfoRow('Email', pasien.email, Icons.email),
                          _buildInfoRow(
                              'Alamat', pasien.alamat, Icons.home),
                        ]),
                        const SizedBox(height: 24),

                        // Kontak Darurat
                        if (pasien.namaWali.isNotEmpty) ...[
                          _buildSectionTitle('Kontak Darurat'),
                          const SizedBox(height: 12),
                          _buildInfoCard([
                            _buildInfoRow('Nama Wali', pasien.namaWali,
                                Icons.person_outline),
                            _buildInfoRow('No. Telepon Wali',
                                pasien.noTeleponWali, Icons.phone_in_talk),
                          ]),
                          const SizedBox(height: 24),
                        ],

                        // Asuransi
                        _buildSectionTitle('Asuransi & Pembayaran'),
                        const SizedBox(height: 12),
                        _buildInfoCard([
                          _buildInfoRow('Jenis Asuransi', pasien.asuransi,
                              Icons.card_membership),
                          if (pasien.noAsuransi.isNotEmpty)
                            _buildInfoRow('No. Asuransi', pasien.noAsuransi,
                                Icons.credit_card),
                        ]),
                        const SizedBox(height: 24),

                        // Status
                        _buildSectionTitle('Informasi Akun'),
                        const SizedBox(height: 12),
                        _buildInfoCard([
                          _buildInfoRow(
                            'Status',
                            pasien.isActive ? 'Aktif' : 'Nonaktif',
                            Icons.verified_user,
                          ),
                          _buildInfoRow(
                            'Terdaftar Sejak',
                            DateFormat('dd MMMM yyyy', 'id_ID')
                                .format(pasien.createdAt),
                            Icons.event,
                          ),
                        ]),
                        const SizedBox(height: 32),

                        // Action Buttons
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Fitur edit profil akan segera hadir'),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit),
                            label: const Text('EDIT PROFIL'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF2E7D32),
                              side: const BorderSide(
                                color: Color(0xFF2E7D32),
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Fitur ganti password akan segera hadir'),
                                ),
                              );
                            },
                            icon: const Icon(Icons.lock),
                            label: const Text('GANTI PASSWORD'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.grey[700],
                              side: BorderSide(color: Colors.grey[400]!),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2E7D32),
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}