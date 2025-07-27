import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kaushik_digital/Models/payment_verification_model.dart';
import 'package:kaushik_digital/Providers/profile_detail_provider.dart';
import 'package:kaushik_digital/utils/constants/snackbar.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../Models/order_model.dart';
import '../utils/constants/constants.dart';

class RazorpayService {
  static final razorPay = Razorpay();

  static Future<void> checkOutOrder({
    required OrderModel orderModel,
    required Function(PaymentSuccessResponse) onSuccess,
    required Function(PaymentFailureResponse) onFailure,
    required BuildContext context,
  }) async {
    final userProvider =
        Provider.of<ProfileDetailProvider>(context, listen: false);

    var options = {
      'key': 'rzp_test_hOZCibf5Ibk62K', // YE ORIGNAL API KEY HAI NOT WORKING
      // 'key': 'rzp_test_09AVqbkjcSmzKv', // YE WORK KRR RAHI HAI ROHIT SEMRIWAL KI API KEY HAI
      'amount': 500, // Amount in paise (₹500)
      'name': userProvider.name, // Dynamic user name
      'description': 'Purchase of Fine T-Shirt',
      'order_id': orderModel.orderId, // Use a valid order ID
      'currency': 'INR', // Ensure currency matches the Razorpay order
      'prefill': {
        'contact': userProvider.phone, // Use a valid phone number
        'email': userProvider.email, // Use a valid email
      },
    };

    print('Razorpay Options: $options');

    // Payment event listeners
    razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
        (PaymentSuccessResponse response) {
      onSuccess(response);
      razorPay.clear(); // Clear Razorpay listeners
    });
    razorPay.on(Razorpay.EVENT_PAYMENT_ERROR,
        (PaymentFailureResponse response) {
      log('Payment failed: ${response.message}');
      log('Code: ${response.code}');
      log('Metadata: ${response.error.toString()}');
      onFailure(response);
      razorPay.clear(); // Clear Razorpay listeners
    });

    try {
      razorPay.open(options);
    } catch (e) {
      print('Error opening Razorpay: $e');
    }
  }

// class RazorpayService {
//   static final razorPay = Razorpay();

//   static Future<void> checkOutOrder(
//       {required OrderModel orderModel,
//       required Function(PaymentSuccessResponse) onSuccess,
//       required Function(PaymentFailureResponse) onFailure,
//       required BuildContext context}) async {
//     final userProvider =
//         Provider.of<ProfileDetailProvider>(context, listen: false);
//         var options = {
//       'key': 'rzp_test_lEKVlXGFKRsM0C',
//       'amount': 100,
//       'name': 'Acme Corp.',
//       'description': 'Fine T-Shirt',
//       'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'}
//     };
//     // var options = {
//     //   'key': 'rzp_test_lEKVlXGFKRsM0C',
//     //   // 'order_id': orderModel.orderId,
//     //   // 'currency': '${orderModel.currency}',
//     //   // 'amount': orderModel.amount,
//     //   "amount": 500,
//     //   'name': '${userProvider.name}.',
//     //   'description': 'Fine T-Shirt',
//     //   'prefill': {
//     //     'contact': '8888888888',
//     //     // 'contact': '${userProvider.phone}',
//     //     // 'email': '${userProvider.email}'
//     //     'email': 'test@razorpay.com@e'
//     //   }
//     // };
//     print(options);

//     razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
//         (PaymentSuccessResponse response) {
//       // Do something when payment succeeds
//       onSuccess(response);
//       razorPay.clear();
//     });
//     razorPay.on(Razorpay.EVENT_PAYMENT_ERROR,
//         (PaymentFailureResponse response) {
//       // Do something when payment fails
//       onFailure(response);
//       razorPay.clear();
//     });
//     try {
//       razorPay.open(options);
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

