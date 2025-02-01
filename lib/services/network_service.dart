import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'api_client.dart';

class NetworkService extends ChangeNotifier {
  bool _isConnected = false;
  bool _isServerReachable = false;
  final ApiClient _apiClient = ApiClient();

  bool get isConnected => _isConnected;

  bool get isServerReachable => _isServerReachable;

  Future<bool> checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    _isConnected = connectivityResult != ConnectivityResult.none;
    notifyListeners();
    return _isConnected;
  }

  Future<bool> checkServer() async {
    if (!_isConnected) return false;

    try {
      final response = await _apiClient.get('/health/');
      _isServerReachable = response.statusCode == 200;
    } catch (e) {
      _isServerReachable = false;
    }
    notifyListeners();
    return _isServerReachable;
  }
}
