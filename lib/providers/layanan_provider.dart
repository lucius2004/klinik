// lib/providers/layanan_provider.dart

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/layanan_model.dart';

class LayananProvider with ChangeNotifier {
  List<LayananModel> _layananList = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<LayananModel> get layananList => _layananList;
  List<LayananModel> get activeLayananList =>
      _layananList.where((l) => l.isActive).toList();
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get totalLayanan => _layananList.where((l) => l.isActive).length;

  LayananProvider() {
    _loadLayanan();
  }

  Future<void> _loadLayanan() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final layananJson = prefs.getString('layanan_list');

      if (layananJson != null) {
        final List<dynamic> layananData = json.decode(layananJson);
        _layananList =
            layananData.map((l) => LayananModel.fromMap(l)).toList();
      } else {
        // Tidak ada data dummy, mulai dengan list kosong
        _layananList = [];
        await _saveLayanan();
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Gagal memuat data: $e';
      notifyListeners();
    }
  }

  Future<void> _saveLayanan() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final layananJson =
          json.encode(_layananList.map((l) => l.toMap()).toList());
      await prefs.setString('layanan_list', layananJson);
    } catch (e) {
      _errorMessage = 'Gagal menyimpan data: $e';
      notifyListeners();
    }
  }

  // CREATE
  Future<bool> addLayanan(LayananModel layanan) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Cek kode duplikat
      if (_layananList.any((l) => l.kode == layanan.kode && l.isActive)) {
        _errorMessage = 'Kode layanan sudah terdaftar';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final newLayanan = layanan.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt: DateTime.now(),
      );

      _layananList.add(newLayanan);
      await _saveLayanan();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal menambah layanan: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // READ
  LayananModel? getLayananById(String id) {
    try {
      return _layananList.firstWhere((l) => l.id == id);
    } catch (e) {
      return null;
    }
  }

  List<LayananModel> searchLayanan(String query) {
    if (query.isEmpty) return activeLayananList;

    return activeLayananList.where((l) {
      return l.nama.toLowerCase().contains(query.toLowerCase()) ||
          l.kode.toLowerCase().contains(query.toLowerCase()) ||
          l.kategori.toLowerCase().contains(query.toLowerCase()) ||
          l.unitPelayanan.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // UPDATE
  Future<bool> updateLayanan(LayananModel layanan) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Cek kode duplikat (exclude current layanan)
      if (_layananList.any((l) =>
          l.kode == layanan.kode && l.id != layanan.id && l.isActive)) {
        _errorMessage = 'Kode layanan sudah terdaftar';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final index = _layananList.indexWhere((l) => l.id == layanan.id);
      if (index != -1) {
        _layananList[index] = layanan.copyWith(updatedAt: DateTime.now());
        await _saveLayanan();
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _errorMessage = 'Layanan tidak ditemukan';
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
  Future<bool> deleteLayanan(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final index = _layananList.indexWhere((l) => l.id == id);
      if (index != -1) {
        _layananList[index] = _layananList[index].copyWith(
          isActive: false,
          updatedAt: DateTime.now(),
        );
        await _saveLayanan();
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _errorMessage = 'Layanan tidak ditemukan';
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
  List<LayananModel> filterByKategori(String kategori) {
    return activeLayananList.where((l) => l.kategori == kategori).toList();
  }

  List<LayananModel> filterByUnit(String unit) {
    return activeLayananList.where((l) => l.unitPelayanan == unit).toList();
  }

  List<LayananModel> filterByTarif(double min, double max) {
    return activeLayananList
        .where((l) => l.tarif >= min && l.tarif <= max)
        .toList();
  }

  // STATISTICS
  Map<String, dynamic> getStatistics() {
    final kategoriCount = <String, int>{};
    final unitCount = <String, int>{};
    double totalTarif = 0;

    for (var layanan in activeLayananList) {
      kategoriCount[layanan.kategori] =
          (kategoriCount[layanan.kategori] ?? 0) + 1;
      unitCount[layanan.unitPelayanan] =
          (unitCount[layanan.unitPelayanan] ?? 0) + 1;
      totalTarif += layanan.tarif;
    }

    return {
      'total': totalLayanan,
      'kategori': kategoriCount,
      'unit': unitCount,
      'totalTarif': totalTarif,
      'rataRataTarif': totalLayanan > 0 ? totalTarif / totalLayanan : 0,
    };
  }

  List<String> getKategoriList() {
    return activeLayananList.map((l) => l.kategori).toSet().toList()..sort();
  }

  List<String> getUnitList() {
    return activeLayananList.map((l) => l.unitPelayanan).toSet().toList()
      ..sort();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}