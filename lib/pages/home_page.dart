// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../filters/moving_average_filter.dart';
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
  double rotationRate = 0.0;

  // For filtering
  late MovingAverageFilter accelerationFilter;

  @override
  void initState() {
    super.initState();
    requestPermissions();
    accelerationFilter = MovingAverageFilter(windowSize: 5);
    startAccelerometerTracking();
    startGyroscopeTracking();
  }

 Future<void> requestPermissions() async {
    // Request location and activity recognition permissions
    await Permission.locationWhenInUse.request();
    await Permission.activityRecognition.request();
    if (await Permission.locationWhenInUse.isDenied) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Permissions Denied"),
          content: const Text("Location permissions are required for tracking."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }


  // Start GPS tracking
  void startTracking() {
    positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 5, // meters
      ),
    );

    positionStream?.listen((Position position) {
      setState(() {
        currentSpeed = position.speed * 3.6; // convert m/s to km/h
      });
      print(
          'Latitude: ${position.latitude}, Longitude: ${position.longitude}, Speed: $currentSpeed km/h');
    });
  }

  // Tracking acceleration using Accelerometer
  void startAccelerometerTracking() {
    accelerometerEvents.listen((AccelerometerEvent event) {
      double rawAcceleration = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

      // Apply Moving Average Filter
      double smoothedAcceleration = accelerationFilter.apply(rawAcceleration);

      setState(() {
        acceleration = smoothedAcceleration;
      });

      // print('Raw Acceleration: $rawAcceleration, Smoothed Acceleration: $smoothedAcceleration');
    });
  }

    // Tracking sharp turns using Gyroscope
  void startGyroscopeTracking() {
    gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        rotationRate = event.y;
      });
      if (rotationRate > 3.0 || rotationRate < -3.0) {
        // print('Sharp turn detected! Rotation rate: $rotationRate');
      }
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
        rotationRate = 0.0;
      });
    } else {
      setState(() {
        isTracking = true;
        startTracking();
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
              'Speed: ${currentSpeed.toStringAsFixed(2)} km/h',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Acceleration: ${acceleration.toStringAsFixed(2)} m/s²',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text(
              'Rotation Rate: ${rotationRate.toStringAsFixed(2)} rad/s',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: toggleTracking,
              style: ElevatedButton.styleFrom(
                backgroundColor: isTracking ? Colors.red : Colors.green,
                splashFactory: NoSplash.splashFactory,
              ),
              child: Text(isTracking ? 'Stop Trip' : 'Start Trip'),
            ),
          ],
        ),
      ),
    );
  }
}