// Creating Order
  Future<OrderModel?> createOrder(
      {required int amount, required BuildContext context}) async {
    try {
      log('Creating order with amount: $amount');
      http.Response response = await http.post(
        Uri.parse('$uri/create-order'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode({
          'amount': amount * 100, // Convert to paise
          'user_id': Provider.of<ProfileDetailProvider>(context, listen: false).userId,
        }),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        OrderModel order = OrderModel.fromJson(data);
        Map<String, dynamic> orderJson = order.toJson();

        print(orderJson);

        return OrderModel.fromJson(data);
      } else {
        log('Failed to fetch order: ${response.statusCode}');
        snackbar(
          'Failed to create order',
          context,
        );

        return null;
      }
    } catch (e) {
      log(e.toString());
      snackbar(
        'Failed to create order',
        context,
      );
    }
    return null;
  }

  // Verify Payment
  Future<PaymentVerificationModel?> verifyPayment({
    required String razorpaySignature,
    required String razorpayPaymentId,
    required String razorpayOrderId,
    required int userId,
    required int movieId,
    required BuildContext context,
  }) async {
    try {
      log('Verifying payment with signature: $razorpaySignature');
      http.Response response = await http.post(
        Uri.parse('$uri/verify-payment'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode({
          'razorpay_signature': razorpaySignature,
          'razorpay_payment_id': razorpayPaymentId,
          'razorpay_order_id': razorpayOrderId,
          'user_id': userId,
          'movie_id': movieId,
        }),
      );
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        log('Payment verification successful: $data');
        return PaymentVerificationModel.fromJson(data);
      } else {
        log('Failed to verify payment: ${response.statusCode}');
        snackbar('Payment verification failed', context);
        return null;
      }
    } catch (e) {
      log('Payment verification error: $e');
      snackbar('Payment verification failed', context);
      return null;
    }
  }
}





















// // import 'package:http/http.dart' as http;

// // ignore_for_file: avoid_print


// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:kaushik_digital/utils/constants/snackbar.dart';

// import '../utils/constants/constants.dart';

// class StripeServices {
//   StripeServices._();
//   static final StripeServices instance = StripeServices._();

//   // Future<void> makePayment({required BuildContext context}) async {
//   //   try {
//   //     String? paymentIntentClientSecret = await _createPaymentIntent(50, "USD",context);
//   //     if (paymentIntentClientSecret == null) return;
//   //     await Stripe.instance.initPaymentSheet(
//   //         paymentSheetParameters: SetupPaymentSheetParameters(
//   //             paymentIntentClientSecret: paymentIntentClientSecret,
//   //             merchantDisplayName: "Syed Ebad"));
//   //     await processPayment();
//   //   } catch (e) {
//   //     print(e);
//   //   }
//   // }
//   Future<void> makePayment(Function onSuccess, BuildContext context) async {
//     try {
//       String? paymentIntentClientSecret = await _createPaymentIntent(50, "USD");
//       if (paymentIntentClientSecret == null) return;

//       await Stripe.instance.initPaymentSheet(
//         paymentSheetParameters: SetupPaymentSheetParameters(
//           paymentIntentClientSecret: paymentIntentClientSecret,
//           merchantDisplayName: "Syeds",
//         ),
//       );

//       // Call processPayment and pass the onSuccess callback
//       await processPayment(onSuccess, context);
//     } catch (e) {
//       print("Error during payment initialization: $e");
//     }
//   }

//   Future<String?> _createPaymentIntent(int amount, String currency) async {
//     try {
//       final dio = Dio();
//       Map<String, dynamic> data = {
//         "amount": _calculateAmount(amount),
//         "currency": currency
//       };
//       // var url = Uri.parse("https://api.stripe.com/v1/payment_intents");
//       var response = await dio.post("https://api.stripe.com/v1/payment_intents",
//           data: data,
//           options:
//               Options(contentType: Headers.formUrlEncodedContentType, headers: {
//             "Authorization": "Bearer $stripeSecretKey",
//             "Content-Type": 'application/x-www-form-urlencoded',
//           }));
//       if (response.data != null) {
//         print(response.data);

//         return response.data["client_secret"];
//       }
//       return null;
//     } catch (e) {
//       print(e);
//     }
//     return null;
//   }

//   // Future<void> processPayment() async {
//   //   try {
//   //     await Stripe.instance.presentPaymentSheet();
//   //     await Stripe.instance.confirmPaymentSheetPayment();
//   //   } catch (e) {
//   //     print(e);
//   //   }
//   // }

//   Future<void> processPayment(Function onSuccess, BuildContext context) async {
//     try {
//       // Present the payment sheet to the user
//       await Stripe.instance.presentPaymentSheet();
//       // Future.delayed(Duration(seconds: 1), () {
//       print('@@@@@@maal agy maal agya@@@@@@@@');
//       onSuccess(); // Call success dialog after 2 seconds
//       // });

//       // Confirm the payment, throws an error if something goes wrong
//       await Stripe.instance.confirmPaymentSheetPayment();

//       // If everything succeeds, trigger the onSuccess callback
//     } catch (e) {
//       print("Payment failed: $e");
//       snackbar("Payment failed ", context);

//       // You can add a failure handler here if you want to show a failure dialog
//     }
//   }

//   String _calculateAmount(int amount) {
//     final calculateAmount = amount * 100;
//     return calculateAmount.toString();
//   }
// }
// //  Navigator.push(context,
// //             MaterialPageRoute(builder: (context) => VideoPlayerScreen()));