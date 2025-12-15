// lib/pages/staff/antrean/antrean_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/pendaftaran_provider.dart';
import '../../../models/pendaftaran_model.dart';

class AntreanPage extends StatefulWidget {
  const AntreanPage({super.key});

  @override
  State<AntreanPage> createState() => _AntreanPageState();
}

class _AntreanPageState extends State<AntreanPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pendaftaranProvider = Provider.of<PendaftaranProvider>(context);
    final stats = pendaftaranProvider.getStatistics();

    return Scaffold(
      appBar: AppBar(
        title: const Text('KELOLA ANTREAN'),
        backgroundColor: const Color(0xFF2E7D32),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: [
            Tab(
              text: 'Semua\n(${stats['total']})',
            ),
            Tab(
              text: 'Menunggu\n(${stats['menunggu']})',
            ),
            Tab(
              text: 'Dipanggil\n(${stats['dipanggil']})',
            ),
            Tab(
              text: 'Selesai\n(${stats['selesai']})',
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Statistics Summary
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Row(
              children: [
                Expanded(
                  child: _buildQuickStat(
                    'Total Hari Ini',
                    stats['total'].toString(),
                    Icons.people,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildQuickStat(
                    'Menunggu',
                    stats['menunggu'].toString(),
                    Icons.schedule,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildQuickStat(
                    'Selesai',
                    stats['selesai'].toString(),
                    Icons.check_circle,
                    Colors.green,
                  ),
                ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari pasien, dokter, no. RM...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAntreanList(pendaftaranProvider.pendaftaranHariIni),
                _buildAntreanList(
                    pendaftaranProvider.getPendaftaranByStatus('menunggu')),
                _buildAntreanList(
                    pendaftaranProvider.getPendaftaranByStatus('dipanggil')),
                _buildAntreanList(
                    pendaftaranProvider.getPendaftaranByStatus('selesai')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAntreanList(List<PendaftaranModel> list) {
    List<PendaftaranModel> filteredList = list;

    // Apply search
    if (_searchQuery.isNotEmpty) {
      final lowerQuery = _searchQuery.toLowerCase();
      filteredList = list.where((p) {
        return p.pasienNama.toLowerCase().contains(lowerQuery) ||
            p.pasienNoRm.toLowerCase().contains(lowerQuery) ||
            p.dokterNama.toLowerCase().contains(lowerQuery) ||
            p.noPendaftaran.toLowerCase().contains(lowerQuery);
      }).toList();
    }

    if (filteredList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Tidak ada data antrean',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredList.length,
        itemBuilder: (context, index) {
          final pendaftaran = filteredList[index];
          return _buildAntreanCard(pendaftaran);
        },
      ),
    );
  }

  Widget _buildAntreanCard(PendaftaranModel pendaftaran) {
    Color statusColor = _getStatusColor(pendaftaran.status);
    IconData statusIcon = _getStatusIcon(pendaftaran.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // No Antrean Badge
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'NO',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        pendaftaran.noAntrean.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pendaftaran.pasienNama,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'RM: ${pendaftaran.pasienNoRm}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        pendaftaran.noPendaftaran,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 16, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        _getStatusText(pendaftaran.status),
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            _buildInfoRow(
                Icons.local_hospital, 'Dokter', pendaftaran.dokterNama),
            const SizedBox(height: 4),
            _buildInfoRow(
                Icons.medical_services, 'Layanan', pendaftaran.layananNama),
            const SizedBox(height: 4),
            _buildInfoRow(Icons.access_time, 'Jam', pendaftaran.jamDaftar),
            const SizedBox(height: 4),
            _buildInfoRow(Icons.notes, 'Keluhan', pendaftaran.keluhan),
            const SizedBox(height: 12),

            // Action Buttons
            Row(
              children: [
                if (pendaftaran.status == 'menunggu')
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          _updateStatus(pendaftaran.id, 'dipanggil'),
                      icon: const Icon(Icons.notifications_active),
                      label: const Text('PANGGIL'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.orange,
                      ),
                    ),
                  ),
                if (pendaftaran.status == 'menunggu')
                  const SizedBox(width: 8),
                if (pendaftaran.status == 'dipanggil')
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _updateStatus(pendaftaran.id, 'selesai'),
                      icon: const Icon(Icons.check_circle),
                      label: const Text('SELESAI'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                if (pendaftaran.status == 'dipanggil')
                  const SizedBox(width: 8),
                if (pendaftaran.status != 'selesai' &&
                    pendaftaran.status != 'batal')
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showCancelDialog(pendaftaran.id),
                      icon: const Icon(Icons.cancel),
                      label: const Text('BATAL'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                    ),
                  ),
                if (pendaftaran.status == 'selesai')
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Navigate to detail or invoice
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Buat invoice atau lihat detail'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.receipt_long),
                      label: const Text('BUAT INVOICE'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'menunggu':
        return Colors.orange;
      case 'dipanggil':
        return Colors.blue;
      case 'selesai':
        return Colors.green;
      case 'batal':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'menunggu':
        return Icons.schedule;
      case 'dipanggil':
        return Icons.notifications_active;
      case 'selesai':
        return Icons.check_circle;
      case 'batal':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'menunggu':
        return 'Menunggu';
      case 'dipanggil':
        return 'Dipanggil';
      case 'selesai':
        return 'Selesai';
      case 'batal':
        return 'Batal';
      default:
        return status;
    }
  }

  void _updateStatus(String id, String newStatus) async {
    final pendaftaranProvider =
        Provider.of<PendaftaranProvider>(context, listen: false);

    final success = await pendaftaranProvider.updateStatus(id, newStatus);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Status berhasil diubah'
                : 'Gagal mengubah status',
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }

  void _showCancelDialog(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Batalkan Pendaftaran'),
        content: const Text(
          'Apakah Anda yakin ingin membatalkan pendaftaran ini?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('TIDAK'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _updateStatus(id, 'batal');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('YA, BATALKAN'),
          ),
        ],
      ),
    );
  }
}