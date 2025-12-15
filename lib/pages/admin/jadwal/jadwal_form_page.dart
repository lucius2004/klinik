// lib/pages/admin/jadwal/jadwal_form_page.dart
// DESAIN MEDICAL THEME - Minimalist dengan Animasi & Warna Medical

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../providers/jadwal_provider.dart';
import '../../../providers/dokter_provider.dart';
import '../../../models/jadwal_model.dart';

class JadwalFormPage extends StatefulWidget {
  final JadwalModel? jadwal;
  const JadwalFormPage({super.key, this.jadwal});

  @override
  State<JadwalFormPage> createState() => _JadwalFormPageState();
}

class _JadwalFormPageState extends State<JadwalFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _keteranganController = TextEditingController();
  final _kuotaController = TextEditingController();

  String? _selectedDokterId;
  String _selectedDokterNama = '';
  String _selectedSpesialisasi = '';
  String _selectedHari = 'Senin';
  TimeOfDay _jamMulai = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _jamSelesai = const TimeOfDay(hour: 12, minute: 0);
  String _selectedRuangan = 'Ruang 101';
  bool _isLoading = false;

  final List<String> _hariList = [
    'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'
  ];

  final List<String> _ruanganList = [
    'Ruang 101', 'Ruang 102', 'Ruang 103', 'Ruang 104',
    'Ruang Gigi', 'Ruang IGD', 'Ruang Lab', 'Ruang Radiologi',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.jadwal != null) {
      _loadJadwalData();
    } else {
      _kuotaController.text = '20';
    }
  }

  void _loadJadwalData() {
    final jadwal = widget.jadwal!;
    _selectedDokterId = jadwal.dokterId;
    _selectedDokterNama = jadwal.dokterNama;
    _selectedSpesialisasi = jadwal.spesialisasi;
    _selectedHari = jadwal.hari;
    _selectedRuangan = jadwal.ruangan;
    _kuotaController.text = jadwal.kuotaPasien.toString();
    _keteranganController.text = jadwal.keterangan ?? '';

    final mulaiParts = jadwal.jamMulai.split(':');
    _jamMulai = TimeOfDay(
      hour: int.parse(mulaiParts[0]),
      minute: int.parse(mulaiParts[1]),
    );

    final selesaiParts = jadwal.jamSelesai.split(':');
    _jamSelesai = TimeOfDay(
      hour: int.parse(selesaiParts[0]),
      minute: int.parse(selesaiParts[1]),
    );
  }

  @override
  void dispose() {
    _keteranganController.dispose();
    _kuotaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.jadwal != null;
    final dokterProvider = Provider.of<DokterProvider>(context);
    final dokterList = dokterProvider.activeDokterList;

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
                          isEdit ? 'Edit Jadwal' : 'Tambah Jadwal',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF0F172A), letterSpacing: -0.5),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isEdit ? 'Perbarui jadwal praktik' : 'Tambahkan jadwal baru',
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
                    _buildSectionTitle('PILIH DOKTER', Icons.person),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _selectedDokterId,
                      decoration: _inputDecoration('Dokter *', Icons.person, hint: 'Pilih Dokter'),
                      hint: const Text('Pilih Dokter'),
                      style: const TextStyle(fontSize: 14, color: Color(0xFF0F172A)),
                      items: dokterList.map((dokter) {
                        return DropdownMenuItem(
                          value: dokter.id,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(dokter.nama, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                              Text(dokter.spesialisasi, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        final dokter = dokterList.firstWhere((d) => d.id == value);
                        setState(() {
                          _selectedDokterId = value;
                          _selectedDokterNama = dokter.nama;
                          _selectedSpesialisasi = dokter.spesialisasi;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Dokter wajib dipilih';
                        return null;
                      },
                    ),

                    if (_selectedDokterId != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0EA5E9).withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF0EA5E9).withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: const Color(0xFF0EA5E9),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  _selectedDokterNama[0].toUpperCase(),
                                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(_selectedDokterNama, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Color(0xFF0F172A))),
                                  const SizedBox(height: 2),
                                  Text(_selectedSpesialisasi, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),
                    _buildSectionTitle('JADWAL PRAKTIK', Icons.schedule),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _selectedHari,
                      decoration: _inputDecoration('Hari Praktik *', Icons.calendar_today),
                      style: const TextStyle(fontSize: 14, color: Color(0xFF0F172A)),
                      items: _hariList.map((hari) => DropdownMenuItem(value: hari, child: Text(hari))).toList(),
                      onChanged: (value) => setState(() => _selectedHari = value!),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => _selectTime(context, true),
                            borderRadius: BorderRadius.circular(12),
                            child: InputDecorator(
                              decoration: _inputDecoration('Jam Mulai *', Icons.access_time),
                              child: Text(_formatTime(_jamMulai), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: () => _selectTime(context, false),
                            borderRadius: BorderRadius.circular(12),
                            child: InputDecorator(
                              decoration: _inputDecoration('Jam Selesai *', Icons.access_time_filled),
                              child: Text(_formatTime(_jamSelesai), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF3B82F6).withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, size: 18, color: Color(0xFF3B82F6)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Durasi praktik: ${_calculateDuration()}',
                              style: const TextStyle(fontSize: 13, color: Color(0xFF3B82F6), fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    _buildSectionTitle('RUANGAN & KUOTA', Icons.meeting_room),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _selectedRuangan,
                      decoration: _inputDecoration('Ruangan *', Icons.meeting_room),
                      style: const TextStyle(fontSize: 14, color: Color(0xFF0F172A)),
                      items: _ruanganList.map((ruangan) => DropdownMenuItem(value: ruangan, child: Text(ruangan))).toList(),
                      onChanged: (value) => setState(() => _selectedRuangan = value!),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _kuotaController,
                      decoration: _inputDecoration('Kuota Pasien *', Icons.people, hint: '20', suffix: 'pasien'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: const TextStyle(fontSize: 14),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Kuota wajib diisi';
                        final kuota = int.tryParse(value);
                        if (kuota == null || kuota <= 0) return 'Kuota harus lebih dari 0';
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),
                    _buildSectionTitle('KETERANGAN', Icons.notes),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _keteranganController,
                      decoration: _inputDecoration('Keterangan', Icons.notes, hint: 'Keterangan tambahan (opsional)'),
                      maxLines: 3,
                      textCapitalization: TextCapitalization.sentences,
                      style: const TextStyle(fontSize: 14),
                    ),
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
                            : Text(isEdit ? 'SIMPAN PERUBAHAN' : 'TAMBAH JADWAL', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, letterSpacing: 0.5)),
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

  InputDecoration _inputDecoration(String label, IconData icon, {String? hint, String? suffix}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
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

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _jamMulai : _jamSelesai,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF0EA5E9)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _jamMulai = picked;
          if (_timeToMinutes(_jamMulai) >= _timeToMinutes(_jamSelesai)) {
            _jamSelesai = TimeOfDay(hour: (_jamMulai.hour + 4) % 24, minute: _jamMulai.minute);
          }
        } else {
          _jamSelesai = picked;
        }
      });
    }
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  int _timeToMinutes(TimeOfDay time) => time.hour * 60 + time.minute;

  String _calculateDuration() {
    final start = _timeToMinutes(_jamMulai);
    final end = _timeToMinutes(_jamSelesai);
    final diff = end - start;

    if (diff <= 0) return 'Waktu tidak valid';

    final hours = diff ~/ 60;
    final minutes = diff % 60;

    if (hours > 0 && minutes > 0) {
      return '$hours jam $minutes menit';
    } else if (hours > 0) {
      return '$hours jam';
    } else {
      return '$minutes menit';
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDokterId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih dokter terlebih dahulu'),
          backgroundColor: Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_timeToMinutes(_jamMulai) >= _timeToMinutes(_jamSelesai)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Jam selesai harus lebih besar dari jam mulai'),
          backgroundColor: Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final provider = Provider.of<JadwalProvider>(context, listen: false);
    final isEdit = widget.jadwal != null;

    final jadwal = JadwalModel(
      id: isEdit ? widget.jadwal!.id : '',
      dokterId: _selectedDokterId!,
      dokterNama: _selectedDokterNama,
      spesialisasi: _selectedSpesialisasi,
      hari: _selectedHari,
      jamMulai: _formatTime(_jamMulai),
      jamSelesai: _formatTime(_jamSelesai),
      ruangan: _selectedRuangan,
      kuotaPasien: int.parse(_kuotaController.text),
      keterangan: _keteranganController.text.trim().isEmpty ? null : _keteranganController.text.trim(),
      createdAt: isEdit ? widget.jadwal!.createdAt : null,
    );

    bool success = isEdit ? await provider.updateJadwal(jadwal) : await provider.addJadwal(jadwal);

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEdit ? 'Jadwal berhasil diperbarui' : 'Jadwal berhasil ditambahkan'),
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