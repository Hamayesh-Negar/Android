import 'api_client.dart';

class PersonService {
  final ApiClient _apiClient;

  PersonService(this._apiClient);

  Future<List<dynamic>> getAllPersons() async {
    final response = await _apiClient.get('/conferences/persons/');
    return response.data;
  }

  Future<Map<String, dynamic>> getPersonByQR(String hashedCode) async {
    final response = await _apiClient
        .get('/persons/', queryParameters: {'hashed_unique_code': hashedCode});
    return response.data[0];
  }

  Future<List<dynamic>> getPersonTasks(String personId) async {
    final response = await _apiClient.get('/persons/$personId/tasks/');
    return response.data;
  }

  Future<Map<String, dynamic>> markTaskCompleted(String personTaskId) async {
    final response =
        await _apiClient.post('/person_tasks/$personTaskId/mark_completed/');
    return response.data;
  }
}
