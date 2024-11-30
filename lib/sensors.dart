// File path: lib/sensors.dart
// Handles accelerometer and gyroscope sensor tracking for DriveWise

import 'dart:async';
import 'dart:math'; // Import for sqrt
import 'package:drive_wise/database_helper.dart'; // Import database helper
import 'package:sensors_plus/sensors_plus.dart';
import 'package:drive_wise/gps.dart';
import 'package:drive_wise/vehicle_speed.dart';

class SensorData {
  // Stream subscriptions for accelerometer and gyroscope
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;

  // Thresholds for detecting events
  final double accelerationThreshold = 15; // Sudden braking/acceleration threshold (m/s^2)
  final double gyroscopeThreshold = 4.0;    // Sharp turn threshold (rad/s)

  // Event callback functions
  void Function(String event)? onEventDetected;

  // Database helper instance
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Speed manager instance
  final VehicleSpeedManager _speedManager = VehicleSpeedManager();

  // Start listening to sensor data
  void startSensors() {
    _accelerometerSubscription = accelerometerEvents.listen((event) {
      _analyzeAccelerometerData(event);
    });

    _gyroscopeSubscription = gyroscopeEvents.listen((event) {
      _analyzeGyroscopeData(event);
    });
  }

  // Stop listening to sensor data
  void stopSensors() {
    _accelerometerSubscription?.cancel();
    _gyroscopeSubscription?.cancel();
    _accelerometerSubscription = null;
    _gyroscopeSubscription = null;
  }

  // Analyze accelerometer data to detect sudden braking/acceleration
  void _analyzeAccelerometerData(AccelerometerEvent event) async {
    final double totalAcceleration =
        sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

    if (totalAcceleration > accelerationThreshold) {
      _logEvent("Sudden Acceleration/Braking Detected");
      onEventDetected?.call("Sudden Acceleration/Braking Detected");
    }
  }

  // Analyze gyroscope data to detect sharp turns
  void _analyzeGyroscopeData(GyroscopeEvent event) async {
    final double angularVelocity =
        sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

    if (angularVelocity > gyroscopeThreshold) {
      _logEvent("Sharp Turn Detected");
      onEventDetected?.call("Sharp Turn Detected");
    }
  }

  // Log detected events into the SQLite database
  Future<void> _logEvent(String eventType) async {
    final double currentLat = currentLatitude ?? 0.0; // Get current latitude
    final double currentLng = currentLongitude ?? 0.0; // Get current longitude
    final double currentSpeed = await _speedManager.getCurrentSpeed(); // Get current speed
    final String timestamp = DateTime.now().toIso8601String(); // Current timestamp

    await _dbHelper.insertEvent({
      'event_type': eventType,
      'timestamp': timestamp,
      'latitude': currentLat,
      'longitude': currentLng,
      'speed': currentSpeed,
    });

    print("Event logged: $eventType at $timestamp, Lat: $currentLat, Lng: $currentLng, Speed: $currentSpeed");
  }
}
