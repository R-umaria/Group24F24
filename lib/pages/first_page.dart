// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, prefer_final_fields

import 'package:drive_wise/pages/home_page.dart';
import 'package:drive_wise/pages/leader_board_page.dart';
import 'package:drive_wise/pages/profile_page.dart';
import 'package:flutter/material.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  // this keeps track of the selected index
  int _selectedIndex = 0;

  // this method updates the new selected index
  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // the pages we have in our app
  final List _pages = [
    // HomePage
    HomePage(),
    
    // LeaderBoardpage
    LeaderBoardPage(),

    // ProfilePage
    ProfilePage()

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        backgroundColor: Color.fromARGB(255, 225, 225, 225),
        items: [
          // home
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home'
          ),

          // LeaderBoard
          BottomNavigationBarItem(
            icon: Icon(Icons.stacked_line_chart),
            label: 'LeaderBoard'
          ),

          // Profile
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile'
          ),
          ],
        ),
      );
  }
}