import 'package:drive_wise/pages/first_page.dart';
import 'package:drive_wise/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:drive_wise/pages/login_screen.dart'; // Import the LoginScreen

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DriveWise());
}

class DriveWise extends StatefulWidget {
  const DriveWise({super.key});

  @override
  State<DriveWise> createState() => _DriveWiseState();
}

class _DriveWiseState extends State<DriveWise> {
  bool isLoggedIn = false; // Track the user's login status

  // Callback function to update login state when login is successful
  void _onLoginSuccess() {
    setState(() {
      isLoggedIn = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Show LoginScreen if not logged in, otherwise show FirstPage
      home: isLoggedIn
          ? const FirstPage()
          : LoginScreen(onLoginSuccess: _onLoginSuccess),
      routes: {
        '/firstpage': (context) => const FirstPage(),
        '/homepage': (context) => const HomePage(),
      },
    );
  }
}
