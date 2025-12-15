// lib/pages/admin/staff/staff_form_page.dart
// DESAIN MEDICAL THEME - Minimalist dengan Animasi & Warna Medical

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../providers/staff_provider.dart';
import '../../../models/staff_model.dart';

class StaffFormPage extends StatefulWidget {
  final StaffModel? staff;
  const StaffFormPage({super.key, this.staff});

  @override
  State<StaffFormPage> createState() => _StaffFormPageState();
}

class _StaffFormPageState extends State<StaffFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nipController = TextEditingController();
  final _namaController = TextEditingController();
  final _pendidikanController = TextEditingController();
  final _alamatController = TextEditingController();
  final _noTeleponController = TextEditingController();
  final _emailController = TextEditingController();
  final _tempatLahirController = TextEditingController();
  final _gajiController = TextEditingController();
  final _noRekeningController = TextEditingController();
  final _namaBankController = TextEditingController();
  final _kontakDaruratController = TextEditingController();
  final _noKontakDaruratController = TextEditingController();

  String _jenisKelamin = 'L';
  String _posisi = 'Administrasi';
  String _shift = 'Pagi';
  DateTime _tanggalLahir = DateTime.now().subtract(const Duration(days: 365 * 25));
  DateTime _tanggalBergabung = DateTime.now();
  bool _isLoading = false;

  final List<String> _posisiList = [
    'Administrasi',
    'Perawat',
    'Apoteker',
    'Laboratorium',
    'Kasir',
    'Cleaning Service',
    'Keamanan',
    'IT Support',
    'Customer Service',
  ];

  final List<String> _shiftList = ['Pagi', 'Siang', 'Malam', 'Fleksibel'];

  @override
  void initState() {
    super.initState();
    if (widget.staff != null) _loadStaffData();
  }

  void _loadStaffData() {
    final staff = widget.staff!;
    _nipController.text = staff.nip;
    _namaController.text = staff.nama;
    _pendidikanController.text = staff.pendidikan;
    _alamatController.text = staff.alamat;
    _noTeleponController.text = staff.noTelepon;
    _emailController.text = staff.email;
    _tempatLahirController.text = staff.tempatLahir;
    _gajiController.text = staff.gaji.toString();
    _noRekeningController.text = staff.noRekening;
    _namaBankController.text = staff.namaBank;
    _kontakDaruratController.text = staff.kontakDarurat;
    _noKontakDaruratController.text = staff.noKontakDarurat;
    _jenisKelamin = staff.jenisKelamin;
    _posisi = staff.posisi;
    _shift = staff.shift;
    _tanggalLahir = staff.tanggalLahir;
    _tanggalBergabung = staff.tanggalBergabung;
  }

  @override
  void dispose() {
    _nipController.dispose();
    _namaController.dispose();
    _pendidikanController.dispose();
    _alamatController.dispose();
    _noTeleponController.dispose();
    _emailController.dispose();
    _tempatLahirController.dispose();
    _gajiController.dispose();
    _noRekeningController.dispose();
    _namaBankController.dispose();
    _kontakDaruratController.dispose();
    _noKontakDaruratController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.staff != null;

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
                          isEdit ? 'Edit Staff' : 'Tambah Staff',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF0F172A), letterSpacing: -0.5),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isEdit ? 'Perbarui data staff' : 'Tambahkan staff baru',
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
                    _buildTextField(_nipController, 'NIP *', 'Contoh: STF001', Icons.badge),
                    const SizedBox(height: 12),
                    _buildTextField(_namaController, 'Nama Lengkap *', 'Contoh: Siti Aminah', Icons.person, textCap: TextCapitalization.words),
                    const SizedBox(height: 12),
                    _buildDropdown('Jenis Kelamin *', _jenisKelamin, Icons.wc, ['L', 'P'], ['Laki-laki', 'Perempuan'], (v) => setState(() => _jenisKelamin = v!)),
                    const SizedBox(height: 12),
                    _buildTextField(_tempatLahirController, 'Tempat Lahir *', '', Icons.location_city, textCap: TextCapitalization.words),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () => _selectDate(context, true),
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
                    _buildTextField(_noTeleponController, 'No. Telepon *', '08xxxxxxxxxx', Icons.phone, keyboardType: TextInputType.phone, inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(15)], validator: (v) {
                      if (v == null || v.isEmpty) return 'No. telepon wajib diisi';
                      if (v.length < 10) return 'No. telepon minimal 10 digit';
                      return null;
                    }),
                    const SizedBox(height: 12),
                    _buildTextField(_emailController, 'Email', 'staff@email.com', Icons.email, keyboardType: TextInputType.emailAddress, required: false, validator: (v) {
                      if (v != null && v.isNotEmpty && !v.contains('@')) return 'Format email tidak valid';
                      return null;
                    }),
                    const SizedBox(height: 20),

                    _buildSectionTitle('KONTAK DARURAT', Icons.contact_emergency),
                    const SizedBox(height: 12),
                    _buildTextField(_kontakDaruratController, 'Nama Kontak Darurat', 'Contoh: Ibu Siti (Orang Tua)', Icons.contact_emergency, textCap: TextCapitalization.words, required: false),
                    const SizedBox(height: 12),
                    _buildTextField(_noKontakDaruratController, 'No. Telepon Darurat', '08xxxxxxxxxx', Icons.phone_in_talk, keyboardType: TextInputType.phone, inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(15)], required: false),
                    const SizedBox(height: 20),

                    _buildSectionTitle('INFORMASI PEKERJAAN', Icons.work),
                    const SizedBox(height: 12),
                    _buildDropdown('Posisi *', _posisi, Icons.work, _posisiList, _posisiList, (v) => setState(() => _posisi = v!)),
                    const SizedBox(height: 12),
                    _buildTextField(_pendidikanController, 'Pendidikan Terakhir *', 'Contoh: D3 Keperawatan', Icons.school, textCap: TextCapitalization.sentences),
                    const SizedBox(height: 12),
                    _buildDropdown('Shift Kerja *', _shift, Icons.access_time, _shiftList, _shiftList, (v) => setState(() => _shift = v!)),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () => _selectDate(context, false),
                      child: InputDecorator(
                        decoration: _inputDecoration('Tanggal Bergabung *', Icons.event),
                        child: Text(DateFormat('dd MMMM yyyy', 'id_ID').format(_tanggalBergabung), style: const TextStyle(fontSize: 14)),
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildSectionTitle('GAJI & REKENING', Icons.payments),
                    const SizedBox(height: 12),
                    _buildTextField(_gajiController, 'Gaji Pokok *', '4500000', Icons.payments, keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly], prefix: 'Rp ', validator: (v) {
                      if (v == null || v.isEmpty) return 'Gaji wajib diisi';
                      if (int.tryParse(v) == null) return 'Gaji harus berupa angka';
                      return null;
                    }),
                    const SizedBox(height: 12),
                    _buildTextField(_namaBankController, 'Nama Bank', 'Contoh: BCA, Mandiri, BRI', Icons.account_balance, textCap: TextCapitalization.characters, required: false),
                    const SizedBox(height: 12),
                    _buildTextField(_noRekeningController, 'No. Rekening', '1234567890', Icons.credit_card, keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly], required: false),
                    const SizedBox(height: 24),

                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF97316),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                            : Text(isEdit ? 'SIMPAN PERUBAHAN' : 'TAMBAH STAFF', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, letterSpacing: 0.5)),
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
          decoration: BoxDecoration(color: const Color(0xFFF97316).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: const Color(0xFFF97316), size: 20),
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
        decoration: BoxDecoration(color: const Color(0xFFF97316).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: const Color(0xFFF97316), size: 20),
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFF97316), width: 2)),
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
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: _inputDecoration(label, icon, hint: hint, prefix: prefix),
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

  Future<void> _selectDate(BuildContext context, bool isBirthDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isBirthDate ? _tanggalLahir : _tanggalBergabung,
      firstDate: isBirthDate ? DateTime(1950) : DateTime(2000),
      lastDate: DateTime.now(),
      locale: const Locale('id', 'ID'),
    );
    if (picked != null) {
      setState(() {
        if (isBirthDate) {
          _tanggalLahir = picked;
        } else {
          _tanggalBergabung = picked;
        }
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final provider = Provider.of<StaffProvider>(context, listen: false);
    final isEdit = widget.staff != null;

    final staff = StaffModel(
      id: isEdit ? widget.staff!.id : '',
      nip: _nipController.text.trim(),
      nama: _namaController.text.trim(),
      jenisKelamin: _jenisKelamin,
      posisi: _posisi,
      pendidikan: _pendidikanController.text.trim(),
      alamat: _alamatController.text.trim(),
      noTelepon: _noTeleponController.text.trim(),
      email: _emailController.text.trim(),
      tanggalLahir: _tanggalLahir,
      tempatLahir: _tempatLahirController.text.trim(),
      shift: _shift,
      gaji: double.parse(_gajiController.text.isEmpty ? '0' : _gajiController.text),
      noRekening: _noRekeningController.text.trim(),
      namaBank: _namaBankController.text.trim(),
      kontakDarurat: _kontakDaruratController.text.trim(),
      noKontakDarurat: _noKontakDaruratController.text.trim(),
      tanggalBergabung: _tanggalBergabung,
      createdAt: isEdit ? widget.staff!.createdAt : null,
    );

    bool success = isEdit ? await provider.updateStaff(staff) : await provider.addStaff(staff);

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEdit ? 'Data staff berhasil diperbarui' : 'Staff berhasil ditambahkan'),
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