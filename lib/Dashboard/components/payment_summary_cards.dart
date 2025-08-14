import 'package:flutter/material.dart';
import 'package:fee_payment_app/Dashboard/components/models.dart';
import 'package:intl/intl.dart';

class PaymentSummaryCards extends StatelessWidget {
  final List<Payment> payments;
  final List<Receipt> receipts;

  const PaymentSummaryCards({
    super.key,
    required this.payments,
    required this.receipts,
  });

  @override
  Widget build(BuildContext context) {
    final totalPaid = receipts.fold(0.0, (sum, receipt) => sum + receipt.amount);
    final totalInitiated = payments.where((p) => p.status == 'initiated')
        .fold(0.0, (sum, payment) => sum + payment.amount);
    final completedPayments = receipts.length;
    final pendingPayments = payments.where((p) => p.status == 'initiated').length;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                context,
                'Total Paid',
                'GHC ${totalPaid.toStringAsFixed(2)}',
                Icons.check_circle,
                Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                context,
                'Pending',
                'GHC ${totalInitiated.toStringAsFixed(2)}',
                Icons.pending,
                Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                context,
                'Completed',
                '$completedPayments payments',
                Icons.receipt,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                context,
                'Processing',
                '$pendingPayments payments',
                Icons.hourglass_empty,
                Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white70 : Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class RecentPaymentsCard extends StatelessWidget {
  final List<Payment> payments;
  final List<Receipt> receipts;

  const RecentPaymentsCard({
    super.key,
    required this.payments,
    required this.receipts,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final recentPayments = payments.take(5).toList();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.history,
                color: isDark ? Colors.white70 : Colors.blue,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Recent Payments',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (recentPayments.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'No payments found',
                  style: TextStyle(
                    color: isDark ? Colors.white54 : Colors.grey[600],
                  ),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentPayments.length,
              separatorBuilder: (context, index) => Divider(
                color: isDark ? Colors.white10 : Colors.grey[200],
              ),
              itemBuilder: (context, index) {
                final payment = recentPayments[index];
                return _buildPaymentItem(context, payment, isDark);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildPaymentItem(BuildContext context, Payment payment, bool isDark) {
    final statusColor = payment.status == 'completed' 
        ? Colors.green 
        : payment.status == 'initiated' 
            ? Colors.orange 
            : Colors.red;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getFeeTypeColor(payment.feeDetails.feeType).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getFeeTypeIcon(payment.feeDetails.feeType),
              color: _getFeeTypeColor(payment.feeDetails.feeType),
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payment.feeDetails.feeType,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                Text(
                  DateFormat('MMM dd, yyyy').format(payment.createdAt),
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'GHC ${payment.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  payment.status,
                  style: TextStyle(
                    fontSize: 12,
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getFeeTypeColor(String feeType) {
    switch (feeType.toLowerCase()) {
      case 'tuition':
        return Colors.blue;
      case 'hostel':
        return Colors.green;
      case 'library':
        return Colors.purple;
      case 'lab':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getFeeTypeIcon(String feeType) {
    switch (feeType.toLowerCase()) {
      case 'tuition':
        return Icons.school;
      case 'hostel':
        return Icons.home;
      case 'library':
        return Icons.library_books;
      case 'lab':
        return Icons.science;
      default:
        return Icons.payment;
    }
  }
}