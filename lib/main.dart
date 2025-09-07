import 'package:flutter/material.dart';
import 'package:kaushik_digital/Providers/auth_provider.dart';
import 'package:kaushik_digital/Providers/home_data_provider.dart';
import 'package:kaushik_digital/Providers/search_provider.dart';
import 'package:kaushik_digital/Providers/user_details_provider.dart';
import 'package:kaushik_digital/Providers/user_provider.dart';
import 'package:kaushik_digital/Screens/Splash%20Screen/splash_screen.dart';
import 'package:provider/provider.dart';

import 'Providers/profile_detail_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final profileProvider = ProfileDetailProvider();
  await profileProvider.loadFromPrefs();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ProfileDetailProvider>.value(
            value: profileProvider),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => UserDetailsProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => HomeDataProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'NetflixSans',
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
        primaryColor: const Color(0xffE50914), // Netflix red
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(color: Colors.white),
          displayMedium: TextStyle(color: Colors.white),
          displaySmall: TextStyle(color: Colors.white),
          headlineLarge: TextStyle(color: Colors.white),
          headlineMedium: TextStyle(color: Colors.white),
          headlineSmall: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
          titleSmall: TextStyle(color: Colors.white),
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white70),
          labelLarge: TextStyle(color: Colors.white),
          labelMedium: TextStyle(color: Colors.white),
          labelSmall: TextStyle(color: Colors.white70),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xffE50914),
            foregroundColor: Colors.white,
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          fillColor: Color(0xff333333),
          filled: true,
          labelStyle: TextStyle(color: Colors.white70),
          hintStyle: TextStyle(color: Colors.white38),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white24),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffE50914)),
          ),
        ),
        cardColor: const Color(0xff1a1a1a),
        dividerColor: Colors.white24,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      darkTheme: ThemeData(
        fontFamily: 'NetflixSans',
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
        primaryColor: const Color(0xffE50914),
        scaffoldBackgroundColor: Colors.black,
      ),
      themeMode: ThemeMode.dark, // Force dark mode
      home: const SplashScreen(),
    );
  }
}
