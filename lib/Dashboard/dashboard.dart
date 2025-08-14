import 'package:fee_payment_app/Dashboard/components/info_card.dart';
import 'package:fee_payment_app/Dashboard/components/info_card.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:fee_payment_app/components/consistent_top_info.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Dummy transaction data
  final Map<String, int> transactionData = {
    'Pending': 5,
    'Rejected': 2,
    'Approved': 8,
  };

  @override
  Widget build(BuildContext context) {
    final totalTransactions = transactionData.values.reduce((a, b) => a + b);
    final List<PieChartSectionData> pieChartSections =
        transactionData.entries.map((entry) {
      const isTouched = false;
      const fontSize = isTouched ? 16.0 : 12.0;
      const radius = isTouched ? 60.0 : 50.0;
      final value = entry.value;
      final percentage = (value / totalTransactions * 100).toStringAsFixed(1);

      return PieChartSectionData(
        color: _getColor(entry.key),
        value: value.toDouble(),
        title: '$percentage%',
        radius: radius,
        titleStyle: const TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        //leading: const Icon(Icons.menu),
        // backgroundColor: Colors.blue[600],
        elevation: 5,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Animated welcome text
            SizedBox(
              height: 30,
              child: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    'Welcome to your Dashboard',
                    textStyle: const TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                    speed: const Duration(milliseconds: 150),
                  ),
                ],
                isRepeatingAnimation: true,
              ),
            ),
           // const SizedBox(height: 16),
            const InfoCard(
                toptext: "Recent Payment",
                middletext: "₵ 1,200.00",
                bottomtext: "Sem: 1 tuition",
                icon: Icons.account_balance_wallet),
                const SizedBox(height: 16),
            Card(
              elevation: 20,
              shadowColor: Colors.black.withValues(alpha: 10),
              
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Names and values on top of the rectangle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: transactionData.entries
                          .map((entry) => Column(
                                children: [
                                  Text(
                                    entry.key,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  Text(
                                    '${entry.value}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    width: 60,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: _getColor(entry.key),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ],
                              ))
                          .toList(),
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
                    const SizedBox(height: 16),
                    
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Rejected':
        return Colors.red;
      case 'Approved':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}