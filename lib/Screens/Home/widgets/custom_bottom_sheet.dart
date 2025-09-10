import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaushik_digital/Models/order_model.dart';
import 'package:kaushik_digital/Models/payment_verification_model.dart';
import 'package:kaushik_digital/Providers/profile_detail_provider.dart';
import 'package:kaushik_digital/Screens/Detail%20screen/sampleplayer.dart';
import 'package:kaushik_digital/Services/razorpay_service.dart';
import 'package:kaushik_digital/utils/constants/constants.dart';
import 'package:kaushik_digital/utils/constants/snackbar.dart';
import 'package:provider/provider.dart';

class MovieBottomSheet extends StatefulWidget {
  final String movieName;
  final String duration;
  final String moviePoster;
  final num? moviePrice;
  final int? movieId;
  final String? movieUrl;
  final BuildContext context;

  const MovieBottomSheet({
    super.key,
    required this.movieName,
    required this.duration,
    required this.moviePoster,
    this.moviePrice,
    this.movieId,
    this.movieUrl,
    required this.context,
  });

  @override
  State<MovieBottomSheet> createState() => _MovieBottomSheetState();
}

class _MovieBottomSheetState extends State<MovieBottomSheet> {
  // final Razorpay razorpay = Razorpay();
  // razorpay = Razorpay();
  Timer? _paymentTimer;

  @override
  void initState() {
    super.initState();
    // RazorpayService.razorPay;
  }

  final RazorpayService razorpayService = RazorpayService();

