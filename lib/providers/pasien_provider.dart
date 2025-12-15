// lib/providers/pasien_provider.dart

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/pasien_model.dart';

class PasienProvider with ChangeNotifier {
  List<PasienModel> _pasienList = [];
  bool _isLoading = false;
  String? _errorMessage;
  int _lastNoRM = 0;

  List<PasienModel> get pasienList => _pasienList;
  List<PasienModel> get activePasienList =>
      _pasienList.where((p) => p.isActive).toList();
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get totalPasien => _pasienList.where((p) => p.isActive).length;

  PasienProvider() {
    _loadPasien();
  }

  // Load data dari SharedPreferences
  Future<void> _loadPasien() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pasienJson = prefs.getString('pasien_list');

      if (pasienJson != null) {
        final List<dynamic> pasienData = json.decode(pasienJson);
        _pasienList = pasienData.map((p) => PasienModel.fromMap(p)).toList();

        // Update lastNoRM
        if (_pasienList.isNotEmpty) {
          _lastNoRM = _pasienList
              .map((p) => int.tryParse(p.noRM.split('-').last) ?? 0)
              .reduce((a, b) => a > b ? a : b);
        }
      } else {
        // Tidak ada data dummy, mulai dengan list kosong
        _pasienList = [];
        await _savePasien();
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Gagal memuat data: $e';
      notifyListeners();
    }
  }

  // Save data ke SharedPreferences
  Future<void> _savePasien() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pasienJson =
          json.encode(_pasienList.map((p) => p.toMap()).toList());
      await prefs.setString('pasien_list', pasienJson);
    } catch (e) {
      _errorMessage = 'Gagal menyimpan data: $e';
      notifyListeners();
    }
  }

  // Generate No RM otomatis
  String _generateNoRM() {
    _lastNoRM++;
    final now = DateTime.now();
    final year = now.year.toString();
    final month = now.month.toString().padLeft(2, '0');
    return 'RM-$year$month-${_lastNoRM.toString().padLeft(4, '0')}';
  }

  // CREATE - Tambah pasien baru
  Future<bool> addPasien(PasienModel pasien) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Cek NIK duplikat
      if (_pasienList.any((p) => p.nik == pasien.nik && p.isActive)) {
        _errorMessage = 'NIK sudah terdaftar';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Generate No RM otomatis
      final noRM = _generateNoRM();

      final newPasien = pasien.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        noRM: noRM,
        createdAt: DateTime.now(),
      );

      _pasienList.add(newPasien);
      await _savePasien();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal menambah pasien: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // READ - Get pasien by ID
  PasienModel? getPasienById(String id) {
    try {
      return _pasienList.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  // READ - Get pasien by No RM
  PasienModel? getPasienByNoRM(String noRM) {
    try {
      return _pasienList.firstWhere((p) => p.noRM == noRM);
    } catch (e) {
      return null;
    }
  }

  // READ - Search pasien
  List<PasienModel> searchPasien(String query) {
    if (query.isEmpty) return activePasienList;

    return activePasienList.where((p) {
      return p.nama.toLowerCase().contains(query.toLowerCase()) ||
          p.noRM.toLowerCase().contains(query.toLowerCase()) ||
          p.nik.contains(query) ||
          p.noTelepon.contains(query);
    }).toList();
  }

  // UPDATE - Edit pasien
  Future<bool> updatePasien(PasienModel pasien) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Cek NIK duplikat (exclude current pasien)
      if (_pasienList.any(
          (p) => p.nik == pasien.nik && p.id != pasien.id && p.isActive)) {
        _errorMessage = 'NIK sudah terdaftar';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final index = _pasienList.indexWhere((p) => p.id == pasien.id);
      if (index != -1) {
        _pasienList[index] = pasien.copyWith(updatedAt: DateTime.now());
        await _savePasien();
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _errorMessage = 'Pasien tidak ditemukan';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Gagal mengubah data: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // DELETE - Soft delete pasien
  Future<bool> deletePasien(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final index = _pasienList.indexWhere((p) => p.id == id);
      if (index != -1) {
        _pasienList[index] = _pasienList[index].copyWith(
          isActive: false,
          updatedAt: DateTime.now(),
        );
        await _savePasien();
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _errorMessage = 'Pasien tidak ditemukan';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Gagal menghapus data: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // RESTORE - Aktifkan kembali pasien
  Future<bool> restorePasien(String id) async {
    try {
      final index = _pasienList.indexWhere((p) => p.id == id);
      if (index != -1) {
        _pasienList[index] = _pasienList[index].copyWith(
          isActive: true,
          updatedAt: DateTime.now(),
        );
        await _savePasien();
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // FILTER - By jenis kelamin
  List<PasienModel> filterByGender(String gender) {
    return activePasienList.where((p) => p.jenisKelamin == gender).toList();
  }

  // FILTER - By asuransi
  List<PasienModel> filterByAsuransi(String asuransi) {
    return activePasienList.where((p) => p.asuransi == asuransi).toList();
  }

  // STATISTICS
  Map<String, int> getStatistics() {
    return {
      'total': totalPasien,
      'laki': activePasienList.where((p) => p.jenisKelamin == 'L').length,
      'perempuan': activePasienList.where((p) => p.jenisKelamin == 'P').length,
      'bpjs': activePasienList.where((p) => p.asuransi == 'BPJS').length,
      'umum': activePasienList.where((p) => p.asuransi == 'Umum').length,
    };
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}