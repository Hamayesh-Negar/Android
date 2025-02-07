import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hamayesh_negar_android/services/storage_service.dart';

import '../exceptions/auth_exception.dart';
import '../models/user.dart';
import 'api_client.dart';

class AuthService extends ChangeNotifier {
  final ApiClient _apiClient;
  final StorageService _storage;
  String? _token;
  User? _currentUser;

  AuthService(this._apiClient, this._storage);

  User? get currentUser => _currentUser;

  bool get isLoggedIn => _currentUser != null;

  String? get token => _token;

  Future<void> login(String email, String password) async {
    try {
      final response = await _apiClient.post('/auth/login/', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        _token = response.data['token'];
        _apiClient.setToken(_token);
        final userData = response.data['user'];
        _currentUser = User.fromJson(userData);
        notifyListeners();
      } else {
        throw HttpException('Login failed');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw AuthException('Invalid email or password');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw AuthException('Connection timeout. Please try again.');
      } else {
        throw AuthException('An error occurred. Please try again.');
      }
    } catch (e) {
      throw AuthException('An unexpected error occurred');
    }
  }

  Future<void> logout() async {
    try {
      await _apiClient.post('/auth/logout/');
    } catch (e) {
      // Ignore logout errors
    } finally {
      _apiClient.setToken(null);
      await _storage.clearLoginData();
      _currentUser = null;
      notifyListeners();
    }
  }

  Future<bool> tryAutoLogin() async {
    final token = _storage.getToken();
    if (token == null) return false;

    try {
      _apiClient.setToken(token);
      final response = await _apiClient.get('/api/v1/user/users/me/');
      _currentUser = User.fromJson(response.data);
      notifyListeners();
      return true;
    } catch (e) {
      _apiClient.setToken(null);
      await _storage.clearLoginData();
      return false;
    }
  }
}
