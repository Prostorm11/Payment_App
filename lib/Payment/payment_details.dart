import 'package:flutter/material.dart';

class PaymentDetailsScree extends StatefulWidget {
  final VoidCallback onNext; // Callback to switch to PaymentMethod

  const PaymentDetailsScree({super.key, required this.onNext});

  @override
  State<PaymentDetailsScree> createState() => _PaymentDetailsScreeState();
}

class _PaymentDetailsScreeState extends State<PaymentDetailsScree> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final indexNoController = TextEditingController();
  final courseController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    indexNoController.dispose();
    courseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Payment Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              semanticsLabel: "Payment details form",
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? "Please enter a name" : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: indexNoController,
              decoration: const InputDecoration(
                labelText: "Index No",
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? "Please enter an index number" : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: courseController,
              decoration: const InputDecoration(
                labelText: "Course",
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? "Please enter a course" : null,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.onNext(); // Trigger switch to PaymentMethod
                  }
                },
                child: const Text("Next"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}