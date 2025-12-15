// lib/providers/staff_provider.dart

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/staff_model.dart';

class StaffProvider with ChangeNotifier {
  List<StaffModel> _staffList = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<StaffModel> get staffList => _staffList;
  List<StaffModel> get activeStaffList =>
      _staffList.where((s) => s.isActive).toList();
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get totalStaff => _staffList.where((s) => s.isActive).length;

  StaffProvider() {
    _loadStaff();
  }

  Future<void> _loadStaff() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final staffJson = prefs.getString('staff_list');

      if (staffJson != null) {
        final List<dynamic> staffData = json.decode(staffJson);
        _staffList = staffData.map((s) => StaffModel.fromMap(s)).toList();
      } else {
        // Tidak ada data dummy, mulai dengan list kosong
        _staffList = [];
        await _saveStaff();
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Gagal memuat data: $e';
      notifyListeners();
    }
  }

  Future<void> _saveStaff() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final staffJson = json.encode(_staffList.map((s) => s.toMap()).toList());
      await prefs.setString('staff_list', staffJson);
    } catch (e) {
      _errorMessage = 'Gagal menyimpan data: $e';
      notifyListeners();
    }
  }

  // CREATE
  Future<bool> addStaff(StaffModel staff) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Cek NIP duplikat
      if (_staffList.any((s) => s.nip == staff.nip && s.isActive)) {
        _errorMessage = 'NIP sudah terdaftar';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final newStaff = staff.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt: DateTime.now(),
      );

      _staffList.add(newStaff);
      await _saveStaff();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal menambah staff: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // READ
  StaffModel? getStaffById(String id) {
    try {
      return _staffList.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }

  List<StaffModel> searchStaff(String query) {
    if (query.isEmpty) return activeStaffList;

    return activeStaffList.where((s) {
      return s.nama.toLowerCase().contains(query.toLowerCase()) ||
          s.nip.toLowerCase().contains(query.toLowerCase()) ||
          s.posisi.toLowerCase().contains(query.toLowerCase()) ||
          s.noTelepon.contains(query);
    }).toList();
  }

  // UPDATE
  Future<bool> updateStaff(StaffModel staff) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Cek NIP duplikat (exclude current staff)
      if (_staffList
          .any((s) => s.nip == staff.nip && s.id != staff.id && s.isActive)) {
        _errorMessage = 'NIP sudah terdaftar';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final index = _staffList.indexWhere((s) => s.id == staff.id);
      if (index != -1) {
        _staffList[index] = staff.copyWith(updatedAt: DateTime.now());
        await _saveStaff();
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _errorMessage = 'Staff tidak ditemukan';
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
  Future<bool> deleteStaff(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final index = _staffList.indexWhere((s) => s.id == id);
      if (index != -1) {
        _staffList[index] = _staffList[index].copyWith(
          isActive: false,
          updatedAt: DateTime.now(),
        );
        await _saveStaff();
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _errorMessage = 'Staff tidak ditemukan';
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
  List<StaffModel> filterByPosisi(String posisi) {
    return activeStaffList.where((s) => s.posisi == posisi).toList();
  }

  List<StaffModel> filterByShift(String shift) {
    return activeStaffList.where((s) => s.shift == shift).toList();
  }

  List<StaffModel> filterByGender(String gender) {
    return activeStaffList.where((s) => s.jenisKelamin == gender).toList();
  }

  // STATISTICS
  Map<String, dynamic> getStatistics() {
    final posisiCount = <String, int>{};
    final shiftCount = <String, int>{};

    for (var staff in activeStaffList) {
      posisiCount[staff.posisi] = (posisiCount[staff.posisi] ?? 0) + 1;
      shiftCount[staff.shift] = (shiftCount[staff.shift] ?? 0) + 1;
    }

    return {
      'total': totalStaff,
      'laki': activeStaffList.where((s) => s.jenisKelamin == 'L').length,
      'perempuan': activeStaffList.where((s) => s.jenisKelamin == 'P').length,
      'posisi': posisiCount,
      'shift': shiftCount,
    };
  }

  List<String> getPosisiList() {
    return activeStaffList.map((s) => s.posisi).toSet().toList()..sort();
  }

  List<String> getShiftList() {
    return activeStaffList.map((s) => s.shift).toSet().toList()..sort();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}