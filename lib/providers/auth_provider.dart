// lib/providers/auth_provider.dart

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _currentUser;
  List<UserModel> _users = [];
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  List<UserModel> get users => _users;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _currentUser != null;

  AuthProvider() {
    _loadUsers();
    _loadCurrentUser();
  }

  Future<void> _loadUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString('users');
      
      if (usersJson != null) {
        final List<dynamic> usersList = json.decode(usersJson);
        _users = usersList.map((user) => UserModel.fromMap(user)).toList();
      } else {
        _users = [
          UserModel(
            id: '1',
            username: 'admin',
            password: 'admin123',
            nama: 'Administrator',
            email: 'admin@klinik.com',
            role: 'admin',
          ),
          UserModel(
            id: '2',
            username: 'staff',
            password: 'staff123',
            nama: 'Staff Klinik',
            email: 'staff@klinik.com',
            role: 'staff',
          ),
          UserModel(
            id: '3',
            username: 'user',
            password: 'user123',
            nama: 'Pasien Demo',
            email: 'user@klinik.com',
            role: 'user',
          ),
        ];
        await _saveUsers();
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Gagal memuat data: $e';
      notifyListeners();
    }
  }

  Future<void> _saveUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = json.encode(_users.map((u) => u.toMap()).toList());
      await prefs.setString('users', usersJson);
    } catch (e) {
      _errorMessage = 'Gagal menyimpan: $e';
      notifyListeners();
    }
  }

  Future<void> _loadCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('currentUser');
      
      if (userJson != null) {
        _currentUser = UserModel.fromMap(json.decode(userJson));
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Gagal memuat sesi: $e';
      notifyListeners();
    }
  }

  Future<void> _saveCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_currentUser != null) {
        await prefs.setString('currentUser', json.encode(_currentUser!.toMap()));
      }
    } catch (e) {
      _errorMessage = 'Gagal menyimpan sesi: $e';
      notifyListeners();
    }
  }

  Future<bool> register({
    required String username,
    required String password,
    required String nama,
    required String email,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_users.any((u) => u.username.toLowerCase() == username.toLowerCase())) {
        _errorMessage = 'Username sudah digunakan';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (_users.any((u) => u.email.toLowerCase() == email.toLowerCase())) {
        _errorMessage = 'Email sudah terdaftar';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final newUser = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        username: username,
        password: password,
        nama: nama,
        email: email,
        role: 'user',
      );

      _users.add(newUser);
      await _saveUsers();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal mendaftar: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final user = _users.firstWhere(
        (u) => u.username == username && u.password == password,
        orElse: () => UserModel(
          id: '',
          username: '',
          password: '',
          nama: '',
          email: '',
        ),
      );

      if (user.id.isEmpty) {
        _errorMessage = 'Username atau password salah';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _currentUser = user;
      await _saveCurrentUser();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal login: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('currentUser');
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Gagal logout: $e';
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}