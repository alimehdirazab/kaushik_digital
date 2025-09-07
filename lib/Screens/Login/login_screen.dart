import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaushik_digital/Providers/auth_provider.dart';
import 'package:kaushik_digital/Screens/Login%20with%20OTP/ph_no_screen.dart';
import 'package:kaushik_digital/Screens/Login/widgets/custom_textfield.dart';
import 'package:kaushik_digital/Screens/Signup/signup_screen.dart';
import 'package:kaushik_digital/utils/constants/constants.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final signinFormKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black, // Netflix dark background
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          // App Logo
          SizedBox(height: h * 0.07), // Add some space at the top
          Image.asset(
            appLogo,
            height: 80,
            width: 80,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Login',
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white), // White text for dark mode
                      )),
                  SizedBox(height: h * 0.025),
                  Form(
                      key: signinFormKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            labelText: 'Enter Your number or email',
                            isEmail: true,
                            controller: emailController,
                          ),
                          SizedBox(height: h * 0.025),
                          CustomTextField(
                            labelText: 'Enter Your Password',
                            controller: passwordController,
                            obsecureText: true,
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            height: h * 0.065,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                FocusScope.of(context)
                                    .unfocus(); // Close keyboard
                                if (signinFormKey.currentState!.validate()) {
                                  authProvider.loginUser(
                                    username: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                    context: context,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffE50914), // Netflix red
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 32),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: authProvider.isLoading
                                  ? SizedBox(
                                      height: h * 0.03,
                                      width: h * 0.03,
                                      child: const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      ),
                                    )
                                  : Text(
                                      'Login',
                                      style: GoogleFonts.namdhinggo(
                                          textStyle: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.white)),
                                    ),
                            ),
                          ),
                        ],
                      )),
                  SizedBox(
                    height: h * 0.025,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'New to App? ',
                        style: GoogleFonts.namdhinggo(
                            textStyle: const TextStyle(
                                fontSize: 18,
                                color: Colors.white70,
                                fontWeight: FontWeight.bold)),
                      ),
                      GestureDetector(
                        onTap: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignupScreen()));
                        },
                        child: Text('Sign up now',
                            style: GoogleFonts.namdhinggo(
                              textStyle: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  decorationColor: Color(0xffE50914),
                                  fontSize: 18,
                                  color: Color(0xffE50914), // Netflix red
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: h * 0.02,
                  ),
                  Text(
                    'or',
                    style: GoogleFonts.namdhinggo(
                        textStyle: const TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                            fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    height: h * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const PhNoScreen()));
                        },
                        child: Text('Login with OTP',
                            style: GoogleFonts.namdhinggo(
                              textStyle: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  decorationColor: Color(0xffE50914),
                                  fontSize: 18,
                                  color: Color(0xffE50914), // Netflix red
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                    ],
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
