import 'package:fee_payment_app/Payment/components/paystack.dart';
import 'package:fee_payment_app/Payment/components/web_view.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class PaymentDetailsScreen extends StatefulWidget {
  final BuildContext ctx;
  final BuildContext paymentContext;

  const PaymentDetailsScreen(
      {super.key, required this.ctx, required this.paymentContext});

  @override
  State<PaymentDetailsScreen> createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  bool fetchingData = false;

  @override
  void dispose() {
    amountController.dispose();
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
              "Enter Payment Amount",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              semanticsLabel: "Payment amount form",
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Amount",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter an amount";
                }
                if (double.tryParse(value) == null) {
                  return "Enter a valid number";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    setState(() {
                      fetchingData = true;
                    });
                    final feeId = await fetchFeeIds();
                    if (feeId == null) {
                      setState(() {
                        fetchingData = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("No payable fee found.")),
                      );

                      return;
                    }

                    final amount = double.parse(amountController.text);
                    final paymentUrl = await initializePayments(feeId, amount);

                    if (paymentUrl != null) {
                      // Close the modal first
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      }

                      // Push Payment WebView
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PaymentWebView(
                            paymentUrl: paymentUrl,
                            callbackUrl:
                                "https://your-backend.com/payment-callback",
                          ),
                        ),
                      );
                    } else {
                      setState(() {
                        fetchingData = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Failed to start payment.")),
                      );
                    }
                  }
                },
                child: fetchingData
                    ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: LoadingIndicator(
                          indicatorType: Indicator.ballPulse,
                          colors:  [Colors.red,Colors.yellow,Colors.green],
                          strokeWidth: 2,
                          backgroundColor: Colors.transparent,
                          pathBackgroundColor: Colors.transparent),
                    )
                    : const Text("Continue to Pay"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
