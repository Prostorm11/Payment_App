import 'package:fee_payment_app/Payment/components/history_card.dart';
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
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ConsistentTopInfo(userName: "Derrick"),
            Divider(),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  HistoryCard(
                      date: "date",
                      period: "period",
                      paymentCategory: "paymentCategory",
                      amount: 3)
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
