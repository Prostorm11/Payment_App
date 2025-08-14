import 'package:fee_payment_app/components/consistent_top_info.dart';
import 'package:flutter/material.dart';

// Receipt model
class Receipt {
  final String transactionId;
  final String studentName;
  final String studentId;
  final String department;
  final String year;
  final String paymentMethod;
  final double amount;
  final DateTime date;

  Receipt({
    required this.transactionId,
    required this.studentName,
    required this.studentId,
    required this.department,
    required this.year,
    required this.paymentMethod,
    required this.amount,
    required this.date,
  });
}

// Receipt List Screen
class ReceiptScreen extends StatelessWidget {
  ReceiptScreen({super.key});

  final List<Receipt> receipts = [
    Receipt(
      transactionId: "TXN12345",
      studentName: "Nana Ameyaw",
      studentId: "KNUST-23200",
      department: "Computer Science",
      year: "Freshman",
      paymentMethod: "Paystack",
      amount: 750.0,
      date: DateTime(2025, 8, 14),
    ),
    Receipt(
      transactionId: "TXN12346",
      studentName: "Nana Ameyaw",
      studentId: "KNUST-23200",
      department: "Computer Science",
      year: "Freshman",
      paymentMethod: "Paystack",
      amount: 500.0,
      date: DateTime(2025, 7, 10),
    ),
    Receipt(
      transactionId: "TXN12347",
      studentName: "Nana Ameyaw",
      studentId: "KNUST-23200",
      department: "Computer Science",
      year: "Freshman",
      paymentMethod: "Paystack",
      amount: 1000.0,
      date: DateTime(2025, 6, 5),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Sort by date descending
    receipts.sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
     
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            const ConsistentTopInfo(userName: "Derricks"),
            const SizedBox(
              height: 16,
            ),
            Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: receipts.length,
              itemBuilder: (context, index) {
                final receipt = receipts[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ReceiptDetailScreen(receipt: receipt),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                receipt.transactionId,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${receipt.date.day}/${receipt.date.month}/${receipt.date.year}",
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          Text(
                            "GHS ${receipt.amount.toStringAsFixed(2)}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          ]
        ),
      ),
    );
  }
}

// Full Receipt Detail Screen with download
class ReceiptDetailScreen extends StatelessWidget {
  final Receipt receipt;

  const ReceiptDetailScreen({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("Receipt Details"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade400,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "University Name",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Icon(Icons.receipt_long, size: 40, color: Colors.blue),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),

              // Student Info
              const Text(
                "Student Information",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blue),
              ),
              const SizedBox(height: 8),
              _infoRow("Name", receipt.studentName),
              _infoRow("Student ID", receipt.studentId),
              _infoRow("Department", receipt.department),
              _infoRow("Year", receipt.year),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),

              // Payment Info
              const Text(
                "Payment Details",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blue),
              ),
              const SizedBox(height: 8),
              _infoRow("Transaction ID", receipt.transactionId),
              _infoRow(
                  "Payment Date",
                  "${receipt.date.day}/${receipt.date.month}/${receipt.date.year}"),
              _infoRow("Payment Method", receipt.paymentMethod),
              _infoRow("Amount Paid", "GHS ${receipt.amount.toStringAsFixed(2)}"),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),

              // Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total Paid",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "GHS ${receipt.amount.toStringAsFixed(2)}",
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Download button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.download),
                  label: const Text("Download Receipt"),
                  onPressed: () {
                    // Add your download logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              const Center(
                child: Text(
                  "Thank you for your payment!",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
