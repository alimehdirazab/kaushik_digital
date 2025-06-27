import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaushik_digital/Providers/home_data_provider.dart';
import 'package:kaushik_digital/Providers/profile_detail_provider.dart';
import 'package:kaushik_digital/Screens/Login%20with%20OTP/widgets/ph_no_textfield.dart';
import 'package:kaushik_digital/Screens/Login/widgets/custom_textfield.dart';
import 'package:kaushik_digital/Services/home_service.dart';
import 'package:kaushik_digital/utils/constants/constants.dart';
import 'package:kaushik_digital/utils/preferences/user_preferences.dart';
import 'package:provider/provider.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final updateProfileFormKey = GlobalKey<FormState>();
  HomeService homeService = HomeService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPersistedUser();
  }

  Future<void> _loadPersistedUser() async {
    final data = await UserPreferences.loadProfile();
    setState(() {
      _nameController.text = data['name'] ?? '';
      _emailController.text = data['email'] ?? '';
      _phoneController.text = data['phone'] ?? '';
      _addressController.text = data['userAddress'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    final userProfileProvider = Provider.of<ProfileDetailProvider>(context);
    final homeProvider = Provider.of<HomeDataProvider>(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: h * 0.08,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "Edit Your Profile",
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              fontSize: 19,
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 10),
          child: Form(
              key: updateProfileFormKey,
              child: Column(
                children: [
                  Column(
                    children: [
                      CustomTextField(
                        labelText: 'Enter Your Name',
                        controller: _nameController,
                        textColor: Colors.black,
                        borderColor: Colors.black,
                        labelColor: Colors.black,
                        // All fields are optional, so no validator
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        labelText: 'Enter Your Email',
                        controller: _emailController,
                        textColor: Colors.black,
                        borderColor: Colors.black,
                        labelColor: Colors.black,
                        // All fields are optional, so no validator
                      ),
                      const SizedBox(height: 20),
                      PhNoTextfield(controller: _phoneController),
                      const SizedBox(height: 8),
                      CustomTextField(
                        labelText: 'Enter Your Address',
                        controller: _addressController,
                        borderColor: Colors.black,
                        textColor: Colors.black,
                        labelColor: Colors.black,
                        // All fields are optional, so no validator
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 0.0, vertical: 10),
                    child: SizedBox(
                      height: h * 0.065,
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            // All fields are optional, so send only those that are changed/non-empty
                            homeProvider.updateProfile(
                                name: _nameController.text.isNotEmpty
                                    ? _nameController.text
                                    : null,
                                email: _emailController.text.isNotEmpty
                                    ? _emailController.text
                                    : null,
                                phone: _phoneController.text.isNotEmpty
                                    ? _phoneController.text
                                    : null,
                                address: _addressController.text.isNotEmpty
                                    ? _addressController.text
                                    : null,
                                userId:
                                    userProfileProvider.userId?.toString() ??
                                        '',
                                context: context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 32),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: homeProvider.isLoading
                              ? SizedBox(
                                  height: h * 0.03,
                                  width: h * 0.03,
                                  child: CircularProgressIndicator(
                                    color: whiteColor,
                                    strokeWidth: 3,
                                  ),
                                )
                              : Text(
                                  'Update Profile',
                                  style: GoogleFonts.namdhinggo(
                                    textStyle: TextStyle(
                                        fontSize: 18, color: whiteColor),
                                  ),
                                )),
                    ),
                  ),
                ],
              )),
        ),
      )),
    );
  }
}
