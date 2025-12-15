// lib/pages/admin/layanan/layanan_form_page.dart
// DESAIN MEDICAL THEME - Minimalist dengan Animasi & Warna Medical

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../providers/layanan_provider.dart';
import '../../../models/layanan_model.dart';

class LayananFormPage extends StatefulWidget {
  final LayananModel? layanan;
  const LayananFormPage({super.key, this.layanan});

  @override
  State<LayananFormPage> createState() => _LayananFormPageState();
}

class _LayananFormPageState extends State<LayananFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _kodeController = TextEditingController();
  final _namaController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _tarifController = TextEditingController();
  final _durasiController = TextEditingController();
  final _keteranganAlatController = TextEditingController();

  String _kategori = 'Pemeriksaan';
  String _unitPelayanan = 'Poli Umum';
  bool _membutuhkanDokter = true;
  bool _membutuhkanPerawat = false;
  bool _membutuhkanAlat = false;
  bool _isLoading = false;

  final List<String> _kategoriList = [
    'Pemeriksaan', 'Tindakan', 'Laboratorium', 'Radiologi',
    'Operasi', 'Rehabilitasi', 'Vaksinasi', 'Konsultasi',
  ];

  final List<String> _unitList = [
    'Poli Umum', 'Poli Anak', 'Poli Gigi', 'Poli Mata', 'Poli THT',
    'Poli Kulit', 'Poli Jantung', 'IGD', 'Laboratorium', 'Radiologi', 'Fisioterapi',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.layanan != null) _loadLayananData();
  }

  void _loadLayananData() {
    final layanan = widget.layanan!;
    _kodeController.text = layanan.kode;
    _namaController.text = layanan.nama;
    _deskripsiController.text = layanan.deskripsi;
    _tarifController.text = layanan.tarif.toString();
    _durasiController.text = layanan.durasiMenit.toString();
    _keteranganAlatController.text = layanan.keteranganAlat;
    _kategori = layanan.kategori;
    _unitPelayanan = layanan.unitPelayanan;
    _membutuhkanDokter = layanan.membutuhkanDokter;
    _membutuhkanPerawat = layanan.membutuhkanPerawat;
    _membutuhkanAlat = layanan.membutuhkanAlat;
  }

  @override
  void dispose() {
    _kodeController.dispose();
    _namaController.dispose();
    _deskripsiController.dispose();
    _tarifController.dispose();
    _durasiController.dispose();
    _keteranganAlatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.layanan != null;

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
                  BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 2)),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, size: 22),
                      color: const Color(0xFF475569),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEdit ? 'Edit Layanan' : 'Tambah Layanan',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF0F172A), letterSpacing: -0.5),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isEdit ? 'Perbarui data layanan' : 'Tambahkan layanan baru',
                          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Form
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildSectionTitle('INFORMASI DASAR', Icons.info),
                    const SizedBox(height: 12),
                    _buildTextField(_kodeController, 'Kode Layanan *', 'LAY001, LAB001', Icons.code, textCap: TextCapitalization.characters),
                    const SizedBox(height: 12),
                    _buildTextField(_namaController, 'Nama Layanan *', 'Konsultasi Dokter Umum', Icons.medical_services, textCap: TextCapitalization.words),
                    const SizedBox(height: 12),
                    _buildDropdown('Kategori *', _kategori, Icons.category, _kategoriList, _kategoriList, (v) => setState(() => _kategori = v!)),
                    const SizedBox(height: 12),
                    _buildDropdown('Unit Pelayanan *', _unitPelayanan, Icons.location_on, _unitList, _unitList, (v) => setState(() => _unitPelayanan = v!)),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _deskripsiController,
                      decoration: _inputDecoration('Deskripsi', Icons.description, hint: 'Deskripsi singkat layanan'),
                      maxLines: 3,
                      textCapitalization: TextCapitalization.sentences,
                      style: const TextStyle(fontSize: 14),
                    ),

                    const SizedBox(height: 20),
                    _buildSectionTitle('TARIF & DURASI', Icons.payments),
                    const SizedBox(height: 12),
                    _buildTextField(_tarifController, 'Tarif Layanan *', '50000', Icons.payments, keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly], prefix: 'Rp '),
                    const SizedBox(height: 12),
                    _buildTextField(_durasiController, 'Durasi (menit) *', '30', Icons.access_time, keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly], suffix: 'menit'),

                    const SizedBox(height: 20),
                    _buildSectionTitle('KEBUTUHAN SUMBER DAYA', Icons.people),
                    const SizedBox(height: 12),
                    _buildCheckboxTile('Membutuhkan Dokter', 'Layanan harus dilakukan oleh dokter', _membutuhkanDokter, Icons.person, const Color(0xFF0EA5E9), (v) => setState(() => _membutuhkanDokter = v!)),
                    const SizedBox(height: 8),
                    _buildCheckboxTile('Membutuhkan Perawat', 'Layanan memerlukan bantuan perawat', _membutuhkanPerawat, Icons.healing, const Color(0xFF3B82F6), (v) => setState(() => _membutuhkanPerawat = v!)),
                    const SizedBox(height: 8),
                    _buildCheckboxTile('Membutuhkan Alat Khusus', 'Layanan memerlukan alat/perangkat medis', _membutuhkanAlat, Icons.build, const Color(0xFFF59E0B), (v) => setState(() => _membutuhkanAlat = v!)),
                    
                    if (_membutuhkanAlat) ...[
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _keteranganAlatController,
                        decoration: _inputDecoration('Keterangan Alat', Icons.build_circle, hint: 'Sebutkan alat yang dibutuhkan'),
                        maxLines: 2,
                        textCapitalization: TextCapitalization.sentences,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],

                    const SizedBox(height: 24),
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0EA5E9),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                            : Text(isEdit ? 'SIMPAN PERUBAHAN' : 'TAMBAH LAYANAN', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, letterSpacing: 0.5)),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: const Color(0xFF0EA5E9).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: const Color(0xFF0EA5E9), size: 20),
        ),
        const SizedBox(width: 12),
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF0F172A), letterSpacing: -0.3)),
      ],
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon, {String? hint, String? prefix, String? suffix}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixText: prefix,
      suffixText: suffix,
      labelStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
      hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
      prefixIcon: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: const Color(0xFF0EA5E9).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: const Color(0xFF0EA5E9), size: 20),
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF0EA5E9), width: 2)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String hint, IconData icon, {
    bool required = true,
    int maxLines = 1,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    TextCapitalization textCap = TextCapitalization.none,
    String? prefix,
    String? suffix,
  }) {
    return TextFormField(
      controller: controller,
      decoration: _inputDecoration(label, icon, hint: hint, prefix: prefix, suffix: suffix),
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      textCapitalization: textCap,
      style: const TextStyle(fontSize: 14),
      validator: required ? (v) {
        if (v == null || v.isEmpty) return '$label wajib diisi';
        if (label.contains('Tarif') && int.tryParse(v) == null) return 'Tarif harus berupa angka';
        if (label.contains('Durasi') && int.tryParse(v) == null) return 'Durasi harus berupa angka';
        return null;
      } : null,
    );
  }

  Widget _buildDropdown(String label, String value, IconData icon, List<String> values, List<String> labels, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: _inputDecoration(label, icon),
      style: const TextStyle(fontSize: 14, color: Color(0xFF0F172A)),
      items: List.generate(values.length, (i) => DropdownMenuItem(value: values[i], child: Text(labels[i]))),
      onChanged: onChanged,
    );
  }

  Widget _buildCheckboxTile(String title, String subtitle, bool value, IconData icon, Color color, Function(bool?) onChanged) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: CheckboxListTile(
        title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
        value: value,
        onChanged: onChanged,
        secondary: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: color, size: 20),
        ),
        activeColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final provider = Provider.of<LayananProvider>(context, listen: false);
    final isEdit = widget.layanan != null;

    final layanan = LayananModel(
      id: isEdit ? widget.layanan!.id : '',
      kode: _kodeController.text.trim().toUpperCase(),
      nama: _namaController.text.trim(),
      kategori: _kategori,
      deskripsi: _deskripsiController.text.trim(),
      tarif: double.parse(_tarifController.text.isEmpty ? '0' : _tarifController.text),
      durasiMenit: int.parse(_durasiController.text.isEmpty ? '30' : _durasiController.text),
      membutuhkanDokter: _membutuhkanDokter,
      membutuhkanPerawat: _membutuhkanPerawat,
      membutuhkanAlat: _membutuhkanAlat,
      keteranganAlat: _keteranganAlatController.text.trim(),
      unitPelayanan: _unitPelayanan,
      createdAt: isEdit ? widget.layanan!.createdAt : null,
    );

    bool success = isEdit ? await provider.updateLayanan(layanan) : await provider.addLayanan(layanan);

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEdit ? 'Data layanan berhasil diperbarui' : 'Layanan berhasil ditambahkan'),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage ?? 'Terjadi kesalahan'),
            backgroundColor: const Color(0xFFDC2626),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }
}