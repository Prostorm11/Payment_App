import 'dart:convert';
import 'package:fee_payment_app/components/consistent_top_info.dart';
import 'package:fee_payment_app/SignIn/components/authService.dart';
import 'package:fee_payment_app/config.dart';
import 'package:fee_payment_app/convert.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class RefundScreen extends StatefulWidget {
  const RefundScreen({super.key});

  @override
  State<RefundScreen> createState() => _RefundScreenState();
}

class _RefundScreenState extends State<RefundScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadRefundData();
  }

  Future<void> _loadRefundData() async {
    try {
      await AppData.instance.fetchDashboard(); // fetch student, payments, refunds
      setState(() {
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
    }
  }

  Future<void> _submitRefund() async {
    final amount = _amountController.text;
    final reason = _reasonController.text;

    if (amount.isEmpty || reason.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('$backendUrl/api/v1/refunds'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await AuthService.getToken()}',
        },
        body: jsonEncode({
          'amount': double.parse(amount),
          'reason': reason,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Refund requested successfully')),
        );
        _amountController.clear();
        _reasonController.clear();
        _loadRefundData(); // reload to show the latest refund
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final student = AppData.instance.student;
    final refunds = [];

    return SafeArea(
      child: Scaffold(
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  children: [
                    ConsistentTopInfo(),
                    const SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            // My Account
                            _styledContainer(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'My Account',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.blue),
                                  ),
                                  const SizedBox(height: 8),
                                  Text('Name: ${student?['name'] ?? 'N/A'}'),
                                  Text('Email: ${student?['email'] ?? 'N/A'}'),
                                  Text('Student ID: ${student?['studentId'] ?? 'N/A'}'),
                                  Text('Department: ${student?['department'] ?? 'N/A'}'),
                                  Text('Year of Study: ${student?['year'] ?? 'N/A'}'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Last Refunds
                            _styledContainer(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Last Refunds',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.blue),
                                  ),
                                  const SizedBox(height: 8),
                                  refunds.isEmpty
                                      ? const Text('No refunds found.')
                                      : Column(
                                          children: refunds
                                              .map(
                                                (r) => Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                                  child: Text(
                                                    'GHS ${r['amount']} - ${r['status']} on ${r['date']}',
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Request Refund
                            _styledContainer(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Request Refund',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  const SizedBox(height: 16),
                                  TextField(
                                    controller: _amountController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: 'Amount (GHS)',
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  TextField(
                                    controller: _reasonController,
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                      labelText: 'Reason',
                                      hintText: 'Explain why you want a refund...',
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      onPressed: _submitRefund,
                                      child: const Text(
                                        'Submit Request',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _styledContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
