import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isTracking = false;
  Stream<Position>? positionStream;
  double currentSpeed = 0.0;

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    // Request location and activity recognition permissions
    await Permission.locationWhenInUse.request();
    await Permission.activityRecognition.request();
    if (await Permission.locationWhenInUse.isDenied) {
      // If permissions are denied, show an alert dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Permissions Denied"),
          content: Text("Location permissions are required for tracking."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            )
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
      print('Latitude: ${position.latitude}, Longitude: ${position.longitude}, Speed: $currentSpeed km/h');
    });
  }

  // Toggle start/stop tracking
  void toggleTracking() {
    if (isTracking) {
      setState(() {
        isTracking = false;
        positionStream = null;
        currentSpeed = 0.0;
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
        title: Text('DriveWise Home'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isTracking ? 'Tracking Started' : 'Tracking Stopped',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              'Current Speed: ${currentSpeed.toStringAsFixed(2)} km/h',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: toggleTracking,
              style: ElevatedButton.styleFrom(
                backgroundColor: isTracking ? Colors.red : Colors.green,
                splashFactory: NoSplash.splashFactory, // Disable splash animation
              ),
              child: Text(isTracking ? 'Stop Trip' : 'Start Trip'),
            ),
          ],
        ),
      ),
    );
  }
}
