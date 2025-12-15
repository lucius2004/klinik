// lib/pages/admin/staff/staff_list_page.dart
// DESAIN MEDICAL THEME - Minimalist dengan Animasi & Warna Medical

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/staff_provider.dart';
import '../../../models/staff_model.dart';
import 'staff_form_page.dart';
import 'staff_detail_page.dart';

class StaffListPage extends StatefulWidget {
  const StaffListPage({super.key});

  @override
  State<StaffListPage> createState() => _StaffListPageState();
}

class _StaffListPageState extends State<StaffListPage> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _filterPosisi = 'Semua';
  String _filterShift = 'Semua';
  String _filterGender = 'Semua';
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
    final staffProvider = Provider.of<StaffProvider>(context);
    List<StaffModel> filteredList = staffProvider.activeStaffList;

    if (_searchQuery.isNotEmpty) {
      filteredList = staffProvider.searchStaff(_searchQuery);
    }
    if (_filterPosisi != 'Semua') {
      filteredList = filteredList.where((s) => s.posisi == _filterPosisi).toList();
    }
    if (_filterShift != 'Semua') {
      filteredList = filteredList.where((s) => s.shift == _filterShift).toList();
    }
    if (_filterGender != 'Semua') {
      filteredList = filteredList.where((s) => s.jenisKelamin == _filterGender).toList();
    }

    final statistics = staffProvider.getStatistics();

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
                          'Data Staff',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F172A),
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Kelola data staff',
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
                      onPressed: () => _showFilterDialog(context, staffProvider),
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
                  colors: [Color(0xFFF97316), Color(0xFFEA580C)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF97316).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(child: _buildStatItem('Total', statistics['total'].toString(), Icons.people)),
                  Container(width: 1, height: 40, color: Colors.white.withValues(alpha: 0.3)),
                  Expanded(child: _buildStatItem('Laki-laki', statistics['laki'].toString(), Icons.male)),
                  Container(width: 1, height: 40, color: Colors.white.withValues(alpha: 0.3)),
                  Expanded(child: _buildStatItem('Perempuan', statistics['perempuan'].toString(), Icons.female)),
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
                    hintText: 'Cari nama, NIP, posisi...',
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
            if (_filterPosisi != 'Semua' || _filterShift != 'Semua' || _filterGender != 'Semua')
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Wrap(
                  spacing: 8,
                  children: [
                    if (_filterPosisi != 'Semua')
                      Chip(
                        label: Text(_filterPosisi),
                        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFF97316)),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        deleteIconColor: const Color(0xFFF97316),
                        backgroundColor: const Color(0xFFF97316).withValues(alpha: 0.1),
                        side: BorderSide.none,
                        onDeleted: () => setState(() => _filterPosisi = 'Semua'),
                      ),
                    if (_filterShift != 'Semua')
                      Chip(
                        label: Text('Shift: $_filterShift'),
                        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF8B5CF6)),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        deleteIconColor: const Color(0xFF8B5CF6),
                        backgroundColor: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                        side: BorderSide.none,
                        onDeleted: () => setState(() => _filterShift = 'Semua'),
                      ),
                    if (_filterGender != 'Semua')
                      Chip(
                        label: Text(_filterGender == 'L' ? 'Laki-laki' : 'Perempuan'),
                        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF0EA5E9)),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        deleteIconColor: const Color(0xFF0EA5E9),
                        backgroundColor: const Color(0xFF0EA5E9).withValues(alpha: 0.1),
                        side: BorderSide.none,
                        onDeleted: () => setState(() => _filterGender = 'Semua'),
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
                          final staff = filteredList[index];
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
                            child: _buildStaffCard(context, staff, staffProvider),
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
          Navigator.push(context, MaterialPageRoute(builder: (context) => const StaffFormPage()));
        },
        backgroundColor: const Color(0xFFF97316),
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
              color: const Color(0xFFF97316).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.people_outline, size: 64, color: Color(0xFFF97316)),
          ),
          const SizedBox(height: 20),
          const Text('Tidak ada data staff', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF475569))),
          const SizedBox(height: 8),
          const Text('Tambahkan staff baru untuk memulai', style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8))),
        ],
      ),
    );
  }

  Widget _buildStaffCard(BuildContext context, StaffModel staff, StaffProvider provider) {
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => StaffDetailPage(staffId: staff.id)));
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
                    color: posisiColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(posisiIcon, size: 32, color: posisiColor),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(staff.nama, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF0F172A), letterSpacing: -0.3)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: posisiColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                Icon(posisiIcon, size: 12, color: posisiColor),
                                const SizedBox(width: 4),
                                Text(staff.posisi, style: TextStyle(fontSize: 11, color: posisiColor, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFF64748B).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.access_time, size: 12, color: Color(0xFF64748B)),
                                const SizedBox(width: 4),
                                Text(staff.shift, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.badge, size: 13, color: Color(0xFF94A3B8)),
                          const SizedBox(width: 4),
                          Text('NIP: ${staff.nip}', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                          const SizedBox(width: 12),
                          const Icon(Icons.phone, size: 13, color: Color(0xFF94A3B8)),
                          const SizedBox(width: 4),
                          Expanded(child: Text(staff.noTelepon, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500))),
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
                        child: Row(children: [Icon(Icons.info_outline, size: 20, color: Color(0xFFF97316)), SizedBox(width: 12), Text('Detail', style: TextStyle(fontSize: 14))]),
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => StaffDetailPage(staffId: staff.id)));
                      } else if (value == 'edit') {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => StaffFormPage(staff: staff)));
                      } else if (value == 'delete') {
                        _showDeleteDialog(context, staff, provider);
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

  void _showFilterDialog(BuildContext context, StaffProvider provider) {
    final posisiList = ['Semua', ...provider.getPosisiList()];
    final shiftList = ['Semua', 'Pagi', 'Siang', 'Malam', 'Fleksibel'];

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
                    decoration: BoxDecoration(color: const Color(0xFFF97316).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.filter_list, color: Color(0xFFF97316), size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Text('Filter Data', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF0F172A), letterSpacing: -0.5)),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Posisi', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF475569))),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _filterPosisi,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                ),
                items: posisiList.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                onChanged: (value) => setState(() => _filterPosisi = value!),
              ),
              const SizedBox(height: 16),
              const Text('Shift', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF475569))),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _filterShift,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                ),
                items: shiftList.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (value) => setState(() => _filterShift = value!),
              ),
              const SizedBox(height: 16),
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
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _filterPosisi = 'Semua';
                          _filterShift = 'Semua';
                          _filterGender = 'Semua';
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
                        backgroundColor: const Color(0xFFF97316),
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
                child: const Icon(Icons.delete_outline, color: Color(0xFFDC2626), size: 32),
              ),
              const SizedBox(height: 20),
              const Text('Hapus Staff', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF0F172A), letterSpacing: -0.5)),
              const SizedBox(height: 12),
              Text('Apakah Anda yakin ingin menghapus data ${staff.nama}?', style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)), textAlign: TextAlign.center),
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
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(success ? 'Data staff berhasil dihapus' : 'Gagal menghapus data'),
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