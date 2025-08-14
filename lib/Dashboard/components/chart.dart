import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fee_payment_app/Dashboard/components/models.dart';

class ChartPie extends StatefulWidget {
  final List<Payment>? payments;
  final List<Receipt>? receipts;
  
  const ChartPie({super.key, this.payments, this.receipts});

  @override
  State<ChartPie> createState() => _ChartPieState();
}

class _ChartPieState extends State<ChartPie> {
  Map<String, double> get paymentData {
    if (widget.payments == null || widget.receipts == null) {
      // Default data for when no payments are provided
      return {
        'Tuition': 500.0,
        'Hostel': 300.0,
        'Library': 100.0,
      };
    }
    
    Map<String, double> feeTypeAmounts = {};
    
    // Add completed payments (from receipts)
    for (var receipt in widget.receipts!) {
      // Find corresponding payment to get fee type
      final payment = widget.payments!.firstWhere(
        (p) => p.amount == receipt.amount && 
               p.createdAt.difference(receipt.date).abs().inMinutes < 5,
        orElse: () => Payment(
          id: '',
          amount: receipt.amount,
          feeId: '',
          feeDetails: FeeDetails(
            feeType: 'Other',
            academicSession: '',
            dueDate: DateTime.now(),
          ),
          paymentProvider: '',
          status: 'completed',
          createdAt: receipt.date,
        ),
      );
      
      final feeType = payment.feeDetails.feeType;
      feeTypeAmounts[feeType] = (feeTypeAmounts[feeType] ?? 0) + receipt.amount;
    }
    
    // Add pending payments
    for (var payment in widget.payments!.where((p) => p.status == 'initiated')) {
      final feeType = '${payment.feeDetails.feeType} (Pending)';
      feeTypeAmounts[feeType] = (feeTypeAmounts[feeType] ?? 0) + payment.amount;
    }
    
    return feeTypeAmounts.isNotEmpty ? feeTypeAmounts : {
      'No Data': 1.0,
    };
  }

  @override
  Widget build(BuildContext context) {
    final data = paymentData;
    final totalAmount = data.values.reduce((a, b) => a + b);
    final List<PieChartSectionData> pieChartSections =
        data.entries.map((entry) {
      const isTouched = false;
      const fontSize = isTouched ? 16.0 : 12.0;
      const radius = isTouched ? 60.0 : 50.0;
      final value = entry.value;
      final percentage = (value / totalAmount * 100).toStringAsFixed(1);

      return PieChartSectionData(
        color: _getColor(entry.key),
        value: value,
        title: '$percentage%',
        radius: radius,
        titleStyle: const TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return SizedBox(
     
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        // Animated welcome text
        /* SizedBox(
          height: 50,
          child: AnimatedTextKit(
            animatedTexts: [
          TypewriterAnimatedText(
            'Welcome to your Dashboard',
            textStyle: const TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
            speed: const Duration(milliseconds: 80),
          ),
            ],
            isRepeatingAnimation: true,
          ),
        ),
        const SizedBox(height: 16), */
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
          children: [
            // Payment breakdown header
            Text(
              'Payment Breakdown',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark 
                    ? Colors.white 
                    : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            // Fee types and amounts
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: data.entries.map((entry) => Column(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: _getColor(entry.key),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    entry.key,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'GHC ${entry.value.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              )).toList(),
            ),
            const SizedBox(height: 16),
            AspectRatio(
              aspectRatio: 2.0,
              child: PieChart(
            PieChartData(
              sections: pieChartSections,
              centerSpaceRadius: 40,
              sectionsSpace: 2,
            ),
              ),
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

  Color _getColor(String feeType) {
    if (feeType.contains('Tuition')) {
      return Colors.blue;
    } else if (feeType.contains('Hostel')) {
      return Colors.green;
    } else if (feeType.contains('Library')) {
      return Colors.purple;
    } else if (feeType.contains('Lab')) {
      return Colors.orange;
    } else if (feeType.contains('Pending')) {
      return Colors.amber;
    } else if (feeType.contains('No Data')) {
      return Colors.grey;
    } else {
      return Colors.teal;
    }
  }
}