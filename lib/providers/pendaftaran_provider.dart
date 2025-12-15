// lib/providers/pendaftaran_provider.dart

import 'package:flutter/foundation.dart';
import '../models/pendaftaran_model.dart';
import 'package:intl/intl.dart';

class PendaftaranProvider with ChangeNotifier {
  final List<PendaftaranModel> _pendaftaranList = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<PendaftaranModel> get pendaftaranList => _pendaftaranList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Get pendaftaran hari ini
  List<PendaftaranModel> get pendaftaranHariIni {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return _pendaftaranList
        .where((p) => p.tanggalDaftar == today)
        .toList()
      ..sort((a, b) => a.noAntrean.compareTo(b.noAntrean));
  }

  // Get pendaftaran by status
  List<PendaftaranModel> getPendaftaranByStatus(String status) {
    return _pendaftaranList.where((p) => p.status == status).toList();
  }

  // Get antrean menunggu hari ini
  List<PendaftaranModel> get antreanMenunggu {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return _pendaftaranList
        .where((p) => 
            p.tanggalDaftar == today && 
            (p.status == 'menunggu' || p.status == 'dipanggil'))
        .toList()
      ..sort((a, b) => a.noAntrean.compareTo(b.noAntrean));
  }

  // Get next antrean number
  int getNextAntreanNumber(String tanggal) {
    final pendaftaranTanggal = _pendaftaranList
        .where((p) => p.tanggalDaftar == tanggal)
        .toList();
    
    if (pendaftaranTanggal.isEmpty) return 1;
    
    final maxAntrean = pendaftaranTanggal
        .map((p) => p.noAntrean)
        .reduce((a, b) => a > b ? a : b);
    
    return maxAntrean + 1;
  }

  // Generate nomor pendaftaran
  String generateNoPendaftaran() {
    final now = DateTime.now();
    final prefix = 'REG';
    final date = DateFormat('yyyyMMdd').format(now);
    final sequence = (_pendaftaranList.length + 1).toString().padLeft(4, '0');
    return '$prefix-$date-$sequence';
  }

  // Tambah pendaftaran
  Future<bool> addPendaftaran(PendaftaranModel pendaftaran) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Simulasi API call
      await Future.delayed(const Duration(seconds: 1));

      _pendaftaranList.add(pendaftaran);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal menambah pendaftaran: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update status pendaftaran
  Future<bool> updateStatus(String id, String newStatus) async {
    try {
      _isLoading = true;
      notifyListeners();

      await Future.delayed(const Duration(milliseconds: 500));

      final index = _pendaftaranList.indexWhere((p) => p.id == id);
      if (index != -1) {
        _pendaftaranList[index] = _pendaftaranList[index].copyWith(
          status: newStatus,
        );
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Gagal update status: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Get pendaftaran by ID
  PendaftaranModel? getPendaftaranById(String id) {
    try {
      return _pendaftaranList.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  // Search pendaftaran
  List<PendaftaranModel> searchPendaftaran(String query) {
    final lowerQuery = query.toLowerCase();
    return _pendaftaranList.where((p) {
      return p.pasienNama.toLowerCase().contains(lowerQuery) ||
          p.pasienNoRm.toLowerCase().contains(lowerQuery) ||
          p.dokterNama.toLowerCase().contains(lowerQuery) ||
          p.noPendaftaran.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // Get statistics
  Map<String, dynamic> getStatistics() {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final todayPendaftaran = _pendaftaranList
        .where((p) => p.tanggalDaftar == today)
        .toList();

    return {
      'total': todayPendaftaran.length,
      'menunggu': todayPendaftaran.where((p) => p.status == 'menunggu').length,
      'dipanggil': todayPendaftaran.where((p) => p.status == 'dipanggil').length,
      'selesai': todayPendaftaran.where((p) => p.status == 'selesai').length,
      'batal': todayPendaftaran.where((p) => p.status == 'batal').length,
    };
  }
}