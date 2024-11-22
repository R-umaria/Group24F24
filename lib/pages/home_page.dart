import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart'; // Add this package to pubspec.yaml

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(248, 244, 234, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(86, 170, 200, 0.7),
        title: Text(
          "DriveWise",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom Shape Divider with "Hello Driver!" Text
            Stack(
              children: [
                ClipPath(
                  clipper: WaveClipperOne(reverse: false, flip: true), // Creates a wavy shape
                  child: Container(
                    height: 150,
                    color: const Color.fromRGBO(86, 170, 200, 1), // Background color
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: 20,
                  child: Text(
                    "Hello Driver!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20), // Add spacing after the stack
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
                            Text(
                              'Date:',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              '24/10/2024',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Distance Traveled:',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              '36 Kms',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'Score',
                              style: TextStyle(fontSize: 16),
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
                                    backgroundColor: Colors.grey.shade300,
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
                            borderRadius: BorderRadius.circular(10)),
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
            Spacer(),
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
                        fontSize: 22), // Text color set to white
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
    );
  }
}
