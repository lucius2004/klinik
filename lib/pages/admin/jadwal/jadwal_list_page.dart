// lib/pages/admin/jadwal/jadwal_list_page.dart
// DESAIN MEDICAL THEME - Minimalist dengan Animasi & Warna Medical

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/jadwal_provider.dart';
import '../../../models/jadwal_model.dart';
import 'jadwal_form_page.dart';
import 'jadwal_detail_page.dart';

class JadwalListPage extends StatefulWidget {
  const JadwalListPage({super.key});

  @override
  State<JadwalListPage> createState() => _JadwalListPageState();
}

class _JadwalListPageState extends State<JadwalListPage> with TickerProviderStateMixin {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _filterHari = 'Semua';
  String _filterDokter = 'Semua';
  String _filterRuangan = 'Semua';
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final jadwalProvider = Provider.of<JadwalProvider>(context);
    List<JadwalModel> filteredList = jadwalProvider.activeJadwalList;

    if (_searchQuery.isNotEmpty) {
      filteredList = jadwalProvider.searchJadwal(_searchQuery);
    }
    if (_filterHari != 'Semua') {
      filteredList = filteredList.where((j) => j.hari == _filterHari).toList();
    }
    if (_filterDokter != 'Semua') {
      filteredList = filteredList.where((j) => j.dokterNama == _filterDokter).toList();
    }
    if (_filterRuangan != 'Semua') {
      filteredList = filteredList.where((j) => j.ruangan == _filterRuangan).toList();
    }

