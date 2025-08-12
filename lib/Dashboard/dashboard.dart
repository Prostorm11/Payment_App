import 'package:flutter/material.dart';
import 'package:fee_payment_app/Dashboard/components/info_card.dart';
import 'package:fee_payment_app/components/consistent_top_info.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            children: [
              const ConsistentTopInfo(userName: "Derrick"),
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      InfoCard(
                        icon: Icons.payment,
                        toptext: "Total Fees Due",
                        middletext: "Ghc 2500.90",
                        bottomtext: "Outstanding balance for current semester",
                        onPressed: () {},
                      ),
                      InfoCard(
                        icon: Icons.calendar_today,
                        toptext: "Next Payment Due",
                        middletext: "Nov 30, 2024",
                        bottomtext: "Mandatory tuition fee payment",
                        onPressed: () {},
                      ),
                      InfoCard(
                        icon: Icons.check_circle_outline,
                        toptext: "Last Payment Made",
                        middletext: "Ghc 750.00",
                        bottomtext: "Oct 15, 2024 - Semester I Installment",
                        onPressed: () {},
                      ),
                      const SizedBox(height: 20),
                      _wideButton(
                        context,
                        icon: Icons.receipt_long,
                        label: "View Receipts",
                        onTap: () {},
                      ),
                      const SizedBox(height: 12),
                      _wideButton(
                        context,
                        icon: Icons.volunteer_activism,
                        label: "Request Refund",
                        onTap: () {},
                      ),
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

  Widget _wideButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      width: MediaQuery.of(context).size.width*0.85,
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
}
