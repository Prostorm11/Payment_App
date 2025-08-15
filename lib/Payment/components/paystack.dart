import 'dart:convert';

import 'package:fee_payment_app/SignIn/components/authService.dart';
import 'package:fee_payment_app/comfig.dart';

import 'package:flutter/material.dart';
import 'package:pay_with_paystack/pay_with_paystack.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

void Paystack(BuildContext context,uniqueTransRef,String email,double amount){
  PayWithPayStack().now(
    context: context,
    secretKey:
        paystackPublicKey,
    customerEmail: email,
    reference: uniqueTransRef,
    currency: "GHS",
    amount: amount,
    callbackUrl: "https://google.com",
    transactionCompleted: (paymentData) {
      debugPrint(paymentData.toString());
    },
    transactionNotCompleted: (reason) {
      debugPrint("==> Transaction failed reason $reason");
});
}

void startPaystackPayment(BuildContext context, String email, double amountCedi) {
  PayWithPayStack().now(
    context: context,
    secretKey: paystackPublicKey,
    callbackUrl: ("$backendUrl/api/v1/payment"),
    customerEmail: email,
    reference: "txn_${DateTime.now().millisecondsSinceEpoch}",
    currency: "NGN",
    amount: amountCedi,
    transactionCompleted: (transaction) {
      if (transaction.status == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Payment successful! Ref: ${transaction.reference}")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Payment failed.")),
        );
      }
    },
    transactionNotCompleted: (transaction) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment unsuccessful.")),
      );
    }, 
    

  );
}

  /* Future<void> initializePayment(String feeId, int amount,BuildContext context) async {
    String? token=await AuthService.getToken();
    try {
      final response = await http.post(
        Uri.parse("$backendUrl/api/v1/payment/initialize"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'feeId': feeId,
          'amount': amount,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Instead of launching browser, open Paystack inside app
        final payResponse = await PayWithPayStack().now(

          context: context,
          secretKey: "sk_test_xxxxxxxxxxxxxxxxxxx", // Your Paystack secret key
          customerEmail: data['email'] ?? "default@example.com",
          reference: data['reference'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
          currency: data['currency'] ?? "GHS",
          amount: (data['amount'] ?? amount * 100), // kobo/pesewa
          paymentChannels: ["mobile_money", "card"], // support both
        );

        if (payResponse.status == true) {
          print("✅ Payment Successful: ${payResponse.reference}");
        } else {
          print("❌ Payment Failed: ${payResponse.message}");
        }
      } else {
        print("Error from backend: ${response.body}");
      }
    } catch (e) {
      print("Payment initialization error: $e");
    }
  } */  

/*  Future<void> initializePayment(String feeId, int amount) async {
    String? accessToken=await AuthService.getToken();
    try {
      final response = await http.post(
        Uri.parse("$backendUrl/api/v1/payment/initialize"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'feeId': feeId,
          'amount': amount,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final url = data['authorization_url'];

        if (await canLaunchUrl(url)) {
          await launchUrl(url); // opens Paystack checkout in browser
        } else {
          throw "Could not launch $url";
        }
      } else {
        print("Error: ${response.body}");
      }
    } catch (e) {
      print("Payment initialization error: $e");
    }
  }  */
  
  Future<void> initializePayment(String feeId, int amount) async {
  String? accessToken = await AuthService.getToken();
  try {
    final response = await http.post(
      Uri.parse("$backendUrl/api/v1/payment/initialize"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'feeId': feeId,
        'amount': amount,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final urlString = data['paymentUrl'];

      if (urlString != null && urlString is String) {
        final url = Uri.parse(urlString);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          throw "Could not launch $url";
        }
      } else {
        throw "paymentUrl not found in response";
      }
    } else {
      print("Error: ${response.body}");
    }
  } catch (e) {
    print("Payment initialization error: $e");
  }
}


  Future<String?> fetchFeeId() async {
  try {
    
    final accessToken = await AuthService.getToken(); 
    if (accessToken == null) {
      print("No access token found");
      return null;
    }

    final response = await http.get(
      Uri.parse("$backendUrl/api/v1/students/fee-assignments"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final feeAssignments = data['feeAssignments'] as List;

      // Filter for payable fees
      final payableFees = feeAssignments.where((assignment) =>
          assignment['status'] == 'assigned' ||
          assignment['status'] == 'partially_paid');

      if (payableFees.isNotEmpty) {
        final firstFee = payableFees.first;
        return firstFee['feeId']['_id']; // This is the feeId you need
      } else {
        print("No payable fees found");
        return null;
      }
    } else {
      print("Error fetching fees: ${response.body}");
      return null;
    }
  } catch (e) {
    print("Error: $e");
    return null;
  }
} 

Future<void> checkPaymentStatus(BuildContext context,String reference) async {
  final accessToken = await AuthService.getToken();
  final response = await http.get(
    Uri.parse("$backendUrl/api/v1/payment/status/$reference"),
    headers: {
      'Authorization': 'Bearer $accessToken',
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment Successful!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment Failed")),
      );
    }
  }
}







Future<String?> initializePayments(String feeId, double amount) async {
    final accessToken = await AuthService.getToken();
    try {
      final response = await http.post(
        Uri.parse("$backendUrl/api/v1/payment/initialize"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({'feeId': feeId, 'amount': amount}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final paymentUrl = data['paymentUrl'];
        return paymentUrl;
      } else {
        print("Error initializing payment: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Payment initialization error: $e");
      return null;
    }
  }


  Future<String?> fetchFeeIds() async {
    try {
      final accessToken = await AuthService.getToken();
      if (accessToken == null) return null;

      final response = await http.get(
        Uri.parse("$backendUrl/api/v1/students/fee-assignments"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final feeAssignments = data['feeAssignments'] as List;

        final payableFees = feeAssignments.where((assignment) =>
            assignment['status'] == 'assigned' ||
            assignment['status'] == 'partially_paid');

        if (payableFees.isNotEmpty) {
          return payableFees.first['feeId']['_id'];
        } else {
          return null;
        }
      } else {
        print("Error fetching fees: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }