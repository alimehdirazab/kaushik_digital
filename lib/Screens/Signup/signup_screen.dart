// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaushik_digital/Screens/Login%20with%20OTP/widgets/ph_no_textfield.dart';
import 'package:kaushik_digital/Screens/Login/widgets/custom_textfield.dart';
import 'package:kaushik_digital/Services/auth_service.dart';
import 'package:kaushik_digital/utils/constants/constants.dart';
import 'package:provider/provider.dart';

import '../../Providers/auth_provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final signUpFormKey = GlobalKey<FormState>();
  final _phoneNumberFormKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _refIDController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_onPhoneChanged);
  }

  void _onPhoneChanged() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (_phoneController.text.length == 10) {
      authProvider.requestOTP(
        mobile: _phoneController.text.trim(),
        context: context,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    _dobController.dispose();
    _refIDController.dispose();
    _phoneController.removeListener(_onPhoneChanged);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black, // Dark background for Netflix theme
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // // Background Image
          // Positioned.fill(
          //   child: Image.asset(
          //     'assets/images/bg-image.jpeg',
          //     // "assets/images/login_image.png", // Replace with your image path
          //     fit: BoxFit.fill, // Ensures the image covers the whole screen
          //   ),
          // ),

          // Foreground Content
          SafeArea(
            left: false,
            right: false,
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 30, right: 30, top: 5, bottom: 20),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      appLogo,
                      height: 80,
                      width: 80,
                    ),
                    SizedBox(height: h * 0.01),
                    Center(
                      child: Text(
                        'Signup',
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      labelText: 'Enter Reference ID',
                      controller: _refIDController,
                    ),
                    const SizedBox(height: 10),
                    Form(
                      key: signUpFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            labelText: 'Enter Your Name',
                            controller: _nameController,
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            isEmail: true,
                            labelText: 'Enter Your Email',
                            controller: _emailController,
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () async {
                              FocusScope.of(context)
                                  .unfocus(); // Hide keyboard if open
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime(2000),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );
                              if (pickedDate != null) {
                                String formattedDate =
                                    "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
                                setState(() {
                                  _dobController.text = formattedDate;
                                });
                              }
                            },
                            child: AbsorbPointer(
                              child: CustomTextField(
                                labelText: 'Select Date of Birth',
                                controller: _dobController,
                                keyboardType: TextInputType.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Form(
                            key: _phoneNumberFormKey,
                            child: PhNoTextfield(
                              controller: _phoneController,
                            ),
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            labelText: 'Enter OTP',
                            controller: _otpController,
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            labelText: 'Enter Your Password',
                            controller: _passwordController,
                            isPassword: true,
                            obsecureText: true,
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: h * 0.065,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (signUpFormKey.currentState!.validate()) {
                            // Signup();
                            authProvider.signUpUser(
                                name: _nameController.text.trim(),
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                                context: context,
                                phone: _phoneController.text.trim(),
                                otp: _otpController.text.trim(),
                                dob: _dobController.text.trim(),
                                refrence_id: _refIDController.text.trim());

                            // print(_refIDController.text);
                            // print(_nameController.text);
                            // print(_phoneController.text);
                            // print(_emailController.text);
                            // print(_passwordController.text);
                            // print(_dobController.text);
                            // print(_otpController.text);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFE50914), // Netflix red
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
                                child: CircularProgressIndicator(
                                  color: whiteColor,
                                  strokeWidth: 3,
                                ),
                              )
                            : Text(
                                'GET STARTED',
                                style: GoogleFonts.namdhinggo(
                                  textStyle: TextStyle(
                                      fontSize: 18, color: whiteColor),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    //Ye working
    // Scaffold(
    //   backgroundColor: whiteColor,
    //   resizeToAvoidBottomInset: false,
    //   // Allow content to adjust for the keyboard
    //   body: SafeArea(
    //     left: false,
    //     right: false,
    //     bottom: false,
    //     child: Padding(
    //       padding:
    //           const EdgeInsets.only(left: 30, right: 30, top: 5, bottom: 20),
    //       // padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: h * 0.0),
    //       child: SingleChildScrollView(
    //         padding: EdgeInsets.only(
    //           bottom: MediaQuery.of(context)
    //               .viewInsets
    //               .bottom, // Adjust for keyboard
    //         ),
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.start,
    //           children: [
    //             Form(
    //               key: signUpFormKey,
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   const SizedBox(
    //                       // height: h * 0.025,
    //                       ),
    //                   // Logo at the top
    //                   Image.asset(
    //                     croppedAppLogo,
    //                     height: 70,
    //                     width: 70,
    //                   ),
    //                   SizedBox(height: h * 0.02),
    //                   // Signup Form
    //                   Center(
    //                     child: Text(
    //                       'Signup',
    //                       style: GoogleFonts.montserrat(
    //                         textStyle: TextStyle(
    //                           fontSize: 30,
    //                           fontWeight: FontWeight.bold,
    //                           color: primaryColor,
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                   const SizedBox(height: 30),

    //                   CustomTextField(
    //                     labelText: 'Enter Your Name',
    //                     controller: _nameController,
    //                     textColor: Colors.black,
    //                     borderColor: Colors.black,
    //                     labelColor: Colors.black,
    //                   ),

    //                   const SizedBox(height: 20),
    //                   CustomTextField(
    //                     labelText: 'Enter Your Phone No',
    //                     keyboardType: TextInputType.number,
    //                     textColor: Colors.black,
    //                     controller: _phoneController,
    //                     borderColor: Colors.black,
    //                     labelColor: Colors.black,
    //                   ),
    //                   const SizedBox(height: 20),
    //                   CustomTextField(
    //                     isEmail: true,
    //                     labelText: 'Enter Your Email',
    //                     controller: _emailController,
    //                     textColor: Colors.black,
    //                     borderColor: Colors.black,
    //                     labelColor: Colors.black,
    //                   ),
    //                   const SizedBox(height: 20),
    //                   CustomTextField(
    //                     labelText: 'Enter Your Password',
    //                     controller: _passwordController,
    //                     borderColor: Colors.black,
    //                     textColor: Colors.black,
    //                     isPassword: true,
    //                     labelColor: Colors.black,
    //                     obsecureText: true,
    //                   ),
    //                   const SizedBox(height: 20),
    //                   DobTextfield(controller: _dobController),
    //                   const SizedBox(height: 8),

    //                   // CustomTextField(
    //                   //   labelText: 'Enter Reference ID',
    //                   //   controller: _refIDController,
    //                   //   borderColor: Colors.black,
    //                   //   textColor: Colors.black,
    //                   //   labelColor: Colors.black,
    //                   // ),
    //                   CustomTextField(
    //                     labelText: 'Enter OTP',
    //                     controller: _otpController,
    //                     keyboardType: TextInputType.number,
    //                     borderColor: Colors.black,
    //                     textColor: Colors.black,
    //                     labelColor: Colors.black,
    //                   ),
    //                   const SizedBox(height: 20),

    //                   // SizedBox(
    //                   //   width: double.infinity,
    //                   //   child: ElevatedButton(
    //                   //     onPressed: () {
    //                   //       if (signUpFormKey.currentState!.validate()) {
    //                   //         // Signup();

    //                   //         print(_refIDController.text);
    //                   //         print(_nameController.text);
    //                   //         print(_phoneController.text);
    //                   //         print(_emailController.text);
    //                   //         print(_passwordController.text);
    //                   //         print(_passwordController.text);
    //                   //         print(_dobController.text);
    //                   //         print(_otpController.text);
    //                   //       }
    //                   //     },
    //                   //     style: ElevatedButton.styleFrom(
    //                   //       backgroundColor: primaryColor,
    //                   //       padding: const EdgeInsets.symmetric(
    //                   //           vertical: 12, horizontal: 32),
    //                   //       shape: RoundedRectangleBorder(
    //                   //         borderRadius: BorderRadius.circular(8),
    //                   //       ),
    //                   //     ),
    //                   //     child: Text(
    //                   //       'GET STARTED',
    //                   //       style: GoogleFonts.namdhinggo(
    //                   //         textStyle:
    //                   //             TextStyle(fontSize: 18, color: whiteColor),
    //                   //       ),
    //                   //     ),
    //                   //   ),
    //                   // ),
    //                 ],
    //               ),
    //             ),
    //             CustomTextField(
    //               labelText: 'Enter Reference ID',
    //               controller: _refIDController,
    //               borderColor: Colors.black,
    //               textColor: Colors.black,
    //               labelColor: Colors.black,
    //             ),
    //             const SizedBox(height: 30),
    //             SizedBox(
    //               width: double.infinity,
    //               child: ElevatedButton(
    //                 onPressed: () {
    //                   if (signUpFormKey.currentState!.validate()) {
    //                     Signup();

    //                     print(_refIDController.text);
    //                     print(_nameController.text);
    //                     print(_phoneController.text);
    //                     print(_emailController.text);
    //                     print(_passwordController.text);
    //                     print(_passwordController.text);
    //                     print(_dobController.text);
    //                     print(_otpController.text);
    //                   }
    //                 },
    //                 style: ElevatedButton.styleFrom(
    //                   backgroundColor: primaryColor,
    //                   padding: const EdgeInsets.symmetric(
    //                       vertical: 12, horizontal: 32),
    //                   shape: RoundedRectangleBorder(
    //                     borderRadius: BorderRadius.circular(8),
    //                   ),
    //                 ),
    //                 child: Text(
    //                   'GET STARTED',
    //                   style: GoogleFonts.namdhinggo(
    //                     textStyle: TextStyle(fontSize: 18, color: whiteColor),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );

//Ye Purana Hai
    // Scaffold(
    //   resizeToAvoidBottomInset: false,
    //   body: Stack(
    //     children: [
    //       // Background Image
    //       Container(
    //         decoration: BoxDecoration(
    //           image: DecorationImage(
    //             image: AssetImage(loginLogo), // Path to your image
    //             fit: BoxFit.cover,
    //           ),
    //         ),
    //       ),
    //       // Transparent Overlay to enhance readability

    //       // Login Form

    //       Container(
    //         padding: EdgeInsets.all(h * 0.04),
    //         child: Image.asset(
    //           croppedAppLogo,
    //           height: 70,
    //           width: 70,
    //         ),
    //       ),
    //       // SizedBox(
    //       //   height: h * 0.1,
    //       // ),
    //       Positioned(
    //         top: 50,
    //         child: Padding(
    //           // padding: const EdgeInsets.all(24.0),
    //           padding: EdgeInsets.symmetric(horizontal: w * 0.14),

    //           child: Form(
    //             child: Column(
    //               mainAxisSize: MainAxisSize.min,
    //               children: [
    //                 Text(
    //                   'Signup',
    //                   style: GoogleFonts.montserrat(
    //                     textStyle: TextStyle(
    //                         fontSize: 30,
    //                         fontWeight: FontWeight.bold,
    //                         color: primaryColor),
    //                   ),
    //                 ),
    //                 SizedBox(height: h * 0.03),
    //                 Form(
    //                     key: signUpFormKey,
    //                     child: Column(
    //                       children: [
    //                         CustomTextField(
    //                           // maxLines: 2,
    //                           labelText: 'Enter Refrence ID',
    //                           controller: _refIDController,
    //                         ),
    //                         SizedBox(height: h * 0.025),
    //                         CustomTextField(
    //                           // maxLines: 2,
    //                           labelText: 'Enter Your Name',
    //                           controller: _nameController,
    //                         ),
    //                         SizedBox(height: h * 0.025),
    //                         CustomTextField(
    //                           // maxLines: 2,
    //                           labelText: 'Enter Your Phone no',
    //                           keyboardType: TextInputType.number,
    //                           controller: _phoneController,
    //                         ),
    //                         SizedBox(height: h * 0.025),

    //                         CustomTextField(
    //                           // maxLines: 2,
    //                           isEmail: true,
    //                           labelText: 'Email Your Email',
    //                           controller: _emailController,
    //                         ),
    //                         SizedBox(height: h * 0.025),
    //                         CustomTextField(
    //                           // maxLines: 2,
    //                           labelText: 'Enter Your Password',
    //                           controller: _passwordController,
    //                           obsecureText: true,
    //                         ),
    //                         SizedBox(height: h * 0.03),

    //                         // const SizedBox(height: 24),
    //                         SizedBox(
    //                           width: double.infinity,
    //                           child: ElevatedButton(
    //                               onPressed: () {
    //                                 if (signUpFormKey.currentState!
    //                                     .validate()) {
    //                                   // Signup();
    //                                 }
    //                                 // Navigator.push(
    //                                 //     context,
    //                                 //     MaterialPageRoute(
    //                                 //         builder: (context) =>
    //                                 //             const OtpScreen()));
    //                                 // Handle login logic here
    //                               },
    //                               style: ElevatedButton.styleFrom(
    //                                 backgroundColor: primaryColor,
    //                                 padding: const EdgeInsets.symmetric(
    //                                     vertical: 12, horizontal: 32),
    //                                 shape: RoundedRectangleBorder(
    //                                   borderRadius: BorderRadius.circular(8),
    //                                 ),
    //                               ),
    //                               child: Text(
    //                                 'GET STARTED',
    //                                 style: GoogleFonts.namdhinggo(
    //                                   textStyle: TextStyle(
    //                                       fontSize: 18, color: whiteColor),
    //                                 ),
    //                               )),
    //                         ),
    //                       ],
    //                     ))
    //               ],
    //             ),
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
