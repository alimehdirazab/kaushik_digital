import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kaushik_digital/Screens/Login/login_screen.dart';
import 'package:kaushik_digital/Screens/Navbar/navbar.dart';
import 'package:kaushik_digital/utils/constants/constants.dart';
import 'package:provider/provider.dart';
import 'package:kaushik_digital/Providers/profile_detail_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    _navigationTimer = Timer(const Duration(seconds: 3), () async {
      // Check if widget is still mounted before proceeding
      if (!mounted) return;
      
      final profileProvider =
          Provider.of<ProfileDetailProvider>(context, listen: false);
      // Ensure profile is loaded from prefs if not already
      if (profileProvider.userId == null) {
        await profileProvider.loadFromPrefs();
      }
      
      // Check again if widget is still mounted before navigation
      if (!mounted) return;
      
      if (profileProvider.userId != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyNavBar()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          color: whiteColor,
          child: Center(
            child: Image.asset(appLogo, height: h * 0.25),
          ),
        ),
      ),
    );
  }
}
