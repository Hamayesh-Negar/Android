import 'api_client.dart';

class ConferenceService {
  final ApiClient _apiClient;

  ConferenceService(this._apiClient);

  Future<List<dynamic>> getActiveConferences() async {
    final response = await _apiClient.get('/conferences/');
    return response.data;
  }

  Future<Map<String, dynamic>> getConferenceDetails(String slug) async {
    final response = await _apiClient.get('/conferences/$slug/');
    return response.data;
  }

  Future<List<dynamic>> getConferenceCategories(String slug) async {
    final response = await _apiClient.get('/conferences/$slug/categories/');
    return response.data;
  }
}
