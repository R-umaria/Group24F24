// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart'; // Add this package to pubspec.yaml
import 'package:drive_wise/gps.dart'; // Import the GPS tracking module
import 'package:drive_wise/sensors.dart'; // Import sensors tracking
import 'package:drive_wise/auto_trip.dart'; // Import Auto Trip Manager

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isTripActive = false; // Track if the trip is active
  final SensorData _sensorData = SensorData(); // Instance of SensorData
  final AutoTripManager _autoTripManager = AutoTripManager(); // Instance of AutoTripManager

  @override
  void initState() {
    super.initState();

    // Start auto trip monitoring
    _autoTripManager.startMonitoring(context);

    // Event handler for detected sensor events
    _sensorData.onEventDetected = (event) {
      debugPrint(event); // Log detected events in terminal
    };

    // Sync AutoTripManager's state with HomePage state
    _autoTripManager.isTripActive = isTripActive;
  }

  @override
  void dispose() {
    _sensorData.stopSensors(); // Stop sensors if the widget is disposed
    stopGpsTracking(); // Stop GPS tracking
    super.dispose();
  }

  // Function to manually toggle trip start/stop
  void _toggleTrip() async {
    if (isTripActive) {
      // Stop GPS and sensor tracking
      stopGpsTracking();
      _sensorData.stopSensors();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Trip stopped!"),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      // Start GPS and sensor tracking
      await gpsTracking();
      _sensorData.startSensors();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Trip started!"),
          duration: Duration(seconds: 2),
        ),
      );
    }

    // Update the state and sync with AutoTripManager
    setState(() {
      isTripActive = !isTripActive;
      _autoTripManager.isTripActive = isTripActive;
    });
  }

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
            // Custom Shape Divider with "Hello Driver!" Text
            Stack(
              children: [
                ClipPath(
                  clipper: WaveClipperOne(reverse: false, flip: true),
                  child: Container(
                    height: 105,
                    width: double.infinity,
                    color: const Color.fromRGBO(86, 170, 200, 1),
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
                      SizedBox(height: 4),
                      Text(
                        "Let's Start!",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Main Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
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
                                    const Color.fromRGBO(112, 112, 112, 1),
                                  ),
                                  SizedBox(height: 8),
                                  _buildDetailRow(
                                    'Distance Traveled:',
                                    '36 Kms',
                                    const Color.fromRGBO(112, 112, 112, 1),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Score',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: const Color.fromRGBO(112, 112, 112, 1),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        width: 80,
                                        height: 80,
                                        child: CircularProgressIndicator(
                                          value: 0.75,
                                          strokeWidth: 12,
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
                    onPressed: _toggleTrip, // Manual trip toggle
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isTripActive
                          ? Colors.red // Red for "Stop Trip"
                          : const Color.fromRGBO(86, 170, 200, 1), // Blue for "Start Trip"
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isTripActive ? 'Stop Trip' : 'Start Trip',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.directions_car,
                          color: Colors.white,
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

  // Helper function to build detail row
  Widget _buildDetailRow(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: color,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
