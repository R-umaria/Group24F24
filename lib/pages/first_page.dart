// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, prefer_final_fields

import 'package:drive_wise/pages/home_page.dart';
import 'package:drive_wise/pages/Leaderboard/leaderboard_page.dart';
import 'package:drive_wise/pages/my_trips.dart';
import 'package:drive_wise/pages/profile_page.dart';
import './Awards/awards_page.dart';
import './Awards/award_backend.dart';
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

  //create an instance of the award backend to use for the awrds page
  final awardsManager1 = AwardsManager();
  late final List _pages;
  
  // the pages we have in our app
    @override
  void initState() {
    super.initState();
      _pages = [
      // HomePage
      HomePage(),
      
      // My Trips
      MyTrips(),

      // LeaderBoardpage
      LeaderboardPage(),

      //added the awards page
      AwardsPage(awardsManager: awardsManager1,),

      // ProfilePage
      ProfilePage()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        backgroundColor: Color.fromRGBO(225, 225, 225, 1), // Set the background color
        selectedItemColor: Color.fromRGBO(50, 50, 50, 1), // Set selected item color
        unselectedItemColor: Color.fromRGBO(112, 112, 112, 1), // Set unselected item color
        selectedLabelStyle: TextStyle(color: Color.fromRGBO(50, 50, 50, 1)), // Set color for selected label
        unselectedLabelStyle: TextStyle(color: Color.fromRGBO(112, 112, 112, 1)), // Set color for unselected label
        type: BottomNavigationBarType.fixed, // This ensures that the BottomNavigationBar shows all icons in a row
        items: [
          // Home
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),

          // My Trips
          BottomNavigationBarItem(
            icon: Icon(Icons.restore),
            label: 'My Trips',
          ),

          // LeaderBoard
          BottomNavigationBarItem(
            icon: Icon(Icons.stacked_line_chart),
            label: 'Leaderboard',
          ),
    
          //awards page
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Awards'
          ),

          // Profile
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          ],
        ),
      );
  }
}
