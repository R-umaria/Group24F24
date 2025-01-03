//Andy Guest - Dec 2 2024
//frontend for the profile page

import 'package:drive_wise/pages/monthly_reports.dart';
import 'package:flutter/material.dart';
import './parental_settings.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(248, 244, 234, 1), //match to the main screen bg color
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(86, 170, 200, 1),
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //the heading
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Profile & Settings',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(49, 49, 49, 1),
                ),
              ),
            ),
            //profile name and email and avatar 
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(86, 170, 200, 1),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Row(
                children: [                    
                  Container(
                    width: 80.0, ///radius of the circle for the profile icon
                    height: 80.0,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 219, 225, 231), //bg colour for the circle
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.person, //person icon instead of a photo, but we can change
                        color: Colors.white,
                        size: 60.0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Linda Davis', //hardcoded for now
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Lindadavis@gmail.com', //hardcoded for now
                        style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            //buttons for the other options 
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(225, 225, 225, 1),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Column(
                children: [
                  //monthly reports
                    ElevatedButton(
                      onPressed: () {
                        //add link to parental settings here!!!
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MonthlyReportPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: const Color.fromRGBO(49, 49, 49, 1),
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, //to seperate text from the icon on the right
                        children: [
                          Text(
                            'Check Monthly Reports',
                            style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 1), 
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Icon(
                            Icons.assessment_rounded,
                            color: Color.fromRGBO(255, 255, 255, 1), 
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 13),

                 //parental settings button 
                  ElevatedButton(
                      onPressed: () {
                        //add link to parental settings here!!!
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ParentalSettingsPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: const Color.fromRGBO(49, 49, 49, 1),
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, //to seperate text from the icon on the right
                        children: [
                          Text(
                            'Parental Settings',
                            style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 1), 
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Icon(
                            Icons.people,
                            color: Color.fromRGBO(255, 255, 255, 1), 
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 13), //adds spacer between the buttons so they arent squished
                  
                  //setttings
                  ElevatedButton(
                      onPressed: () {
                        //if we decide to add settings the link here
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: const Color.fromRGBO(49, 49, 49, 1),
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, //to seperate text from the icon on the right
                        children: [
                          Text(
                            'Account Settings',
                            style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 1),  
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Icon(
                            Icons.settings,
                            color: Color.fromRGBO(255, 255, 255, 1),  
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
