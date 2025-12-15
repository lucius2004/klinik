// lib/pages/admin/pasien/pasien_list_page.dart
// DESAIN MEDICAL THEME - Minimalist dengan Animasi & Warna Medical

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../providers/pasien_provider.dart';
import '../../../../../models/pasien_model.dart';
import 'pasien_form_page.dart';
import 'pasien_detail_page.dart';

class PasienListPage extends StatefulWidget {
  const PasienListPage({super.key});

  @override
  State<PasienListPage> createState() => _PasienListPageState();
}

class _PasienListPageState extends State<PasienListPage> with TickerProviderStateMixin {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _filterGender = 'Semua';
  String _filterAsuransi = 'Semua';
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
                          'Data Pasien',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F172A),
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Kelola data pasien',
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
                      onPressed: _showFilterDialog,
                    ),
                  ),
                ],
              ),
            ),

            // Statistics
            Consumer<PasienProvider>(
              builder: (context, provider, child) {
                final stats = provider.getStatistics();
                return Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF10B981), Color(0xFF059669)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF10B981).withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(child: _buildStatItem('Total', stats['total'].toString(), Icons.people)),
                      Container(width: 1, height: 40, color: Colors.white.withValues(alpha: 0.3)),
                      Expanded(child: _buildStatItem('Laki-laki', stats['laki'].toString(), Icons.male)),
                      Container(width: 1, height: 40, color: Colors.white.withValues(alpha: 0.3)),
                      Expanded(child: _buildStatItem('Perempuan', stats['perempuan'].toString(), Icons.female)),
                      Container(width: 1, height: 40, color: Colors.white.withValues(alpha: 0.3)),
                      Expanded(child: _buildStatItem('BPJS', stats['bpjs'].toString(), Icons.health_and_safety)),
                    ],
                  ),
                );
              },
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
                    hintText: 'Cari nama, No RM, NIK, atau telepon...',
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
            if (_filterGender != 'Semua' || _filterAsuransi != 'Semua')
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Wrap(
                  spacing: 8,
                  children: [
                    if (_filterGender != 'Semua')
                      Chip(
                        label: Text(_filterGender == 'L' ? 'Laki-laki' : 'Perempuan'),
                        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF8B5CF6)),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        deleteIconColor: const Color(0xFF8B5CF6),
                        backgroundColor: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                        side: BorderSide.none,
                        onDeleted: () => setState(() => _filterGender = 'Semua'),
                      ),
                    if (_filterAsuransi != 'Semua')
                      Chip(
                        label: Text(_filterAsuransi),
                        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF10B981)),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        deleteIconColor: const Color(0xFF10B981),
                        backgroundColor: const Color(0xFF10B981).withValues(alpha: 0.1),
                        side: BorderSide.none,
                        onDeleted: () => setState(() => _filterAsuransi = 'Semua'),
                      ),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            // List
            Expanded(
              child: Consumer<PasienProvider>(
                builder: (context, provider, child) {
                  List<PasienModel> filteredList = provider.searchPasien(_searchQuery);

                  if (_filterGender != 'Semua') {
                    filteredList = filteredList.where((p) => p.jenisKelamin == _filterGender).toList();
                  }
                  if (_filterAsuransi != 'Semua') {
                    filteredList = filteredList.where((p) => p.asuransi == _filterAsuransi).toList();
                  }

                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: filteredList.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                            itemCount: filteredList.length,
                            itemBuilder: (context, index) {
                              final pasien = filteredList[index];
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
                                child: _buildPasienCard(pasien, provider),
                              );
                            },
                          ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const PasienFormPage()));
        },
        backgroundColor: const Color(0xFF10B981),
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
              color: const Color(0xFF10B981).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.people_outline, size: 64, color: Color(0xFF10B981)),
          ),
          const SizedBox(height: 20),
          const Text('Tidak ada data pasien', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF475569))),
          const SizedBox(height: 8),
          const Text('Tambahkan pasien baru untuk memulai', style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8))),
        ],
      ),
    );
  }

  Widget _buildPasienCard(PasienModel pasien, PasienProvider provider) {
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => PasienDetailPage(pasien: pasien)));
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
                    color: pasien.jenisKelamin == 'L'
                        ? const Color(0xFF0EA5E9).withValues(alpha: 0.1)
                        : const Color(0xFFEC4899).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      pasien.nama.split(' ').map((e) => e[0]).take(2).join().toUpperCase(),
                      style: TextStyle(
                        color: pasien.jenisKelamin == 'L' ? const Color(0xFF0EA5E9) : const Color(0xFFEC4899),
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(pasien.nama, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF0F172A), letterSpacing: -0.3)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.badge, size: 12, color: Color(0xFF8B5CF6)),
                                const SizedBox(width: 4),
                                Text(pasien.noRM, style: const TextStyle(fontSize: 11, color: Color(0xFF8B5CF6), fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: pasien.asuransi == 'BPJS'
                                  ? const Color(0xFF10B981).withValues(alpha: 0.1)
                                  : const Color(0xFFF59E0B).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.health_and_safety, size: 12, color: pasien.asuransi == 'BPJS' ? const Color(0xFF10B981) : const Color(0xFFF59E0B)),
                                const SizedBox(width: 4),
                                Text(pasien.asuransi, style: TextStyle(fontSize: 11, color: pasien.asuransi == 'BPJS' ? const Color(0xFF10B981) : const Color(0xFFF59E0B), fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(pasien.jenisKelamin == 'L' ? Icons.male : Icons.female, size: 13, color: const Color(0xFF94A3B8)),
                          const SizedBox(width: 4),
                          Text('${pasien.umur} tahun', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                          const SizedBox(width: 12),
                          const Icon(Icons.phone, size: 13, color: Color(0xFF94A3B8)),
                          const SizedBox(width: 4),
                          Expanded(child: Text(pasien.noTelepon, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500))),
                        ],
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
                        child: Row(children: [Icon(Icons.info_outline, size: 20, color: Color(0xFF10B981)), SizedBox(width: 12), Text('Detail', style: TextStyle(fontSize: 14))]),
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PasienDetailPage(pasien: pasien)));
                      } else if (value == 'edit') {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PasienFormPage(pasien: pasien)));
                      } else if (value == 'delete') {
                        _confirmDelete(pasien, provider);
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

  void _showFilterDialog() {
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
                    decoration: BoxDecoration(color: const Color(0xFF10B981).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.filter_list, color: Color(0xFF10B981), size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Text('Filter Data', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF0F172A), letterSpacing: -0.5)),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Jenis Kelamin', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF475569))),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _filterGender,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                ),
                items: const [
                  DropdownMenuItem(value: 'Semua', child: Text('Semua')),
                  DropdownMenuItem(value: 'L', child: Text('Laki-laki')),
                  DropdownMenuItem(value: 'P', child: Text('Perempuan')),
                ],
                onChanged: (value) => setState(() => _filterGender = value!),
              ),
              const SizedBox(height: 16),
              const Text('Asuransi', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF475569))),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _filterAsuransi,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                ),
                items: const [
                  DropdownMenuItem(value: 'Semua', child: Text('Semua')),
                  DropdownMenuItem(value: 'BPJS', child: Text('BPJS Kesehatan')),
                  DropdownMenuItem(value: 'Umum', child: Text('Umum')),
                  DropdownMenuItem(value: 'Asuransi Swasta', child: Text('Asuransi Swasta')),
                ],
                onChanged: (value) => setState(() => _filterAsuransi = value!),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _filterGender = 'Semua';
                          _filterAsuransi = 'Semua';
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
                        backgroundColor: const Color(0xFF10B981),
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

  void _confirmDelete(PasienModel pasien, PasienProvider provider) {
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
              const Text('Hapus Pasien', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF0F172A), letterSpacing: -0.5)),
              const SizedBox(height: 12),
              Text('Apakah Anda yakin ingin menghapus data ${pasien.nama}?', style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)), textAlign: TextAlign.center),
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
                        final success = await provider.deletePasien(pasien.id);
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(success ? 'Pasien berhasil dihapus' : 'Gagal menghapus pasien'),
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