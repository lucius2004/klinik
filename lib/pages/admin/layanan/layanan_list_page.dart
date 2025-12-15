// lib/pages/admin/layanan/layanan_list_page.dart
// DESAIN MEDICAL THEME - Minimalist dengan Animasi & Warna Medical

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/layanan_provider.dart';
import '../../../models/layanan_model.dart';
import 'layanan_form_page.dart';
import 'layanan_detail_page.dart';
import 'package:intl/intl.dart';

class LayananListPage extends StatefulWidget {
  const LayananListPage({super.key});

  @override
  State<LayananListPage> createState() => _LayananListPageState();
}

class _LayananListPageState extends State<LayananListPage> with TickerProviderStateMixin {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _filterKategori = 'Semua';
  String _filterUnit = 'Semua';
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
    final layananProvider = Provider.of<LayananProvider>(context);
    List<LayananModel> filteredList = layananProvider.activeLayananList;

    if (_searchQuery.isNotEmpty) {
      filteredList = layananProvider.searchLayanan(_searchQuery);
    }
    if (_filterKategori != 'Semua') {
      filteredList = filteredList.where((l) => l.kategori == _filterKategori).toList();
    }
    if (_filterUnit != 'Semua') {
      filteredList = filteredList.where((l) => l.unitPelayanan == _filterUnit).toList();
    }

    final statistics = layananProvider.getStatistics();
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

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
                          'Data Layanan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F172A),
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Kelola layanan medis',
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
                      onPressed: () => _showFilterDialog(context, layananProvider),
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
                  Expanded(child: _buildStatItem('Total', statistics['total'].toString(), Icons.medical_services)),
                  Container(width: 1, height: 40, color: Colors.white.withValues(alpha: 0.3)),
                  Expanded(child: _buildStatItem('Kategori', statistics['kategori'].length.toString(), Icons.category)),
                  Container(width: 1, height: 40, color: Colors.white.withValues(alpha: 0.3)),
                  Expanded(child: _buildStatItem('Rata² Tarif', currencyFormat.format(statistics['rataRataTarif']), Icons.payments)),
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
                    hintText: 'Cari nama, kode, kategori...',
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
            if (_filterKategori != 'Semua' || _filterUnit != 'Semua')
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Wrap(
                  spacing: 8,
                  children: [
                    if (_filterKategori != 'Semua')
                      Chip(
                        label: Text(_filterKategori),
                        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF0EA5E9)),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        deleteIconColor: const Color(0xFF0EA5E9),
                        backgroundColor: const Color(0xFF0EA5E9).withValues(alpha: 0.1),
                        side: BorderSide.none,
                        onDeleted: () => setState(() => _filterKategori = 'Semua'),
                      ),
                    if (_filterUnit != 'Semua')
                      Chip(
                        label: Text(_filterUnit),
                        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF8B5CF6)),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        deleteIconColor: const Color(0xFF8B5CF6),
                        backgroundColor: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                        side: BorderSide.none,
                        onDeleted: () => setState(() => _filterUnit = 'Semua'),
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
                          final layanan = filteredList[index];
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
                            child: _buildLayananCard(context, layanan, layananProvider, currencyFormat),
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
          Navigator.push(context, MaterialPageRoute(builder: (context) => const LayananFormPage()));
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
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -1), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
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
            child: const Icon(Icons.medical_services_outlined, size: 64, color: Color(0xFF0EA5E9)),
          ),
          const SizedBox(height: 20),
          const Text('Tidak ada data layanan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF475569))),
          const SizedBox(height: 8),
          const Text('Tambahkan layanan baru untuk memulai', style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8))),
        ],
      ),
    );
  }

  Widget _buildLayananCard(BuildContext context, LayananModel layanan, LayananProvider provider, NumberFormat currencyFormat) {
    final kategoriData = _getKategoriData(layanan.kategori);

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
            Navigator.push(context, MaterialPageRoute(builder: (context) => LayananDetailPage(layananId: layanan.id)));
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: kategoriData['color'].withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(kategoriData['icon'], size: 32, color: kategoriData['color']),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(layanan.nama, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF0F172A), letterSpacing: -0.3), maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: kategoriData['color'].withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                Icon(kategoriData['icon'], size: 12, color: kategoriData['color']),
                                const SizedBox(width: 4),
                                Text(layanan.kategori, style: TextStyle(fontSize: 11, color: kategoriData['color'], fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.location_on, size: 13, color: const Color(0xFF94A3B8)),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(layanan.unitPelayanan, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)), maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.code, size: 13, color: const Color(0xFF94A3B8)),
                          const SizedBox(width: 4),
                          Text(layanan.kode, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                          const SizedBox(width: 12),
                          Icon(Icons.access_time, size: 13, color: const Color(0xFF94A3B8)),
                          const SizedBox(width: 4),
                          Text(layanan.durasi, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(currencyFormat.format(layanan.tarif), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF10B981))),
                      ),
                    ],
                  ),
                ),
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
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(children: [Icon(Icons.delete_outline, size: 20, color: Color(0xFFDC2626)), SizedBox(width: 12), Text('Hapus', style: TextStyle(fontSize: 14, color: Color(0xFFDC2626)))]),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'detail') {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LayananDetailPage(layananId: layanan.id)));
                      } else if (value == 'edit') {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LayananFormPage(layanan: layanan)));
                      } else if (value == 'delete') {
                        _showDeleteDialog(context, layanan, provider);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
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

  void _showFilterDialog(BuildContext context, LayananProvider provider) {
    final kategoriList = ['Semua', ...provider.getKategoriList()];
    final unitList = ['Semua', ...provider.getUnitList()];

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
              const Text('Kategori', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF475569))),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _filterKategori,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                ),
                items: kategoriList.map((k) => DropdownMenuItem(value: k, child: Text(k))).toList(),
                onChanged: (value) => setState(() => _filterKategori = value!),
              ),
              const SizedBox(height: 16),
              const Text('Unit Pelayanan', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF475569))),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _filterUnit,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                ),
                items: unitList.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                onChanged: (value) => setState(() => _filterUnit = value!),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _filterKategori = 'Semua';
                          _filterUnit = 'Semua';
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
                child: const Icon(Icons.delete_outline, color: Color(0xFFDC2626), size: 32),
              ),
              const SizedBox(height: 20),
              const Text('Hapus Layanan', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF0F172A), letterSpacing: -0.5)),
              const SizedBox(height: 12),
              Text('Apakah Anda yakin ingin menghapus layanan ${layanan.nama}?', style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)), textAlign: TextAlign.center),
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
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(success ? 'Data layanan berhasil dihapus' : 'Gagal menghapus data'),
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