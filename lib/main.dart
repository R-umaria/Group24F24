import 'package:drive_wise/pages/first_page.dart';
import 'package:drive_wise/pages/home_page.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


  runApp(const DriveWise());
}

class DriveWise extends StatelessWidget {
  const DriveWise({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const FirstPage(),
      routes: {
        '/firstpage': (context) => const FirstPage(),
        '/homepage': (context) => const HomePage(),
      },
    );
  }
}