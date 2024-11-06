import 'package:drive_wise/pages/first_page.dart';
import 'package:drive_wise/pages/home_page.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(DriveWise());
}

class DriveWise extends StatelessWidget {
  const DriveWise({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirstPage(),
      routes: {
        '/firstpage': (context) => FirstPage(),
        '/homepage': (context) => HomePage(),
      },
    );
  }
}