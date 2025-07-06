import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  static const String baseUrl = 'http://192.168.0.103:8080/api';

  /// Sends login data to the backend and stores the JWT token if successful.
  Future<void> postLoginInformation(Map<String, dynamic> loginData) async {
    final url = Uri.parse('$baseUrl/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(loginData),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data.containsKey('token')) {
          final token = data['token'];

          // Save the token in shared preferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwt-token', token);

          print('Token saved: $token');
        } else {
          throw Exception('Token not found in response');
        }
      } else {
        throw Exception(
            'Failed to login: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      // Log and rethrow the error
      print('Login error: $e');
      rethrow;
    }
  }
}
