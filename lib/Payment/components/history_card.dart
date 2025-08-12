import 'package:flutter/material.dart';

class HistoryCard extends StatelessWidget {
  final String date;
  final String period;
  final String paymentCategory;
  final int amount;
  const HistoryCard({super.key,required this.date,required this.period,required this.paymentCategory,required this.amount});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return  Container(
      width: double.infinity,
      height: 120,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      padding: const EdgeInsets.all(8),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           const Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Text("October 24,2026",),
                Text("Second Semester Tuition",style: TextStyle(fontWeight: FontWeight.bold),),
                Text("Tuition",style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Ghc 5670",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16))
            ],
          ),
          const Spacer(),
          ElevatedButton.icon(onPressed: (){}, icon: const Icon(Icons.download,),label: const Text("Download"),)
        ],
      ),
    );
  }
}