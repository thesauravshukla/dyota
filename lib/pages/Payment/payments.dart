// import 'dart:async';

// import 'package:decimal/decimal.dart';
// import 'package:flutter/material.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';

// class RazorpayPayment {
//   late Razorpay _razorpay;
//   late Completer<String> _paymentCompleter;

//   RazorpayPayment() {
//     _razorpay = Razorpay();
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//   }

//   void dispose() {
//     _razorpay.clear();
//   }

//   Future<String> openCheckout(double amount) {
//     _paymentCompleter = Completer<String>();

//     var options = {
//       'key': 'rzp_live_ILgsfZCZoFIKMb',
//       'amount': (amount * 100).toInt(), // Amount in paise
//       'name': 'Dyota',
//       'description': 'Payment for order',
//       'currency': 'INR',
//       'prefill': {'email': 'example@example.com'},
//       'external': {
//         'wallets': ['paytm', 'phonepe', 'gpay', 'applepay', 'amazonpay', 'upi']
//       }
//     };

//     try {
//       _razorpay.open(options);
//     } catch (e) {
//       debugPrint('Error: $e');
//       _paymentCompleter.completeError('Error: $e');
//     }

//     return _paymentCompleter.future;
//   }

//   void _handlePaymentSuccess(PaymentSuccessResponse response) {
//     debugPrint('Payment Success: ${response.paymentId}');
//     _paymentCompleter.complete('success');
//   }

//   void _handlePaymentError(PaymentFailureResponse response) {
//     debugPrint('Payment Error: ${response.code} - ${response.message}');
//     _paymentCompleter.complete('failure');
//   }

//   void _handleExternalWallet(ExternalWalletResponse response) {
//     debugPrint('External Wallet: ${response.walletName}');
//     _paymentCompleter.complete('external_wallet');
//   }
// }

// Future<String> initiatePayment(Decimal amount) async {
//   final razorpayPayment = RazorpayPayment();
//   String result;
//   try {
//     result = await razorpayPayment.openCheckout(amount.toDouble());
//   } catch (e) {
//     result = 'error';
//   } finally {
//     razorpayPayment.dispose();
//   }
//   return result;
// }
