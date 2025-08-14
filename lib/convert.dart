import 'dart:convert';
import 'package:fee_payment_app/SignIn/components/authService.dart';
import 'package:fee_payment_app/config.dart';
import 'package:http/http.dart' as http;

class AppData {
  // Singleton pattern
  AppData._privateConstructor();
  static final AppData instance = AppData._privateConstructor();

  Map<String, dynamic>? student;
  List<Map<String, dynamic>> payments = [];
  List<Map<String, dynamic>> receipts = [];

  final String baseUrl = backendUrl;

  Future<void> fetchDashboard() async {
    // Fetch the token here
    final String? accessToken = await AuthService.getToken();
    if (accessToken == null) {
      throw Exception("No access token found");
    }

    final response = await http.get(
      Uri.parse("$baseUrl/api/v1/students/dashboard"),
      headers: {"Authorization": "Bearer $accessToken"},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      student = data['student'];
      payments = List<Map<String, dynamic>>.from(data['payments']);
      receipts = List<Map<String, dynamic>>.from(data['receipts']);
    } else {
      throw Exception(
          "Failed to load dashboard data: ${response.statusCode}");
    }
  }
}
