import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaushik_digital/Providers/auth_provider.dart';
import 'package:kaushik_digital/Screens/Login%20with%20OTP/widgets/ph_no_textfield.dart';
import 'package:kaushik_digital/Services/auth_service.dart';
import 'package:kaushik_digital/utils/constants/constants.dart';
import 'package:provider/provider.dart';

class SignupPhnoScreen extends StatefulWidget {
  const SignupPhnoScreen({super.key});

  @override
  State<SignupPhnoScreen> createState() => _SignupPhnoScreenState();
}

class _SignupPhnoScreenState extends State<SignupPhnoScreen> {
  final TextEditingController phoneController = TextEditingController();
  AuthService authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  @override
  // void dispose() {
  //   phoneController.dispose();
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
        title: Text("Phone ",
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                fontSize: 19,
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: h * 0.02,
            ),
            Center(
              child: Text("Enter your phone number",
                  style: GoogleFonts.abel(
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ),
            SizedBox(
              height: h * 0.03,
            ),
            SizedBox(
                width: w * 0.75,
                child: Form(
                  key: _formKey,
                  child: PhNoTextfield(
                    controller: phoneController,
                  ),
                )),
            SizedBox(
              height: h * 0.025,
            ),
            SizedBox(
              width: w * 0.75,
              height: h * 0.065,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    authProvider.requestOTP(
                        mobile: phoneController.text, context: context);
                    // authService.requestOTP(
                    //     mobile: phoneController.text, context: context);
                    // // 7367992087
                  }
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => const SignupScreen()));
                  // print(phoneController.text);
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
                        'Next',
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
