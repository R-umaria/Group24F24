// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart'; // Add this package to pubspec.yaml

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(248, 244, 234, 1),
      appBar: AppBar(
        toolbarHeight: 35,
        backgroundColor: const Color.fromRGBO(86, 170, 200, 1),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom Shape Divider with "Hello Driver!" Text (Covers the full width)
            Stack(
              children: [
                ClipPath(
                  clipper: WaveClipperOne(reverse: false, flip: true), // Creates a wavy shape
                  child: Container(
                    height: 105,
                    width: double.infinity, // Ensures it spans the full width
                    color: const Color.fromRGBO(86, 170, 200, 1), // Background color
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: 50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello Driver,",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4), // Small spacing between title and subtext
                      Text(
                        "Let's Start!",
                        style: TextStyle(
                          fontSize: 16, // Smaller font size for subtext
                          color: Colors.white70, // Slightly dimmed white color for contrast
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Rest of the UI inside Padding
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10), // Add spacing after the stack
                  Card(
                    color: const Color.fromRGBO(225, 225, 225, 1),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'Last Trip',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromRGBO(112, 112, 112, 1),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: const Color.fromRGBO(163, 163, 163, 0.5),
                            ),
                            child: Center(
                              child: Text(
                                'Map Placeholder',
                                style: TextStyle(color: Colors.black45),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildDetailRow(
                                    'Date:',
                                    '24/10/2024',
                                    const Color.fromRGBO(112, 112, 112, 1), // Set color here
                                  ),
                                  SizedBox(height: 8),
                                  _buildDetailRow(
                                    'Distance Traveled:',
                                    '36 Kms',
                                    const Color.fromRGBO(112, 112, 112, 1), // Set color here
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Score',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: const Color.fromRGBO(112, 112, 112, 1), // Set color here
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        width: 80, // Adjust width
                                        height: 80, // Adjust height
                                        child: CircularProgressIndicator(
                                          value: 0.75, // Progress value
                                          strokeWidth: 12, // Thickness of the progress bar
                                          backgroundColor: const Color.fromRGBO(0, 0, 0, 0.05),
                                          color: const Color.fromRGBO(170, 200, 86, 1),
                                        ),
                                      ),
                                      Text(
                                        '75',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: const Color.fromRGBO(170, 200, 86, 1),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(50, 50, 50, 1),
                              minimumSize: Size(double.infinity, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'More Details',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(86, 170, 200, 1),
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Set border radius to 10
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Start Trip',
                          style: TextStyle(
                            color: const Color.fromRGBO(255, 255, 255, 1),
                            fontSize: 22,
                          ), // Text color set to white
                        ),
                        SizedBox(width: 8), // Spacing between text and icon
                        Icon(
                          Icons.directions_car,
                          color: const Color.fromRGBO(255, 255, 255, 1), // Set icon color to white
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

  // Helper function to build detail row (Date, Distance, etc.)
  Widget _buildDetailRow(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: color, // Use the passed color
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color, // Use the passed color
          ),
        ),
      ],
    );
  }
}
