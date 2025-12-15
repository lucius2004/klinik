// lib/providers/dokter_provider.dart

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/dokter_model.dart';

class DokterProvider with ChangeNotifier {
  List<DokterModel> _dokterList = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<DokterModel> get dokterList => _dokterList;
  List<DokterModel> get activeDokterList =>
      _dokterList.where((d) => d.isActive).toList();
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get totalDokter => _dokterList.where((d) => d.isActive).length;

  DokterProvider() {
    _loadDokter();
  }

  Future<void> _loadDokter() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dokterJson = prefs.getString('dokter_list');

      if (dokterJson != null) {
        final List<dynamic> dokterData = json.decode(dokterJson);
        _dokterList = dokterData.map((d) => DokterModel.fromMap(d)).toList();
      } else {
        // Tidak ada data dummy, mulai dengan list kosong
        _dokterList = [];
        await _saveDokter();
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Gagal memuat data: $e';
      notifyListeners();
    }
  }

  Future<void> _saveDokter() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dokterJson =
          json.encode(_dokterList.map((d) => d.toMap()).toList());
      await prefs.setString('dokter_list', dokterJson);
    } catch (e) {
      _errorMessage = 'Gagal menyimpan data: $e';
      notifyListeners();
    }
  }

  // CREATE
  Future<bool> addDokter(DokterModel dokter) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Cek NIP duplikat
      if (_dokterList.any((d) => d.nip == dokter.nip && d.isActive)) {
        _errorMessage = 'NIP sudah terdaftar';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Cek STR duplikat
      if (_dokterList.any((d) => d.noSTR == dokter.noSTR && d.isActive)) {
        _errorMessage = 'No. STR sudah terdaftar';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final newDokter = dokter.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt: DateTime.now(),
      );

      _dokterList.add(newDokter);
      await _saveDokter();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal menambah dokter: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // READ
  DokterModel? getDokterById(String id) {
    try {
      return _dokterList.firstWhere((d) => d.id == id);
    } catch (e) {
      return null;
    }
  }

  List<DokterModel> searchDokter(String query) {
    if (query.isEmpty) return activeDokterList;

    return activeDokterList.where((d) {
      return d.nama.toLowerCase().contains(query.toLowerCase()) ||
          d.nip.toLowerCase().contains(query.toLowerCase()) ||
          d.spesialisasi.toLowerCase().contains(query.toLowerCase()) ||
          d.noSTR.contains(query) ||
          d.noTelepon.contains(query);
    }).toList();
  }

  // UPDATE
  Future<bool> updateDokter(DokterModel dokter) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Cek NIP duplikat (exclude current dokter)
      if (_dokterList.any(
          (d) => d.nip == dokter.nip && d.id != dokter.id && d.isActive)) {
        _errorMessage = 'NIP sudah terdaftar';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Cek STR duplikat
      if (_dokterList.any(
          (d) => d.noSTR == dokter.noSTR && d.id != dokter.id && d.isActive)) {
        _errorMessage = 'No. STR sudah terdaftar';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final index = _dokterList.indexWhere((d) => d.id == dokter.id);
      if (index != -1) {
        _dokterList[index] = dokter.copyWith(updatedAt: DateTime.now());
        await _saveDokter();
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _errorMessage = 'Dokter tidak ditemukan';
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

  // DELETE
  Future<bool> deleteDokter(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final index = _dokterList.indexWhere((d) => d.id == id);
      if (index != -1) {
        _dokterList[index] = _dokterList[index].copyWith(
          isActive: false,
          updatedAt: DateTime.now(),
        );
        await _saveDokter();
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _errorMessage = 'Dokter tidak ditemukan';
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

  // FILTER
  List<DokterModel> filterBySpesialisasi(String spesialisasi) {
    return activeDokterList
        .where((d) => d.spesialisasi == spesialisasi)
        .toList();
  }

  List<DokterModel> filterByGender(String gender) {
    return activeDokterList.where((d) => d.jenisKelamin == gender).toList();
  }

  // STATISTICS
  Map<String, dynamic> getStatistics() {
    final spesialisasiCount = <String, int>{};
    for (var dokter in activeDokterList) {
      spesialisasiCount[dokter.spesialisasi] =
          (spesialisasiCount[dokter.spesialisasi] ?? 0) + 1;
    }

    return {
      'total': totalDokter,
      'laki': activeDokterList.where((d) => d.jenisKelamin == 'L').length,
      'perempuan': activeDokterList.where((d) => d.jenisKelamin == 'P').length,
      'spesialisasi': spesialisasiCount,
    };
  }

  List<String> getSpesialisasiList() {
    return activeDokterList
        .map((d) => d.spesialisasi)
        .toSet()
        .toList()
      ..sort();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}