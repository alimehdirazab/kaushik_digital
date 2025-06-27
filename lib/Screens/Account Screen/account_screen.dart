import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kaushik_digital/Providers/auth_provider.dart';
import 'package:kaushik_digital/Providers/profile_detail_provider.dart';
import 'package:kaushik_digital/Screens/Account%20Screen/widgets/custom_listtile.dart';
import 'package:kaushik_digital/Screens/Login/login_screen.dart';
import 'package:kaushik_digital/Screens/Profile/profile_screen.dart';
import 'package:kaushik_digital/Screens/Refer%20Table%20Screen/refer_table_screen.dart';
import 'package:kaushik_digital/Screens/Update%20Profile/update_profile_screen.dart';
import 'package:kaushik_digital/Screens/faqs_screen.dart';
import 'package:kaushik_digital/Screens/privacy_policy_screen.dart';
import 'package:kaushik_digital/utils/preferences/user_preferences.dart';
import 'package:provider/provider.dart';

import '../terms_services.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String? persistedName;
  String? persistedPhone;
  String? persistedImage;

  @override
  void initState() {
    super.initState();
    _loadPersistedUser();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadPersistedUser();
  }

  Future<void> _loadPersistedUser() async {
    final data = await UserPreferences.loadProfile();
    setState(() {
      persistedName = data['name'];
      persistedPhone = data['phone'];
      persistedImage = data['userImage'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<ProfileDetailProvider>(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent, // Make status bar transparent
        statusBarIconBrightness: Brightness.dark, // For white icons
      ),
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 5, top: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // 1. Profile
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListTile(
                        onTap: () {
                          log("Tapped on Profile");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfileScreen(),
                            ),
                          );
                        },
                        leading: CircleAvatar(
                          radius: 40,
                          backgroundImage: (persistedImage == null ||
                                  persistedImage!.isEmpty)
                              ? const AssetImage('assets/images/app_logo.png')
                                  as ImageProvider
                              : NetworkImage(persistedImage!),
                        ),
                        title: Text(
                          (persistedName == null || persistedName!.isEmpty)
                              ? "User"
                              : persistedName!,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          (persistedPhone == null || persistedPhone!.isEmpty)
                              ? " "
                              : persistedPhone!,
                          style: const TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color.fromARGB(255, 223, 222, 222),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // 2. Edit Profile
                        CustomListtile(
                          icon: Icons.edit_outlined,
                          text: "Edit Profile",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const UpdateProfileScreen(),
                              ),
                            );
                          },
                        ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Color.fromARGB(255, 223, 222, 222),
                        ),
                        // 3. Refer Table
                        CustomListtile(
                          icon: Icons.table_chart_outlined,
                          text: "Refer Table",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ReferTableScreen(), // Replace with your Refer Table screen
                              ),
                            );
                          },
                        ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Color.fromARGB(255, 223, 222, 222),
                        ),
                        // 4. Payment History
                        CustomListtile(
                          icon: Icons.payment_outlined,
                          text: "Payment History",
                          onTap: () {
                            // Add your Payment History navigation here
                          },
                        ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Color.fromARGB(255, 223, 222, 222),
                        ),
                        // 5. Term of Use
                        CustomListtile(
                          icon: Icons.list_alt_outlined,
                          text: "Term of Use",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const TermsAndConditionsScreen(),
                              ),
                            );
                          },
                        ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Color.fromARGB(255, 223, 222, 222),
                        ),
                        // 6. Privacy Policy
                        CustomListtile(
                          icon: Icons.fact_check_outlined,
                          text: "Privacy Policy",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const PrivacyPolicyScreen(),
                              ),
                            );
                          },
                        ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Color.fromARGB(255, 223, 222, 222),
                        ),
                        // 7. FAQ
                        CustomListtile(
                          icon: Icons.question_answer_outlined,
                          text: "FAQ",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FaqsScreen(),
                              ),
                            );
                          },
                        ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Color.fromARGB(255, 223, 222, 222),
                        ),
                        // 8. About Us
                        CustomListtile(
                          icon: Icons.info_outline,
                          text: "About Us",
                          onTap: () {
                            // Add your About Us navigation here
                          },
                        ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Color.fromARGB(255, 223, 222, 222),
                        ),
                        // 9. Logout
                        CustomListtile(
                          icon: Icons.logout,
                          text: "Logout",
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Logout"),
                                  content: const Text(
                                      "Are you sure you want to logout?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // Call your logout function here
                                        // For example:

                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginScreen()),
                                            (route) => false);
                                      },
                                      child: const Text("Logout"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Color.fromARGB(255, 223, 222, 222),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
