import 'package:fee_payment_app/convert.dart';
import 'package:flutter/material.dart';
import 'package:fee_payment_app/Dashboard/components/chart.dart';
import 'package:fee_payment_app/Dashboard/components/info_card.dart';
import 'package:fee_payment_app/components/consistent_top_info.dart';


class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get data from AppData singleton
    final student = AppData.instance.student;
    final payments = AppData.instance.payments;

    // Calculate total fees due
    final totalFeesDue = payments.fold<double>(
      0,
      (sum, payment) =>
          sum + (payment['amount'] != null ? (payment['amount'] as num).toDouble() : 0),
    );

    // Find the next payment due
    Map<String, dynamic>? nextPayment;
    if (payments.isNotEmpty) {
      payments.sort((a, b) {
        final aDate = DateTime.parse(a['feeDetails']['dueDate']);
        final bDate = DateTime.parse(b['feeDetails']['dueDate']);
        return aDate.compareTo(bDate);
      });
      nextPayment = payments.first;
    }

    // Find last payment made
    Map<String, dynamic>? lastPayment;
    if (payments.isNotEmpty) {
      payments.sort((a, b) => DateTime.parse(b['createdAt']).compareTo(DateTime.parse(a['createdAt'])));
      lastPayment = payments.first;
    }

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            children: [
              ConsistentTopInfo(
                
              ),
              const Divider(),
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const ChartPie(), // Keep your existing chart component
                      InfoCard(
                        icon: Icons.payment,
                        toptext: "Total Fees Due",
                        middletext: "Ghc ${totalFeesDue.toStringAsFixed(2)}",
                        bottomtext: "Outstanding balance for current semester",
                        onPressed: () {},
                      ),
                      InfoCard(
                        icon: Icons.calendar_today,
                        toptext: "Next Payment Due",
                        middletext: nextPayment != null
                            ? _formatDate(nextPayment['feeDetails']['dueDate'])
                            : "No upcoming payment",
                        bottomtext: nextPayment != null
                            ? nextPayment['feeDetails']['feeType']
                            : "",
                        onPressed: () {},
                      ),
                      InfoCard(
                        icon: Icons.check_circle_outline,
                        toptext: "Last Payment Made",
                        middletext: lastPayment != null
                            ? "Ghc ${lastPayment['amount']}"
                            : "No payment made",
                        bottomtext: lastPayment != null
                            ? _formatDate(lastPayment['createdAt'])
                            : "",
                        onPressed: () {},
                      ),
                      const SizedBox(height: 20),
                      _wideButton(
                        context,
                        icon: Icons.receipt_long,
                        label: "View Receipts",
                        onTap: () {
                          // Navigate to receipts screen
                        },
                      ),
                      const SizedBox(height: 12),
                      _wideButton(
                        context,
                        icon: Icons.volunteer_activism,
                        label: "Request Refund",
                        onTap: () {
                          // Navigate to refund screen
                        },
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

  String _formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    return "${date.day}/${date.month}/${date.year}";
  }
}
