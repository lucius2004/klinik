// lib/providers/jadwal_provider.dart

import 'package:flutter/foundation.dart';
import '../models/jadwal_model.dart';

class JadwalProvider with ChangeNotifier {
  final List<JadwalModel> _jadwalList = [];
  String? _errorMessage;
  bool _isLoading = false;

  List<JadwalModel> get jadwalList => _jadwalList;
  List<JadwalModel> get activeJadwalList =>
      _jadwalList.where((j) => j.isActive).toList();
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  int get totalJadwal => _jadwalList.length;

  // Constructor tanpa dummy data
  JadwalProvider();

  JadwalModel? getJadwalById(String id) {
    try {
      return _jadwalList.firstWhere((j) => j.id == id);
    } catch (e) {
      return null;
    }
  }

  List<JadwalModel> getJadwalByDokter(String dokterId) {
    return _jadwalList.where((j) => j.dokterId == dokterId).toList();
  }

  List<JadwalModel> getJadwalByHari(String hari) {
    return _jadwalList.where((j) => j.hari == hari && j.isActive).toList();
  }

  List<JadwalModel> getJadwalByRuangan(String ruangan) {
    return _jadwalList.where((j) => j.ruangan == ruangan && j.isActive).toList();
  }

  List<String> getDokterList() {
    final dokterSet = <String>{};
    for (var jadwal in _jadwalList) {
      dokterSet.add(jadwal.dokterNama);
    }
    return dokterSet.toList()..sort();
  }

  List<String> getRuanganList() {
    final ruanganSet = <String>{};
    for (var jadwal in _jadwalList) {
      ruanganSet.add(jadwal.ruangan);
    }
    return ruanganSet.toList()..sort();
  }

  List<String> getHariList() {
    return [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu'
    ];
  }

  List<JadwalModel> searchJadwal(String query) {
    if (query.isEmpty) return activeJadwalList;

    final lowerQuery = query.toLowerCase();
    return activeJadwalList.where((jadwal) {
      return jadwal.dokterNama.toLowerCase().contains(lowerQuery) ||
          jadwal.spesialisasi.toLowerCase().contains(lowerQuery) ||
          jadwal.hari.toLowerCase().contains(lowerQuery) ||
          jadwal.ruangan.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  Map<String, dynamic> getStatistics() {
    final totalDokter = getDokterList().length;
    final totalRuangan = getRuanganList().length;
    final totalKuota = _jadwalList.fold<int>(
      0,
      (sum, j) => sum + (j.isActive ? j.kuotaPasien : 0),
    );

    // Group by hari
    final jadwalPerHari = <String, int>{};
    for (var hari in getHariList()) {
      jadwalPerHari[hari] = getJadwalByHari(hari).length;
    }

    return {
      'total': _jadwalList.length,
      'active': activeJadwalList.length,
      'totalDokter': totalDokter,
      'totalRuangan': totalRuangan,
      'totalKuota': totalKuota,
      'jadwalPerHari': jadwalPerHari,
    };
  }

  Future<bool> addJadwal(JadwalModel jadwal) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    try {
      // Check for conflicts
      final conflict = _checkJadwalConflict(jadwal);
      if (conflict != null) {
        _errorMessage = conflict;
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final newJadwal = jadwal.copyWith(
        id: 'JDW${(_jadwalList.length + 1).toString().padLeft(3, '0')}',
        createdAt: DateTime.now(),
      );

      _jadwalList.add(newJadwal);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateJadwal(JadwalModel jadwal) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    try {
      final index = _jadwalList.indexWhere((j) => j.id == jadwal.id);
      if (index == -1) {
        _errorMessage = 'Jadwal tidak ditemukan';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Check for conflicts (exclude current jadwal)
      final conflict = _checkJadwalConflict(jadwal, excludeId: jadwal.id);
      if (conflict != null) {
        _errorMessage = conflict;
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final updatedJadwal = jadwal.copyWith(
        updatedAt: DateTime.now(),
      );

      _jadwalList[index] = updatedJadwal;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteJadwal(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    try {
      _jadwalList.removeWhere((j) => j.id == id);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  String? _checkJadwalConflict(JadwalModel newJadwal, {String? excludeId}) {
    // Check if dokter already has schedule on the same day and time
    for (var jadwal in _jadwalList) {
      if (excludeId != null && jadwal.id == excludeId) continue;
      if (!jadwal.isActive) continue;

      // Same dokter, same day
      if (jadwal.dokterId == newJadwal.dokterId &&
          jadwal.hari == newJadwal.hari) {
        // Check time overlap
        if (_isTimeOverlap(
          jadwal.jamMulai,
          jadwal.jamSelesai,
          newJadwal.jamMulai,
          newJadwal.jamSelesai,
        )) {
          return 'Dokter sudah memiliki jadwal pada hari dan waktu yang sama';
        }
      }

      // Same room, same day, same time
      if (jadwal.ruangan == newJadwal.ruangan && jadwal.hari == newJadwal.hari) {
        if (_isTimeOverlap(
          jadwal.jamMulai,
          jadwal.jamSelesai,
          newJadwal.jamMulai,
          newJadwal.jamSelesai,
        )) {
          return 'Ruangan sudah digunakan pada hari dan waktu yang sama';
        }
      }
    }
    return null;
  }

  bool _isTimeOverlap(
      String start1, String end1, String start2, String end2) {
    final s1 = _timeToMinutes(start1);
    final e1 = _timeToMinutes(end1);
    final s2 = _timeToMinutes(start2);
    final e2 = _timeToMinutes(end2);

    return (s1 < e2 && e1 > s2);
  }

  int _timeToMinutes(String time) {
    final parts = time.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  Future<bool> toggleStatus(String id) async {
    final index = _jadwalList.indexWhere((j) => j.id == id);
    if (index == -1) return false;

    _jadwalList[index] = _jadwalList[index].copyWith(
      isActive: !_jadwalList[index].isActive,
      updatedAt: DateTime.now(),
    );
    notifyListeners();
    return true;
  }
}