import 'package:fee_payment_app/Dashboard/components/chart.dart';
import 'package:flutter/material.dart';
import 'package:fee_payment_app/Dashboard/components/info_card.dart';
import 'package:fee_payment_app/components/consistent_top_info.dart';
import 'package:fee_payment_app/Dashboard/components/models.dart';
import 'package:fee_payment_app/Dashboard/components/dashboard_service.dart';
import 'package:fee_payment_app/Dashboard/components/student_info_card.dart';
import 'package:fee_payment_app/Dashboard/components/payment_summary_cards.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DashboardResponse? dashboardData;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      // For now, using mock data. Replace with actual API call when ready
      final data = DashboardService.getMockData();
      // final data = await DashboardService.fetchDashboardData();
      
      setState(() {
        dashboardData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load dashboard data: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            children: [
              ConsistentTopInfo(
                userName: dashboardData?.student.name ?? "Loading...",
              ),
              const SizedBox(height: 8),
              Expanded(
                child: _buildBody(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red[600]),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadDashboardData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (dashboardData == null) {
      return const Center(
        child: Text('No data available'),
      );
    }

    final data = dashboardData!;
    final lastPayment = DashboardService.getLastPayment(data.payments);
    final nextDueDate = DashboardService.getNextDueDate(data.payments);
    final totalPaid = data.receipts.fold(0.0, (sum, receipt) => sum + receipt.amount);

    return RefreshIndicator(
      onRefresh: _loadDashboardData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // Student Information Card
            StudentInfoCard(student: data.student),
            
            // Payment Summary Cards
            PaymentSummaryCards(
              payments: data.payments,
              receipts: data.receipts,
            ),
            
            const SizedBox(height: 16),
            
                         // Chart showing payment breakdown
             ChartPie(
               payments: data.payments,
               receipts: data.receipts,
             ),
            
            // Key Information Cards
            InfoCard(
              icon: Icons.account_balance_wallet,
              toptext: "Total Paid",
              middletext: "GHC ${totalPaid.toStringAsFixed(2)}",
              bottomtext: "Total amount paid across all fees",
              onPressed: () {},
            ),
            
            if (nextDueDate != null)
              InfoCard(
                icon: Icons.schedule,
                toptext: "Next Payment Due",
                middletext: DateFormat('MMM dd, yyyy').format(nextDueDate),
                bottomtext: "Upcoming payment deadline",
                onPressed: () {},
              ),
            
            if (lastPayment != null)
              InfoCard(
                icon: Icons.check_circle_outline,
                toptext: "Last Payment Made",
                middletext: "GHC ${lastPayment.amount.toStringAsFixed(2)}",
                bottomtext: "${DateFormat('MMM dd, yyyy').format(lastPayment.createdAt)} - ${lastPayment.feeDetails.feeType}",
                onPressed: () {},
              ),
            
            // Recent Payments
            RecentPaymentsCard(
              payments: data.payments,
              receipts: data.receipts,
            ),
            
            const SizedBox(height: 20),
            
            // Action Buttons
            _wideButton(
              context,
              icon: Icons.receipt_long,
              label: "View All Receipts (${data.receipts.length})",
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _wideButton(
              context,
              icon: Icons.volunteer_activism,
              label: "Request Refund",
              onTap: () {},
            ),
            const SizedBox(height: 20),
          ],
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
