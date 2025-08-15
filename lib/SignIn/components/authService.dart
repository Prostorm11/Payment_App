import 'dart:convert';
import 'package:fee_payment_app/comfig.dart';
 // contains backendUrl
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String tokenKey = "auth_token";

  // Login and save token
  static Future<bool> login(String email, String password) async {
    final url = Uri.parse("$backendUrl/api/v1/students/login");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // This depends on backend's JSON response structure
        final token = data["accessToken"] ?? data["token"]; 

        if (token != null && token.isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(tokenKey, token);
          return true;
        }
      } else {
        print("Login failed: ${response.body}");
      }
    } catch (e) {
      print("Error during login: $e");
    }

    return false;
  }

  // Get saved token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  // Check login status
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
  }
}
