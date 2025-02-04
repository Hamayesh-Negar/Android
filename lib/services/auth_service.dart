import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../exceptions/auth_exception.dart';
import 'api_client.dart';

class AuthService extends ChangeNotifier {
  final ApiClient _apiClient;

  AuthService(this._apiClient);

  Future<void> login(String email, String password) async {
    try {
      final response = await _apiClient.post('/auth/login/', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final token = response.data['token'];
        _apiClient.setToken(token);
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

  Future<Map<String, dynamic>> logout() async {
    final response = await _apiClient.post('/auth/logout/', data: {
      'Authorization': 'Token ${_apiClient.getToken()}',
    });

    if (response.statusCode == 200) {
      return response.data;
    }
    throw Exception('Logout failed');
  }
}
