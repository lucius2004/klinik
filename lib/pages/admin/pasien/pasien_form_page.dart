// lib/pages/admin/pasien/pasien_form_page.dart
// DESAIN MEDICAL THEME - Minimalist dengan Animasi & Warna Medical

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../../providers/pasien_provider.dart';
import '../../../../../models/pasien_model.dart';

class PasienFormPage extends StatefulWidget {
  final PasienModel? pasien;
  const PasienFormPage({super.key, this.pasien});

  @override
  State<PasienFormPage> createState() => _PasienFormPageState();
}

class _PasienFormPageState extends State<PasienFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nikController = TextEditingController();
  final _namaController = TextEditingController();
  final _tempatLahirController = TextEditingController();
  final _alamatController = TextEditingController();
  final _noTeleponController = TextEditingController();
  final _emailController = TextEditingController();
  final _pekerjaanController = TextEditingController();
  final _namaWaliController = TextEditingController();
  final _noTeleponWaliController = TextEditingController();
  final _noAsuransiController = TextEditingController();

  DateTime _tanggalLahir = DateTime(2000, 1, 1);
  String _jenisKelamin = 'L';
  String _golonganDarah = 'A';
  String _statusPerkawinan = 'Belum Kawin';
  String _asuransi = 'Umum';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.pasien != null) _loadPasienData();
  }

  void _loadPasienData() {
    final p = widget.pasien!;
    _nikController.text = p.nik;
    _namaController.text = p.nama;
    _tempatLahirController.text = p.tempatLahir;
    _alamatController.text = p.alamat;
    _noTeleponController.text = p.noTelepon;
    _emailController.text = p.email;
    _pekerjaanController.text = p.pekerjaan;
    _namaWaliController.text = p.namaWali;
    _noTeleponWaliController.text = p.noTeleponWali;
    _noAsuransiController.text = p.noAsuransi;
    _tanggalLahir = p.tanggalLahir;
    _jenisKelamin = p.jenisKelamin;
    _golonganDarah = p.golonganDarah;
    _statusPerkawinan = p.statusPerkawinan;
    _asuransi = p.asuransi;
  }

  @override
  void dispose() {
    _nikController.dispose();
    _namaController.dispose();
    _tempatLahirController.dispose();
    _alamatController.dispose();
    _noTeleponController.dispose();
    _emailController.dispose();
    _pekerjaanController.dispose();
    _namaWaliController.dispose();
    _noTeleponWaliController.dispose();
    _noAsuransiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.pasien != null;

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
                          isEdit ? 'Edit Pasien' : 'Tambah Pasien',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF0F172A), letterSpacing: -0.5),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isEdit ? 'Perbarui data pasien' : 'Tambahkan pasien baru',
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
                    _buildSectionTitle('DATA IDENTITAS', Icons.badge),
                    const SizedBox(height: 12),
                    _buildTextField(_nikController, 'NIK (KTP) *', '16 digit NIK', Icons.credit_card, keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(16)], validator: (v) {
                      if (v == null || v.isEmpty) return 'NIK harus diisi';
                      if (v.length != 16) return 'NIK harus 16 digit';
                      return null;
                    }),
                    const SizedBox(height: 12),
                    _buildTextField(_namaController, 'Nama Lengkap *', 'Contoh: Ahmad Hidayat', Icons.person, textCap: TextCapitalization.words),
                    const SizedBox(height: 12),
                    _buildTextField(_tempatLahirController, 'Tempat Lahir *', 'Contoh: Jakarta', Icons.location_city, textCap: TextCapitalization.words),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: InputDecorator(
                        decoration: _inputDecoration('Tanggal Lahir *', Icons.calendar_today),
                        child: Text(DateFormat('dd MMMM yyyy', 'id_ID').format(_tanggalLahir), style: const TextStyle(fontSize: 14)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDropdown('Jenis Kelamin *', _jenisKelamin, Icons.wc, ['L', 'P'], ['Laki-laki', 'Perempuan'], (v) => setState(() => _jenisKelamin = v!)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildDropdown('Golongan Darah', _golonganDarah, Icons.bloodtype, ['A', 'B', 'AB', 'O', '-'], ['A', 'B', 'AB', 'O', 'Tidak Tahu'], (v) => setState(() => _golonganDarah = v!))),
                        const SizedBox(width: 12),
                        Expanded(child: _buildDropdown('Status', _statusPerkawinan, Icons.family_restroom, ['Belum Kawin', 'Kawin', 'Cerai'], ['Belum Kawin', 'Kawin', 'Cerai'], (v) => setState(() => _statusPerkawinan = v!))),
                      ],
                    ),
                    const SizedBox(height: 20),

                    _buildSectionTitle('KONTAK', Icons.contact_phone),
                    const SizedBox(height: 12),
                    _buildTextField(_alamatController, 'Alamat Lengkap *', '', Icons.home, maxLines: 3, textCap: TextCapitalization.sentences),
                    const SizedBox(height: 12),
                    _buildTextField(_noTeleponController, 'No. Telepon *', '08xxxxxxxxxx', Icons.phone, keyboardType: TextInputType.phone, inputFormatters: [FilteringTextInputFormatter.digitsOnly], validator: (v) {
                      if (v == null || v.isEmpty) return 'No. telepon harus diisi';
                      if (v.length < 10) return 'No. telepon minimal 10 digit';
                      return null;
                    }),
                    const SizedBox(height: 12),
                    _buildTextField(_emailController, 'Email', 'email@example.com', Icons.email, keyboardType: TextInputType.emailAddress, required: false, validator: (v) {
                      if (v != null && v.isNotEmpty && !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) return 'Format email tidak valid';
                      return null;
                    }),
                    const SizedBox(height: 20),

                    _buildSectionTitle('PEKERJAAN', Icons.work),
                    const SizedBox(height: 12),
                    _buildTextField(_pekerjaanController, 'Pekerjaan', 'Contoh: Karyawan Swasta', Icons.business_center, textCap: TextCapitalization.words, required: false),
                    const SizedBox(height: 20),

                    _buildSectionTitle('WALI / KELUARGA', Icons.people),
                    const SizedBox(height: 12),
                    _buildTextField(_namaWaliController, 'Nama Wali/Keluarga', '', Icons.person_outline, textCap: TextCapitalization.words, required: false),
                    const SizedBox(height: 12),
                    _buildTextField(_noTeleponWaliController, 'No. Telepon Wali', '08xxxxxxxxxx', Icons.phone_outlined, keyboardType: TextInputType.phone, inputFormatters: [FilteringTextInputFormatter.digitsOnly], required: false),
                    const SizedBox(height: 20),

                    _buildSectionTitle('ASURANSI', Icons.health_and_safety),
                    const SizedBox(height: 12),
                    _buildDropdown('Jenis Asuransi *', _asuransi, Icons.medical_information, ['Umum', 'BPJS', 'Asuransi Swasta'], ['Umum', 'BPJS Kesehatan', 'Asuransi Swasta'], (v) => setState(() => _asuransi = v!)),
                    const SizedBox(height: 12),
                    if (_asuransi != 'Umum')
                      _buildTextField(_noAsuransiController, 'No. Asuransi/BPJS', '', Icons.card_membership, keyboardType: TextInputType.number, required: false),
                    const SizedBox(height: 24),

                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                            : Text(isEdit ? 'SIMPAN PERUBAHAN' : 'TAMBAH PASIEN', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, letterSpacing: 0.5)),
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
          decoration: BoxDecoration(color: const Color(0xFF10B981).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: const Color(0xFF10B981), size: 20),
        ),
        const SizedBox(width: 12),
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF0F172A), letterSpacing: -0.3)),
      ],
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
      hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
      prefixIcon: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: const Color(0xFF10B981).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: const Color(0xFF10B981), size: 20),
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF10B981), width: 2)),
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
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: _inputDecoration(label, icon, hint: hint),
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      textCapitalization: textCap,
      style: const TextStyle(fontSize: 14),
      validator: validator ?? (required ? (v) {
        if (v == null || v.isEmpty) return '$label wajib diisi';
        return null;
      } : null),
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

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggalLahir,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('id', 'ID'),
    );
    if (picked != null && picked != _tanggalLahir) setState(() => _tanggalLahir = picked);
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final provider = Provider.of<PasienProvider>(context, listen: false);
    final isEdit = widget.pasien != null;

    final pasien = PasienModel(
      id: isEdit ? widget.pasien!.id : '',
      noRM: isEdit ? widget.pasien!.noRM : '',
      nik: _nikController.text.trim(),
      nama: _namaController.text.trim(),
      jenisKelamin: _jenisKelamin,
      tanggalLahir: _tanggalLahir,
      tempatLahir: _tempatLahirController.text.trim(),
      alamat: _alamatController.text.trim(),
      noTelepon: _noTeleponController.text.trim(),
      email: _emailController.text.trim(),
      golonganDarah: _golonganDarah,
      statusPerkawinan: _statusPerkawinan,
      pekerjaan: _pekerjaanController.text.trim(),
      namaWali: _namaWaliController.text.trim(),
      noTeleponWali: _noTeleponWaliController.text.trim(),
      asuransi: _asuransi,
      noAsuransi: _noAsuransiController.text.trim(),
      createdAt: isEdit ? widget.pasien!.createdAt : DateTime.now(),
    );

    bool success = isEdit ? await provider.updatePasien(pasien) : await provider.addPasien(pasien);

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEdit ? 'Data pasien berhasil diperbarui' : 'Pasien berhasil ditambahkan'),
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