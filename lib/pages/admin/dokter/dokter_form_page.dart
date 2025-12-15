// lib/pages/admin/dokter/dokter_form_page.dart
// DESAIN MEDICAL THEME - Minimalist dengan Animasi & Warna Medical

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../providers/dokter_provider.dart';
import '../../../models/dokter_model.dart';

class DokterFormPage extends StatefulWidget {
  final DokterModel? dokter;
  const DokterFormPage({super.key, this.dokter});

  @override
  State<DokterFormPage> createState() => _DokterFormPageState();
}

class _DokterFormPageState extends State<DokterFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nipController = TextEditingController();
  final _namaController = TextEditingController();
  final _noSTRController = TextEditingController();
  final _noSIPController = TextEditingController();
  final _pendidikanController = TextEditingController();
  final _alamatController = TextEditingController();
  final _noTeleponController = TextEditingController();
  final _emailController = TextEditingController();
  final _tempatLahirController = TextEditingController();
  final _tarifController = TextEditingController();
  final _jamPraktikController = TextEditingController();

  String _jenisKelamin = 'L';
  String _spesialisasi = 'Umum';
  DateTime _tanggalLahir = DateTime.now().subtract(const Duration(days: 365 * 30));
  bool _isLoading = false;

  final List<String> _spesialisasiList = [
    'Umum', 'Anak', 'Penyakit Dalam', 'Bedah', 'Kebidanan', 'Gigi',
    'Mata', 'THT', 'Kulit dan Kelamin', 'Jantung', 'Saraf', 'Paru',
    'Jiwa', 'Orthopedi',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.dokter != null) _loadDokterData();
  }

  void _loadDokterData() {
    final d = widget.dokter!;
    _nipController.text = d.nip;
    _namaController.text = d.nama;
    _noSTRController.text = d.noSTR;
    _noSIPController.text = d.noSIP;
    _pendidikanController.text = d.pendidikan;
    _alamatController.text = d.alamat;
    _noTeleponController.text = d.noTelepon;
    _emailController.text = d.email;
    _tempatLahirController.text = d.tempatLahir;
    _tarifController.text = d.tarif.toString();
    _jamPraktikController.text = d.jamPraktik;
    _jenisKelamin = d.jenisKelamin;
    _spesialisasi = d.spesialisasi;
    _tanggalLahir = d.tanggalLahir;
  }

  @override
  void dispose() {
    _nipController.dispose();
    _namaController.dispose();
    _noSTRController.dispose();
    _noSIPController.dispose();
    _pendidikanController.dispose();
    _alamatController.dispose();
    _noTeleponController.dispose();
    _emailController.dispose();
    _tempatLahirController.dispose();
    _tarifController.dispose();
    _jamPraktikController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.dokter != null;

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
                          isEdit ? 'Edit Dokter' : 'Tambah Dokter',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF0F172A), letterSpacing: -0.5),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isEdit ? 'Perbarui data dokter' : 'Tambahkan dokter baru',
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
                    _buildSectionTitle('INFORMASI DASAR', Icons.person),
                    const SizedBox(height: 12),
                    _buildTextField(_nipController, 'NIP *', 'Contoh: DKT001', Icons.badge),
                    const SizedBox(height: 12),
                    _buildTextField(_namaController, 'Nama Lengkap *', 'Contoh: Dr. Ahmad Hidayat, Sp.PD', Icons.person, textCap: TextCapitalization.words),
                    const SizedBox(height: 12),
                    _buildDropdown('Jenis Kelamin *', _jenisKelamin, Icons.wc, ['L', 'P'], ['Laki-laki', 'Perempuan'], (v) => setState(() => _jenisKelamin = v!)),
                    const SizedBox(height: 12),
                    _buildTextField(_tempatLahirController, 'Tempat Lahir *', '', Icons.location_city, textCap: TextCapitalization.words),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: InputDecorator(
                        decoration: _inputDecoration('Tanggal Lahir *', Icons.calendar_today),
                        child: Text(DateFormat('dd MMMM yyyy', 'id_ID').format(_tanggalLahir), style: const TextStyle(fontSize: 14)),
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildSectionTitle('KONTAK', Icons.contact_phone),
                    const SizedBox(height: 12),
                    _buildTextField(_alamatController, 'Alamat *', '', Icons.home, maxLines: 3, textCap: TextCapitalization.sentences),
                    const SizedBox(height: 12),
                    _buildTextField(_noTeleponController, 'No. Telepon *', '08xxxxxxxxxx', Icons.phone, keyboardType: TextInputType.phone, inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(15)]),
                    const SizedBox(height: 12),
                    _buildTextField(_emailController, 'Email', 'dokter@email.com', Icons.email, keyboardType: TextInputType.emailAddress, required: false),
                    const SizedBox(height: 20),

                    _buildSectionTitle('INFORMASI PROFESIONAL', Icons.medical_services),
                    const SizedBox(height: 12),
                    _buildDropdown('Spesialisasi *', _spesialisasi, Icons.medical_services, _spesialisasiList, _spesialisasiList, (v) => setState(() => _spesialisasi = v!)),
                    const SizedBox(height: 12),
                    _buildTextField(_noSTRController, 'No. STR *', 'STR-123456789', Icons.card_membership),
                    const SizedBox(height: 12),
                    _buildTextField(_noSIPController, 'No. SIP *', 'SIP-987654321', Icons.assignment),
                    const SizedBox(height: 12),
                    _buildTextField(_pendidikanController, 'Pendidikan Terakhir *', 'S2 Spesialis Penyakit Dalam - UI', Icons.school, maxLines: 2, textCap: TextCapitalization.sentences),
                    const SizedBox(height: 20),

                    _buildSectionTitle('INFORMASI PRAKTIK', Icons.work),
                    const SizedBox(height: 12),
                    _buildTextField(_tarifController, 'Tarif Konsultasi *', '150000', Icons.payments, keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly], prefix: 'Rp '),
                    const SizedBox(height: 12),
                    _buildTextField(_jamPraktikController, 'Jam Praktik', 'Senin-Jumat: 08:00-16:00', Icons.access_time, maxLines: 2, required: false),
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
                            : Text(isEdit ? 'SIMPAN PERUBAHAN' : 'TAMBAH DOKTER', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, letterSpacing: 0.5)),
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

  InputDecoration _inputDecoration(String label, IconData icon, {String? hint, String? prefix}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixText: prefix,
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
  }) {
    return TextFormField(
      controller: controller,
      decoration: _inputDecoration(label, icon, hint: hint, prefix: prefix),
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      textCapitalization: textCap,
      style: const TextStyle(fontSize: 14),
      validator: required ? (v) {
        if (v == null || v.isEmpty) return '$label wajib diisi';
        if (label.contains('Telepon') && v.length < 10) return 'No. telepon minimal 10 digit';
        if (label.contains('Email') && v.isNotEmpty && !v.contains('@')) return 'Format email tidak valid';
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

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggalLahir,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      locale: const Locale('id', 'ID'),
    );
    if (picked != null && picked != _tanggalLahir) setState(() => _tanggalLahir = picked);
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final provider = Provider.of<DokterProvider>(context, listen: false);
    final isEdit = widget.dokter != null;

    final dokter = DokterModel(
      id: isEdit ? widget.dokter!.id : '',
      nip: _nipController.text.trim(),
      nama: _namaController.text.trim(),
      jenisKelamin: _jenisKelamin,
      spesialisasi: _spesialisasi,
      noSTR: _noSTRController.text.trim(),
      noSIP: _noSIPController.text.trim(),
      pendidikan: _pendidikanController.text.trim(),
      alamat: _alamatController.text.trim(),
      noTelepon: _noTeleponController.text.trim(),
      email: _emailController.text.trim(),
      tanggalLahir: _tanggalLahir,
      tempatLahir: _tempatLahirController.text.trim(),
      tarif: double.parse(_tarifController.text.isEmpty ? '0' : _tarifController.text),
      jamPraktik: _jamPraktikController.text.trim(),
      createdAt: isEdit ? widget.dokter!.createdAt : null,
    );

    bool success = isEdit ? await provider.updateDokter(dokter) : await provider.addDokter(dokter);

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEdit ? 'Data dokter berhasil diperbarui' : 'Dokter berhasil ditambahkan'),
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