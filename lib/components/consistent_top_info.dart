import 'package:fee_payment_app/convert.dart';
import 'package:flutter/material.dart';

class ConsistentTopInfo extends StatelessWidget {
  const ConsistentTopInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final student = AppData.instance.student;
    final userName = student != null ? student['name'] : "Student";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.blue[700],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "FPS",
            style: TextStyle(
              fontFamily: "serif",
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          Text(
            userName,
            style: const TextStyle(
              fontFamily: "serif",
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ],
      ),
    );
  }
}