    final statistics = jadwalProvider.getStatistics();

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
                          'Jadwal Praktik',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F172A),
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Kelola jadwal praktik dokter',
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
                      icon: const Icon(Icons.filter_list, size: 22),
                      color: const Color(0xFF475569),
                      onPressed: () => _showFilterDialog(context, jadwalProvider),
                    ),
                  ),
                ],
              ),
            ),

            // Statistics
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0EA5E9), Color(0xFF06B6D4)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0EA5E9).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(child: _buildStatItem('Total', statistics['total'].toString(), Icons.schedule)),
                  Container(width: 1, height: 40, color: Colors.white.withValues(alpha: 0.3)),
                  Expanded(child: _buildStatItem('Dokter', statistics['totalDokter'].toString(), Icons.people)),
                  Container(width: 1, height: 40, color: Colors.white.withValues(alpha: 0.3)),
                  Expanded(child: _buildStatItem('Ruangan', statistics['totalRuangan'].toString(), Icons.meeting_room)),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Cari dokter, hari, ruangan...',
                    hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF64748B), size: 22),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 20, color: Color(0xFF64748B)),
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
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  onChanged: (value) => setState(() => _searchQuery = value),
                ),
              ),
            ),

            // Filter Chips
            if (_filterHari != 'Semua' || _filterDokter != 'Semua' || _filterRuangan != 'Semua')
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Wrap(
                  spacing: 8,
                  children: [
                    if (_filterHari != 'Semua')
                      Chip(
                        label: Text(_filterHari),
                        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF0EA5E9)),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        deleteIconColor: const Color(0xFF0EA5E9),
                        backgroundColor: const Color(0xFF0EA5E9).withValues(alpha: 0.1),
                        side: BorderSide.none,
                        onDeleted: () => setState(() => _filterHari = 'Semua'),
                      ),
                    if (_filterDokter != 'Semua')
                      Chip(
                        label: Text(_filterDokter),
                        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF8B5CF6)),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        deleteIconColor: const Color(0xFF8B5CF6),
                        backgroundColor: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                        side: BorderSide.none,
                        onDeleted: () => setState(() => _filterDokter = 'Semua'),
                      ),
                    if (_filterRuangan != 'Semua')
                      Chip(
                        label: Text(_filterRuangan),
                        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFF59E0B)),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        deleteIconColor: const Color(0xFFF59E0B),
                        backgroundColor: const Color(0xFFF59E0B).withValues(alpha: 0.1),
                        side: BorderSide.none,
                        onDeleted: () => setState(() => _filterRuangan = 'Semua'),
                      ),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            // List
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: filteredList.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final jadwal = filteredList[index];
                          return TweenAnimationBuilder<double>(
                            duration: Duration(milliseconds: 300 + (index * 50)),
                            tween: Tween(begin: 0.0, end: 1.0),
                            builder: (context, value, child) {
                              return Opacity(
                                opacity: value,
                                child: Transform.translate(
                                  offset: Offset(0, 20 * (1 - value)),
                                  child: child,
                                ),
                              );
                            },
                            child: _buildJadwalCard(context, jadwal, jadwalProvider),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const JadwalFormPage()));
        },
        backgroundColor: const Color(0xFF0EA5E9),
        elevation: 4,
        child: const Icon(Icons.add, size: 28, color: Colors.white),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: -1)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF0EA5E9).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.calendar_today_outlined, size: 64, color: Color(0xFF0EA5E9)),
          ),
          const SizedBox(height: 20),
          const Text('Tidak ada jadwal praktik', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF475569))),
          const SizedBox(height: 8),
          const Text('Tambahkan jadwal baru untuk memulai', style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8))),
        ],
      ),
    );
  }

  Widget _buildJadwalCard(BuildContext context, JadwalModel jadwal, JadwalProvider provider) {
    final hariColor = _getHariColor(jadwal.hari);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => JadwalDetailPage(jadwalId: jadwal.id)));
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: hariColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        jadwal.hari,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12, letterSpacing: 0.3),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: jadwal.isActive
                            ? const Color(0xFF10B981).withValues(alpha: 0.1)
                            : const Color(0xFFDC2626).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        jadwal.isActive ? 'Aktif' : 'Nonaktif',
                        style: TextStyle(
                          color: jadwal.isActive ? const Color(0xFF10B981) : const Color(0xFFDC2626),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
                      child: PopupMenuButton(
                        icon: const Icon(Icons.more_vert, size: 20, color: Color(0xFF475569)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'detail',
                            child: Row(children: [Icon(Icons.info_outline, size: 20, color: Color(0xFF0EA5E9)), SizedBox(width: 12), Text('Detail', style: TextStyle(fontSize: 14))]),
                          ),
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(children: [Icon(Icons.edit_outlined, size: 20, color: Color(0xFF8B5CF6)), SizedBox(width: 12), Text('Edit', style: TextStyle(fontSize: 14))]),
                          ),
                          PopupMenuItem(
                            value: 'toggle',
                            child: Row(children: [
                              Icon(jadwal.isActive ? Icons.toggle_off_outlined : Icons.toggle_on_outlined, size: 20, color: Color(0xFFF59E0B)),
                              const SizedBox(width: 12),
                              Text(jadwal.isActive ? 'Nonaktifkan' : 'Aktifkan', style: const TextStyle(fontSize: 14))
                            ]),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(children: [Icon(Icons.delete_outline, size: 20, color: Color(0xFFDC2626)), SizedBox(width: 12), Text('Hapus', style: TextStyle(fontSize: 14, color: Color(0xFFDC2626)))]),
                          ),
                        ],
                        onSelected: (value) {
                          if (value == 'detail') {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => JadwalDetailPage(jadwalId: jadwal.id)));
                          } else if (value == 'edit') {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => JadwalFormPage(jadwal: jadwal)));
                          } else if (value == 'toggle') {
                            _toggleStatus(context, jadwal, provider);
                          } else if (value == 'delete') {
                            _showDeleteDialog(context, jadwal, provider);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0EA5E9).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.person, size: 28, color: Color(0xFF0EA5E9)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(jadwal.dokterNama, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF0F172A), letterSpacing: -0.3)),
                          const SizedBox(height: 4),
                          Text(jadwal.spesialisasi, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24, color: Color(0xFFE2E8F0)),
                Row(
                  children: [
                    Expanded(child: _buildDetailItem(Icons.access_time, jadwal.waktuPraktik)),
                    Expanded(child: _buildDetailItem(Icons.meeting_room, jadwal.ruangan)),
                  ],
                ),
                const SizedBox(height: 8),
                _buildDetailItem(Icons.people, 'Kuota: ${jadwal.kuotaPasien} pasien'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF94A3B8)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(text, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }

  Color _getHariColor(String hari) {
    switch (hari) {
      case 'Senin':
        return const Color(0xFF3B82F6);
      case 'Selasa':
        return const Color(0xFF10B981);
      case 'Rabu':
        return const Color(0xFFF59E0B);
      case 'Kamis':
        return const Color(0xFF8B5CF6);
      case 'Jumat':
        return const Color(0xFF06B6D4);
      case 'Sabtu':
        return const Color(0xFFEC4899);
      case 'Minggu':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF64748B);
    }
  }

  void _showFilterDialog(BuildContext context, JadwalProvider provider) {
    final hariList = ['Semua', ...provider.getHariList()];
    final dokterList = ['Semua', ...provider.getDokterList()];
    final ruanganList = ['Semua', ...provider.getRuanganList()];

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: const Color(0xFF0EA5E9).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.filter_list, color: Color(0xFF0EA5E9), size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Text('Filter Data', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF0F172A), letterSpacing: -0.5)),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Hari Praktik', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF475569))),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _filterHari,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                ),
                items: hariList.map((h) => DropdownMenuItem(value: h, child: Text(h))).toList(),
                onChanged: (value) => setState(() => _filterHari = value!),
              ),
              const SizedBox(height: 16),
              const Text('Dokter', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF475569))),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _filterDokter,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                ),
                items: dokterList.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                onChanged: (value) => setState(() => _filterDokter = value!),
              ),
              const SizedBox(height: 16),
              const Text('Ruangan', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF475569))),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _filterRuangan,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                ),
                items: ruanganList.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                onChanged: (value) => setState(() => _filterRuangan = value!),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _filterHari = 'Semua';
                          _filterDokter = 'Semua';
                          _filterRuangan = 'Semua';
                        });
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Color(0xFFE2E8F0)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('RESET', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: const Color(0xFF0EA5E9),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text('TERAPKAN', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
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

  void _toggleStatus(BuildContext context, JadwalModel jadwal, JadwalProvider provider) async {
    final success = await provider.toggleStatus(jadwal.id);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Status jadwal berhasil diubah' : 'Gagal mengubah status'),
          backgroundColor: success ? const Color(0xFF10B981) : const Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _showDeleteDialog(BuildContext context, JadwalModel jadwal, JadwalProvider provider) {
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
                child: const Icon(Icons.delete_outline, color: Color(0xFFDC2626), size: 32),
              ),
              const SizedBox(height: 20),
              const Text('Hapus Jadwal', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF0F172A), letterSpacing: -0.5)),
              const SizedBox(height: 12),
              Column(
                children: [
                  const Text('Apakah Anda yakin ingin menghapus jadwal berikut?', style: TextStyle(fontSize: 14, color: Color(0xFF64748B)), textAlign: TextAlign.center),
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
                        Text(jadwal.dokterNama, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Color(0xFF0F172A))),
                        const SizedBox(height: 4),
                        Text('${jadwal.hari}, ${jadwal.waktuPraktik}', style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                        Text('Ruangan: ${jadwal.ruangan}', style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
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
                        final success = await provider.deleteJadwal(jadwal.id);
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(success ? 'Jadwal berhasil dihapus' : 'Gagal menghapus jadwal'),
                              backgroundColor: success ? const Color(0xFF10B981) : const Color(0xFFDC2626),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          );
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