  // Check if movie is free and handle accordingly
  void handleMovieAccess() {
    final moviePrice = widget.moviePrice ?? 0;
    
    if (moviePrice == 0 || moviePrice == 0.0) {
      // Free movie - go directly to video player
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPlayerScreen(
            movieTitle: widget.movieName,
            movieId: widget.movieId,
            movieUrl: widget.movieUrl,
          ),
        ),
      );
    } else {
      // Paid movie - initiate payment
      initiatePayment();
    }
  }

  Future<void> initiatePayment() async {
    try {
      final OrderModel? order =
          await razorpayService.createOrder(amount: (widget.moviePrice ?? 0).toInt(), context: context);
      if (order?.orderId == null) {
        snackbar("Error Creating Order", context);
        Navigator.pop(context);
        return;
      }
      if (order!.orderId.isNotEmpty) {
        _paymentTimer = Timer(const Duration(seconds: 1), () async {
          // Check if widget is still mounted before proceeding
          if (!mounted) return;
          
          await RazorpayService.checkOutOrder(
              orderModel: order,
              onSuccess: (response) async {
                print("Payment success callback triggered");
                if (mounted) {
                  // Get user provider for actual user ID
                  final userProvider = Provider.of<ProfileDetailProvider>(context, listen: false);
                  
                  // Verify payment after successful Razorpay response
                  final verificationResult = await razorpayService.verifyPayment(
                    razorpaySignature: response.signature ?? '',
                    razorpayPaymentId: response.paymentId ?? '',
                    razorpayOrderId: response.orderId ?? '',
                    userId: userProvider.userId ?? 126, // Use actual user ID or fallback
                    movieId: widget.movieId ?? 20, // Use actual movie ID or fallback
                    context: context,
                  );
                  
                  if (verificationResult != null && verificationResult.success == true) {
                    print("Payment verified successfully, navigating to video player");
                    print("Verification Result: ${verificationResult.toJson()}");
                    
                    // Show success message
                    snackbar("Payment Successful", context);
                    
                    // Pop the bottom sheet first
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                    
                    // Small delay to ensure bottom sheet is closed
                    await Future.delayed(const Duration(milliseconds: 100));
                    
                    // Navigate to video player
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VideoPlayerScreen(
                              movieTitle: widget.movieName,
                              movieId: widget.movieId,
                              movieUrl: widget.movieUrl,
                            )));

                    print("Payment Data ${response.data}");
                    print("Order ID ${response.orderId}");
                    print("Payment ID ${response.paymentId}");
                    print("Payment Signature ${response.signature}");
                  } else {
                    print("Payment verification failed");
                    print("Verification Result: ${verificationResult?.toJson()}");
                    print("Success field: ${verificationResult?.success}");
                    snackbar(verificationResult?.message ?? "Payment verification failed", context);
                  }
                } else {
                  print("Widget not mounted when payment success callback triggered");
                }
              },
              onFailure: (response) {
                print("Payment failure callback triggered");
                if (mounted) {
                  snackbar("Payment Failed!", context);
                  print("Payment failed: ${response.code} - ${response.message}");
                }
                print("**********************************");
                print(response.code);
                print(response.error);
                print(response.message);
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              context: context);
        });
      }
    } catch (error) {
      print('Error creating order: $error');
      snackbar("Error creating order", context);
    }
  }

  @override
  void dispose() {
    _paymentTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Container(
      height: h * 0.3,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 233, 230, 230),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: 20, right: 20, top: h * 0.025, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Buy Now",
                  style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                ),
                Text(
                  "Price ${widget.moviePrice ?? 0} INR",
                  style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
            child: Container(
              height: h * 0.13,
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Movie Details - Flexible
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.movieName,
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.namdhinggo(
                            textStyle: TextStyle(
                                fontSize: h * 0.022,
                                fontWeight: FontWeight.w800,
                                color: Colors.black),
                          ),
                        ),
                        Text(
                          "Duration : ${widget.duration}",
                          style: GoogleFonts.namdhinggo(
                            textStyle: TextStyle(
                                fontSize: h * 0.019,
                                fontWeight: FontWeight.w700,
                                color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Button - Flexible
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () async {
                        handleMovieAccess();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 13),
                        child: Text(
                          (widget.moviePrice == null || widget.moviePrice == 0) 
                              ? "Watch Free" 
                              : "Pay ₹${widget.moviePrice}",
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.namdhinggo(
                            textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}















// required VoidCallback onPayNow

// void showMovieBottomSheet({
//   required BuildContext context,
//   required String movieName,
//   required String duration,
//   required String moviePoster,
// }) {
//   Razorpay razorpay = Razorpay();
//   RazorpayService razorpayService = RazorpayService();

//   void handlePaymentSuccess(PaymentSuccessResponse response) {
//     snackbar("Payment Successfull ", context);
//     // Navigator.push(context,
//     //     MaterialPageRoute(builder: (context) => const VideoPlayerScreen()));
//     print("Payment Data ${response.data}");
//     print("Order ID ${response.orderId}");
//     print("Payment ID ${response.paymentId}");
//     print("Payment Signature ${response.signature}");
//   }

//   void handlePaymentError(PaymentFailureResponse response) {
//     snackbar("Payment Failed! Error: ${response.message}", context);
//   }

//   void handleExternalWallet(ExternalWalletResponse response) {
//     snackbar("External Wallet Selected: ${response.walletName}", context);
//   }

//   void openCheckout({
//     required int amount,
//     required String name,
//     required String contact,
//     required String email,
//     required String orderId,
//     // List<String> wallets = const [],
//   }) {
//     var options = {
//       'key': 'rzp_test_lEKVlXGFKRsM0C', // Replace with your Razorpay API key
//       'amount': amount, // 50 INR in paise
//       'name': name,
//       'order_id': orderId, // Generate order_id using Orders API
//       // Provider.of<ProfileDetailProvider>(context, listen: false).name,
//       'description': 'Payment for $movieName',
//       'prefill': {
//         'contact': '8888888888', // Optional: Pre-fill customer contact
//         'email': 'test@razorpay.com', // Optional: Pre-fill customer email
//       },
//       'external': {
//         'wallets': ['paytm'], // Optional: Add external wallet support
//       },
//     };

//     try {
//       razorpay.open(options);
//       Navigator.pop(context);
//     } catch (e) {
//       debugPrint('Error: $e');
//     }
//   }

//   razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
//   razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
//   razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);

//   Future<void> initiatePayment() async {
//     try {
//       final orderId = await razorpayService.createOrder(
//           amount: 500, context: context); // Amount in INR
//       if (orderId != null && orderId.isNotEmpty) {
//         final userDetails =
//             Provider.of<ProfileDetailProvider>(context, listen: false);
//         print(orderId);
//         Timer(const Duration(seconds: 1), () {
//           openCheckout(
//               amount: 500,
//               name: userDetails.name!,
//               contact: userDetails.phone!,
//               email: userDetails.email!,
//               orderId: orderId);
//         });
//       }
//     } catch (error) {
//       print('Error creating order: $error');
//       snackbar("Error creating order", context);
//     }
//   }

//   showModalBottomSheet(
//     context: context,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
//     ),
//     builder: (BuildContext context) {
//       double w = MediaQuery.of(context).size.width;
//       double h = MediaQuery.of(context).size.height;
//       return Container(
//         height: h * 0.3,
//         width: double.infinity,
//         decoration: const BoxDecoration(
//           color: Color.fromARGB(255, 233, 230, 230),
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(30),
//             topRight: Radius.circular(30),
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: EdgeInsets.only(
//                   left: 20, right: 20, top: h * 0.025, bottom: 10),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Buy Now",
//                     style: GoogleFonts.roboto(
//                       textStyle: const TextStyle(
//                           fontSize: 17,
//                           fontWeight: FontWeight.w700,
//                           color: Colors.black),
//                     ),
//                   ),
//                   Text(
//                     "Price 50 INR",
//                     style: GoogleFonts.roboto(
//                       textStyle: const TextStyle(
//                           fontSize: 17,
//                           fontWeight: FontWeight.w700,
//                           color: Colors.black),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
//                 child: Container(
//                   height: h * 0.13,
//                   decoration: BoxDecoration(
//                       border: Border.all(),
//                       borderRadius: BorderRadius.circular(20)),
//                   padding: const EdgeInsets.all(12),
//                   child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             SizedBox(
//                               width: w * 0.55,
//                               child: Text(
//                                 movieName,
//                                 maxLines: 2,
//                                 softWrap: true,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: GoogleFonts.namdhinggo(
//                                   textStyle: TextStyle(
//                                       fontSize: h * 0.022,
//                                       fontWeight: FontWeight.w800,
//                                       color: Colors.black),
//                                 ),
//                               ),
//                             ),
//                             Text(
//                               "Duration : $duration",
//                               style: GoogleFonts.namdhinggo(
//                                 textStyle: TextStyle(
//                                     fontSize: h * 0.019,
//                                     fontWeight: FontWeight.w700,
//                                     color: Colors.black),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const Spacer(),
//                         GestureDetector(
//                           onTap: () async {
//                             await initiatePayment();
//                           },
//                           child: Container(
//                             decoration: BoxDecoration(
//                                 color: primaryColor,
//                                 borderRadius: BorderRadius.circular(10)),
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: w * 0.06, vertical: 13),
//                             child: Text(
//                               "Pay Now",
//                               style: GoogleFonts.namdhinggo(
//                                 textStyle: const TextStyle(
//                                     fontSize: 17,
//                                     fontWeight: FontWeight.w700,
//                                     color: Colors.white),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ]),
//                 ))
//           ],
//         ),
//       );
//     },
//   );
// }



    //Ye phle se laga va hai
// void showMovieBottomSheet(
//     {required BuildContext context,
//     required String movieName,
//     required String duration,
//     required String moviePoster,
    
//     }) {
//   showModalBottomSheet(
//     context: context,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
//     ),
//     builder: (BuildContext context) {
//       double w = MediaQuery.of(context).size.width;
//       double h = MediaQuery.of(context).size.height;
//       return Container(
//         height: h * 0.3,
//         width: double.infinity,
//         decoration: const BoxDecoration(
//           color: Color.fromARGB(255, 233, 230, 230),
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(30),
//             topRight: Radius.circular(30),
//           ),
//         ),
//         // padding: const EdgeInsets.all(),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: EdgeInsets.only(
//                   left: 20, right: 20, top: h * 0.025, bottom: 10),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Buy Now",
//                     style: GoogleFonts.roboto(
//                       textStyle: const TextStyle(
//                           fontSize: 17,
//                           fontWeight: FontWeight.w700,
//                           color: Colors.black),
//                     ),
//                   ),
//                   Text(
//                     "Price 50 INR",
//                     style: GoogleFonts.roboto(
//                       textStyle: const TextStyle(
//                           fontSize: 17,
//                           fontWeight: FontWeight.w700,
//                           color: Colors.black),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
//                 child: Container(
//                   height: h * 0.13,
//                   decoration: BoxDecoration(
//                       border: Border.all(),
//                       borderRadius: BorderRadius.circular(20)),
//                   padding: const EdgeInsets.all(12),
//                   child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             SizedBox(
//                               width: w * 0.55,
//                               child: Text(
//                                 movieName,
//                                 maxLines: 2,
//                                 softWrap: true,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: GoogleFonts.namdhinggo(
//                                   textStyle: TextStyle(
//                                       fontSize: h * 0.022,
//                                       fontWeight: FontWeight.w800,
//                                       color: Colors.black),
//                                 ),
//                               ),
//                             ),
//                             Text(
//                               "Duration : $duration",
//                               style: GoogleFonts.namdhinggo(
//                                 textStyle: TextStyle(
//                                     fontSize: h * 0.019,
//                                     fontWeight: FontWeight.w700,
//                                     color: Colors.black),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const Spacer(),
//                         GestureDetector(
//                           onTap : (){},
//                           // onPayNow  ,

                           
//                           child: Container(
//                             decoration: BoxDecoration(
//                                 color: primaryColor,
//                                 borderRadius: BorderRadius.circular(10)),
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: w * 0.06, vertical: 13),
//                             child: Text(
//                               "Pay Now",
//                               style: GoogleFonts.namdhinggo(
//                                 textStyle: const TextStyle(
//                                     fontSize: 17,
//                                     fontWeight: FontWeight.w700,
//                                     color: Colors.white),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ]),
//                 ))
//           ],
//         ),
//       );
//     },
//   );
// }








 // StripeServices.instance.makePayment(() {

                            // snackbar("Payment Successful", context);

                            // Navigator.pop(context); // Close the bottom sheet

                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             const VideoPlayerScreen(
                            //                 // image: moviePoster,
                            //                 )));
                            // }, context);
                          

      // return Padding(
      //   padding: const EdgeInsets.all(16.0),
      //   child: Column(
      //     mainAxisSize: MainAxisSize.min,
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Center(
      //         child: Text(
      //           movieName,
      //           style: TextStyle(
      //             fontSize: 20.0,
      //             fontWeight: FontWeight.bold,
      //           ),
      //         ),
      //       ),
      //       SizedBox(height: 10.0),
      //       Center(
      //         child: Text(
      //           'Price: ₹50',
      //           style: TextStyle(
      //             fontSize: 18.0,
      //             color: Colors.grey[700],
      //           ),
      //         ),
      //       ),
      //       SizedBox(height: 20.0),
      //       Text(
      //         'Buy this movie to enjoy unlimited streaming access.',
      //         style: TextStyle(
      //           fontSize: 16.0,
      //           color: Colors.black87,
      //         ),
      //         textAlign: TextAlign.center,
      //       ),
      //       SizedBox(height: 30.0),
      //       Center(
      //         child: ElevatedButton(
      //           onPressed: () {
      //             // Handle payment logic here
      //             StripeServices.instance.makePayment(() {
      //               Navigator.push(
      //                   context,
      //                   MaterialPageRoute(
      //                       builder: (context) => const VideoPlayerScreen()));
      //             });
      //             // Navigator.pop(context); // Close the bottom sheet
      //           },
      //           style: ElevatedButton.styleFrom(
      //             backgroundColor: Colors.blue,
      //             padding:
      //                 EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
      //             shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(8.0),
      //             ),
      //           ),
      //           child: Text(
      //             'Pay Now',
      //             style: TextStyle(fontSize: 16.0),
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // );