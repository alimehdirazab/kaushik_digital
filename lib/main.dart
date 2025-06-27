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
        // ...you can add other theme properties here if needed...
      ),
      home: const SplashScreen(),
      // MyHomePage()
      //  CourseScreen(name:"ebad")
    );
  }
}
