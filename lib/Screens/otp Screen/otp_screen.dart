import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaushik_digital/Providers/auth_provider.dart';
import 'package:kaushik_digital/utils/constants/constants.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  final String phNo;
  const OtpScreen({super.key, required this.phNo});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController otpController = TextEditingController();

  // @override
  // void dispose() {
  //   otpController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 65,
        centerTitle: true,
        title: Text("OTP Verification",
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                fontSize: 19,
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: h * 0.02,
            ),
            Center(
              child: Text("We have sent a verification code to ",
                  style: GoogleFonts.abel(
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ),
            Center(
              child: Text(widget.phNo ?? "",
                  style: GoogleFonts.abel(
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ),
            SizedBox(
              height: h * 0.02,
            ),
            SizedBox(
              width: w * 0.9,
              child: PinCodeTextField(
                controller: otpController,
                onChanged: (String value) {
                  if (!mounted) return; // Ensure widget is still active
                },
                enableActiveFill: true,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                appContext: context,
                length: 6,
                backgroundColor: Colors.transparent,
                animationType: AnimationType.fade,
                keyboardType: TextInputType.number,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                textStyle: TextStyle(
                  color: primaryColor,
                  fontSize: 17,
                  fontWeight: FontWeight.normal,
                ),
                cursorColor: primaryColor,
                pinTheme: PinTheme(
                  borderWidth: 1,
                  shape: PinCodeFieldShape.box,
                  fieldWidth: 40,
                  fieldHeight: 43,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  activeFillColor: Colors.transparent,
                  inactiveFillColor: Colors.transparent,
                  inactiveColor: Colors.grey,
                  selectedFillColor: Colors.transparent,
                  activeColor: primaryColor,
                  disabledColor: Colors.grey,
                  selectedColor: primaryColor,
                  errorBorderColor: Colors.red,
                ),
              ),
            ),
            SizedBox(
              height: h * 0.02,
            ),
            SizedBox(
              height: h * 0.02,
            ),
            SizedBox(
              width: w * 0.75,
              height: h * 0.065,
              child: ElevatedButton(
                onPressed: () {
                  // AuthService authService = AuthService();
                  // authService.loginWithOTP(
                  //     mobile: widget.phNo,
                  //     otp: otpController.text.trim(),
                  //     context: context);
                  authProvider.loginWithOTP(
                      mobile: widget.phNo,
                      otp: otpController.text.trim(),
                      context: context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: authProvider.isLoading
                    ? SizedBox(
                        height: h * 0.03,
                        width: h * 0.03,
                        child: CircularProgressIndicator(
                          color: whiteColor,
                          strokeWidth: 3,
                        ),
                      )
                    : Text(
                        'Login',
                        style: GoogleFonts.namdhinggo(
                          textStyle: TextStyle(fontSize: 18, color: whiteColor),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
