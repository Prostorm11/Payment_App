import 'package:flutter/material.dart';
import 'package:pay_with_paystack/pay_with_paystack.dart';

void Paystack(BuildContext context,uniqueTransRef,email,amount,secretkey){
  PayWithPayStack().now(
    context: context,
    secretKey:
        "sk_live_XXXXXXXXXXXXXXXXXXXXX",
    customerEmail: "popekabu@gmail.com",
    reference: uniqueTransRef,
    currency: "GHS",
    amount: 20000,
    callbackUrl: "https://google.com",
    transactionCompleted: (paymentData) {
      debugPrint(paymentData.toString());
    },
    transactionNotCompleted: (reason) {
      debugPrint("==> Transaction failed reason $reason");
});
}