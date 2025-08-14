import 'package:fee_payment_app/Payment/components/history_card.dart';
import 'package:fee_payment_app/Payment/payment_details.dart';
import 'package:fee_payment_app/Payment/payment_method.dart'; // Ensure this import is correct
import 'package:fee_payment_app/components/consistent_top_info.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const ConsistentTopInfo(userName: "Derrick"),
           
            const SizedBox(height: 32),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _wideButton(
                      context,
                      icon: Icons.add,
                      label: "Make Payment",
                      onTap: () => _showPaymentModal(context),
                    ),
                    const SizedBox(height: 10),
                    const HistoryCard(
                      date: "date",
                      period: "period",
                      paymentCategory: "paymentCategory",
                      amount: 3,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _wideButton(BuildContext context,
      {required IconData icon, required String label, required VoidCallback onTap}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white),
        label: Text(label, style: const TextStyle(fontSize: 16)),
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? Colors.blue[400] : Colors.blue[600],
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Future<void> _showPaymentModal(BuildContext context) async {
    bool showPaymentDetails = true; // State to toggle between screens

    await showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Dialog(
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    height: MediaQuery.of(context).size.height * 0.4,
                    child:  PaymentDetailsScreen(ctx: ctx,paymentContext: context,),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: InkWell(
                      onTap: () => Navigator.of(ctx).pop(),
                      child: const Icon(
                        Icons.cancel,
                        color: Colors.red,
                        size: 35,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}