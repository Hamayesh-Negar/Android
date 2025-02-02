import 'api_client.dart';

class AuthService {
  final ApiClient _apiClient;

  AuthService(this._apiClient);

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _apiClient.post('/auth/login/', data: {
      'email': email,
      'password': password,
    });

    if (response.statusCode == 200) {
      final token = response.data['token'];
      _apiClient.setToken(token);
      return response.data;
    }
    throw Exception('Login failed');
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
