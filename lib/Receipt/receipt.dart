import 'package:fee_payment_app/Payment/components/paystack.dart';
import 'package:fee_payment_app/Payment/components/web_view.dart';
import 'package:flutter/material.dart';

class ReceiptScreen extends StatefulWidget {
  const ReceiptScreen({super.key});

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: /* ElevatedButton(onPressed:()async {
         /*  startPaystackPayment("steammarfo111@gmail.com", 2, "try"); */
         final feeId=await fetchFeeId()??"";
         await initializePayment(feeId, 22);
         
        }, child: Text("Pay")), */
        ElevatedButton(
          onPressed: () async {
            final feeId = await fetchFeeIds();
            if (feeId == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("No payable fee found.")),
              );
              return;
            }

            final paymentUrl = await initializePayments(feeId, 0.2); // amount in your currency units
            if (paymentUrl != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PaymentWebView(
                    paymentUrl: paymentUrl,
                    callbackUrl: "https://your-backend.com/payment-callback", // replace with your actual callback
                  ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Failed to start payment.")),
              );
            }
          },
          child: const Text("Pay"),
        ),
      ),
    );
  }
}