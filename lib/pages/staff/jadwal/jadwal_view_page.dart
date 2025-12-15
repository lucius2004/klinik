// lib/pages/staff/jadwal/jadwal_view_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/jadwal_provider.dart';
import '../../../models/jadwal_model.dart';

class JadwalViewPage extends StatefulWidget {
  const JadwalViewPage({super.key});

  @override
  State<JadwalViewPage> createState() => _JadwalViewPageState();
}

class _JadwalViewPageState extends State<JadwalViewPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _filterHari = 'Semua';
  String _filterSpesialisasi = 'Semua';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final jadwalProvider = Provider.of<JadwalProvider>(context);

    List<JadwalModel> filteredList = jadwalProvider.activeJadwalList;

    // Apply search
    if (_searchQuery.isNotEmpty) {
      filteredList = jadwalProvider.searchJadwal(_searchQuery);
    }

    // Apply filters
    if (_filterHari != 'Semua') {
      filteredList = filteredList.where((j) => j.hari == _filterHari).toList();
    }
    if (_filterSpesialisasi != 'Semua') {
      filteredList = filteredList
          .where((j) => j.spesialisasi == _filterSpesialisasi)
          .toList();
    }

    final statistics = jadwalProvider.getStatistics();
    final hariList = ['Semua', ...jadwalProvider.getHariList()];
    
    // Get unique spesialisasi from jadwal list
    final spesialisasiSet = <String>{};
    for (var jadwal in jadwalProvider.activeJadwalList) {
      spesialisasiSet.add(jadwal.spesialisasi);
    }
    final spesialisasiList = ['Semua', ...spesialisasiSet.toList()..sort()];

    return Scaffold(
      appBar: AppBar(
        title: const Text('JADWAL PRAKTIK DOKTER'),
        backgroundColor: const Color(0xFF2E7D32),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context, hariList, spesialisasiList),
          ),
        ],
      ),
      body: Column(
        children: [
          // Statistics Summary
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF2E7D32),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Jadwal Hari Ini',
                    statistics['hariIni'].toString(),
                    Icons.today,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Total Dokter',
                    statistics['totalDokter'].toString(),
                    Icons.person,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Ruangan',
                    statistics['totalRuangan'].toString(),
                    Icons.meeting_room,
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
                hintText: 'Cari dokter, hari, spesialisasi...',
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
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Filter Chips
          if (_filterHari != 'Semua' || _filterSpesialisasi != 'Semua')
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                children: [
                  if (_filterHari != 'Semua')
                    Chip(
                      label: Text(_filterHari),
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: () {
                        setState(() {
                          _filterHari = 'Semua';
                        });
                      },
                    ),
                  if (_filterSpesialisasi != 'Semua')
                    Chip(
                      label: Text(_filterSpesialisasi),
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: () {
                        setState(() {
                          _filterSpesialisasi = 'Semua';
                        });
                      },
                    ),
                ],
              ),
            ),

          const SizedBox(height: 8),

          // List
          Expanded(
            child: filteredList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Tidak ada jadwal praktik',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      await Future.delayed(const Duration(seconds: 1));
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final jadwal = filteredList[index];
                        return _buildJadwalCard(jadwal);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildJadwalCard(JadwalModel jadwal) {
    Color hariColor = _getHariColor(jadwal.hari);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showJadwalDetail(jadwal),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Hari Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: hariColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      jadwal.hari,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, size: 14, color: Colors.green),
                        SizedBox(width: 4),
                        Text(
                          'Aktif',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Dokter Info
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xFF2E7D32).withValues(alpha: 0.1),
                    child: const Icon(
                      Icons.person,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          jadwal.dokterNama,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          jadwal.spesialisasi,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.phone, color: Color(0xFF2E7D32)),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fitur telepon akan segera hadir'),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),

              // Details
              Row(
                children: [
                  Expanded(
                    child: _buildDetailItem(
                      Icons.access_time,
                      'Jam Praktik',
                      jadwal.waktuPraktik,
                    ),
                  ),
                  Expanded(
                    child: _buildDetailItem(
                      Icons.meeting_room,
                      'Ruangan',
                      jadwal.ruangan,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildDetailItem(
                Icons.people,
                'Kuota Pasien',
                '${jadwal.kuotaPasien} pasien',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getHariColor(String hari) {
    switch (hari) {
      case 'Senin':
        return Colors.blue;
      case 'Selasa':
        return Colors.green;
      case 'Rabu':
        return Colors.orange;
      case 'Kamis':
        return Colors.purple;
      case 'Jumat':
        return Colors.teal;
      case 'Sabtu':
        return Colors.pink;
      case 'Minggu':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showFilterDialog(
    BuildContext context,
    List<String> hariList,
    List<String> spesialisasiList,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Jadwal'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hari',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _filterHari,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: hariList.map((h) {
                  return DropdownMenuItem(value: h, child: Text(h));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _filterHari = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Spesialisasi',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _filterSpesialisasi,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: spesialisasiList.map((s) {
                  return DropdownMenuItem(value: s, child: Text(s));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _filterSpesialisasi = value!;
                  });
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _filterHari = 'Semua';
                _filterSpesialisasi = 'Semua';
              });
              Navigator.pop(context);
            },
            child: const Text('RESET'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
            ),
            child: const Text('TERAPKAN'),
          ),
        ],
      ),
    );
  }

  void _showJadwalDetail(JadwalModel jadwal) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detail Jadwal'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Dokter', jadwal.dokterNama),
              _buildDetailRow('Spesialisasi', jadwal.spesialisasi),
              _buildDetailRow('Hari', jadwal.hari),
              _buildDetailRow('Jam Praktik', jadwal.waktuPraktik),
              _buildDetailRow('Ruangan', jadwal.ruangan),
              _buildDetailRow('Kuota', '${jadwal.kuotaPasien} pasien'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('TUTUP'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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
    );
  }
}