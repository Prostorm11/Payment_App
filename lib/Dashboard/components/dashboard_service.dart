import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fee_payment_app/Dashboard/components/models.dart';
import 'package:fee_payment_app/SignIn/components/authService.dart';

class DashboardService {
  static const String baseUrl = 'YOUR_SERVER_URL'; // Replace with actual server URL
  
  static Future<DashboardResponse?> fetchDashboardData() async {
    try {
      final accessToken = await AuthService.getAccessToken();
      if (accessToken == null) {
        throw Exception('No access token found');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/students/dashboard'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return DashboardResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load dashboard data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching dashboard data: $e');
      return null;
    }
  }

  // Mock data for development/testing
  static DashboardResponse getMockData() {
    const mockJson = {
      "success": true,
      "data": {
        "student": {
          "_id": "689c45cf9d35ce12e7c921d3",
          "name": "Carter",
          "email": "kameyaw14@gmail.com",
          "studentId": "KNUST-001",
          "department": "Computer Science",
          "yearOfStudy": "Freshman",
          "courses": ["BUS301", "SCI201"]
        },
        "payments": [
          {
            "_id": "689cb871fe2857e919fda7c9",
            "amount": 1,
            "feeId": "689c78bfb8720a8949525ddd",
            "feeDetails": {
              "feeType": "Hostel",
              "academicSession": "2024/2025",
              "dueDate": "2025-08-27T00:00:00.000Z"
            },
            "paymentProvider": "Paystack",
            "status": "initiated",
            "createdAt": "2025-08-13T16:08:17.939Z"
          },
          {
            "_id": "689cc14f33ef9f7409fa3868",
            "amount": 1,
            "feeId": "689c46849d35ce12e7c92237",
            "feeDetails": {
              "feeType": "Tuition",
              "academicSession": "2024/2025",
              "dueDate": "2025-08-31T00:00:00.000Z"
            },
            "paymentProvider": "Paystack",
            "status": "initiated",
            "createdAt": "2025-08-13T16:46:08.309Z"
          }
        ],
        "receipts": [
          {
            "_id": "689cb874fe2857e919fda7ce",
            "receiptNumber": "REC-689cb871fe2857e919fda7c9-1755101300815",
            "amount": 1,
            "date": "2025-08-13T16:08:20.815Z",
            "pdfUrl": "https://res.cloudinary.com/dnn0adcqq/raw/upload/v1755101341/receipts/qpvradynsoork6bj2bee",
            "branding": {
              "primaryColor": "#1976D2"
            }
          }
        ]
      }
    };
    
    return DashboardResponse.fromJson(mockJson);
  }

  // Helper methods for data analysis
  static double getTotalPayments(List<Payment> payments) {
    return payments.fold(0.0, (sum, payment) => sum + payment.amount);
  }

  static Map<String, double> getPaymentsByFeeType(List<Payment> payments) {
    Map<String, double> feeTypeAmounts = {};
    for (var payment in payments) {
      final feeType = payment.feeDetails.feeType;
      feeTypeAmounts[feeType] = (feeTypeAmounts[feeType] ?? 0) + payment.amount;
    }
    return feeTypeAmounts;
  }

  static List<Payment> getRecentPayments(List<Payment> payments, {int limit = 5}) {
    final sortedPayments = List<Payment>.from(payments);
    sortedPayments.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sortedPayments.take(limit).toList();
  }

  static Payment? getLastPayment(List<Payment> payments) {
    if (payments.isEmpty) return null;
    return payments.reduce((a, b) => a.createdAt.isAfter(b.createdAt) ? a : b);
  }

  static DateTime? getNextDueDate(List<Payment> payments) {
    final now = DateTime.now();
    DateTime? nextDue;
    
    for (var payment in payments) {
      if (payment.feeDetails.dueDate.isAfter(now)) {
        if (nextDue == null || payment.feeDetails.dueDate.isBefore(nextDue)) {
          nextDue = payment.feeDetails.dueDate;
        }
      }
    }
    
    return nextDue;
  }
}