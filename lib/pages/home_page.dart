import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../filters/savitzky_golay_filter.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isTracking = false;
  Stream<Position>? positionStream;
  double currentSpeed = 0.0;
  double acceleration = 0.0;

  // For filtering
  final List<double> accelerationData = [];
  late SavitzkyGolayFilter sgFilter;

  @override
  void initState() {
    super.initState();
    requestPermissions();
    sgFilter = SavitzkyGolayFilter(windowSize: 5, polynomialOrder: 3);
    startAccelerometerTracking();
  }

  Future<void> requestPermissions() async {
    await Permission.locationWhenInUse.request();
    await Permission.activityRecognition.request();
  }

  // Tracking acceleration using Accelerometer
  void startAccelerometerTracking() {
    accelerometerEvents.listen((AccelerometerEvent event) {
      double rawAcceleration = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

      // Store data for filtering
      accelerationData.add(rawAcceleration);
      if (accelerationData.length > 20) {
        accelerationData.removeAt(0); // Keep only the latest 20 readings
      }

      // Apply Savitzky-Golay filtering
      double smoothedAcceleration = rawAcceleration;
      if (accelerationData.length >= 5) {
        List<double> smoothedData = sgFilter.apply(accelerationData);
        smoothedAcceleration = smoothedData.last;
      }

      setState(() {
        acceleration = smoothedAcceleration;
      });

      print('Raw Acceleration: $rawAcceleration, Smoothed Acceleration: $smoothedAcceleration');
    });
  }

  // Toggle start/stop tracking
  void toggleTracking() {
    if (isTracking) {
      setState(() {
        isTracking = false;
        positionStream = null;
        currentSpeed = 0.0;
        acceleration = 0.0;
      });
    } else {
      setState(() {
        isTracking = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DriveWise Home'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isTracking ? 'Tracking Started' : 'Tracking Stopped',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Text(
              'Smoothed Acceleration: ${acceleration.toStringAsFixed(2)} m/s²',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: toggleTracking,
              style: ElevatedButton.styleFrom(
                backgroundColor: isTracking ? Colors.red : Colors.green,
              ),
              child: Text(isTracking ? 'Stop Trip' : 'Start Trip'),
            ),
          ],
        ),
      ),
    );
  }
}
