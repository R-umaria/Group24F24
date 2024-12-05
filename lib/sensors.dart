// File path: lib/sensors.dart
// Handles accelerometer and gyroscope sensor tracking for DriveWise

import 'dart:async';
import 'dart:math'; // Import for sqrt
import 'package:drive_wise/database_helper.dart'; // Import database helper
import 'package:sensors_plus/sensors_plus.dart';
import 'package:drive_wise/gps.dart';
import 'package:drive_wise/vehicle_speed.dart';
import 'package:drive_wise/filters/moving_average_filter.dart'; // Import the Moving Average Filter

class SensorData {
  // Stream subscriptions for accelerometer and gyroscope
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;

  // Thresholds for detecting events
  final double accelerationThreshold = 13; // Threshold for significant acceleration/braking (m/s^2)
  final double gyroscopeThreshold = 3.0;  // Threshold for sharp turns (rad/s)

  // Event counters
  int suddenAccelerationCount = 0;
  int suddenBrakingCount = 0;
  int sharpTurnCount = 0;

  // Event callback functions
  void Function(String event)? onEventDetected;

  // Database helper instance
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Speed manager instance
  final VehicleSpeedManager _speedManager = VehicleSpeedManager();

  //sped tracking
  final VehicleSpeedManager _vehicleSpeedManager = VehicleSpeedManager();

  // Moving Average Filters
  final MovingAverageFilter accelerometerFilter = MovingAverageFilter(windowSize: 5);
  final MovingAverageFilter gyroscopeFilter = MovingAverageFilter(windowSize: 5);

  // To prevent duplicate logging within the same second
  String? _lastLoggedTimestamp;

  // Start listening to sensor data
  void startSensors() {
    _accelerometerSubscription = accelerometerEvents.listen((event) {
      _analyzeAccelerometerData(event);
    });

    _gyroscopeSubscription = gyroscopeEvents.listen((event) {
      _analyzeGyroscopeData(event);
    });

    _vehicleSpeedManager.startSpeedTracking(); //added speed tracking here

  }

  // Stop listening to sensor data
  void stopSensors() {
    _accelerometerSubscription?.cancel();
    _gyroscopeSubscription?.cancel();
    _accelerometerSubscription = null;
    _gyroscopeSubscription = null;
    _vehicleSpeedManager.stopSpeedTracking();  //added for speed tracking
  }

  // Analyze accelerometer data to detect sudden braking/acceleration
  void _analyzeAccelerometerData(AccelerometerEvent event) async {
    // Calculate raw total acceleration
    final double rawTotalAcceleration =
        sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

    // Apply the moving average filter
    final double smoothedAcceleration = accelerometerFilter.apply(rawTotalAcceleration);

    // Use this for testing with and without the filter:
    // Uncomment the next line to test without the filter.
    // final double smoothedAcceleration = rawTotalAcceleration;

    if (smoothedAcceleration > accelerationThreshold) {
      if (event.z > 0) {
        // Sudden acceleration
        suddenAccelerationCount++;
        _logEvent("Sudden Acceleration Detected");
        onEventDetected?.call("Sudden Acceleration Detected");
      } else {
        // Sudden braking
        suddenBrakingCount++;
        _logEvent("Sudden Braking Detected");
        onEventDetected?.call("Sudden Braking Detected");
      }
    }
  }

  // Analyze gyroscope data to detect sharp turns
  void _analyzeGyroscopeData(GyroscopeEvent event) async {
    // Calculate raw angular velocity
    final double rawAngularVelocity =
        sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

    // Apply the moving average filter
    final double smoothedAngularVelocity = gyroscopeFilter.apply(rawAngularVelocity);

    // Use this for testing with and without the filter:
    // Uncomment the next line to test without the filter.
    // final double smoothedAngularVelocity = rawAngularVelocity;

    if (smoothedAngularVelocity > gyroscopeThreshold) {
      sharpTurnCount++;
      _logEvent("Sharp Turn Detected");
      onEventDetected?.call("Sharp Turn Detected");
    }
  }

  // Log detected events into the SQLite database
  Future<void> _logEvent(String eventType) async {
    // Get the current timestamp in seconds only
    final String timestamp = DateTime.now().toIso8601String().split('.').first;

    // Ignore duplicate events occurring within the same second
    if (_lastLoggedTimestamp == timestamp) {
      print("Duplicate event ignored at $timestamp");
      return;
    }

    _lastLoggedTimestamp = timestamp;

    final double currentLat = currentLatitude ?? 0.0; // Get current latitude
    final double currentLng = currentLongitude ?? 0.0; // Get current longitude
    final double currentSpeed = await _speedManager.getCurrentSpeed(); // Get current speed

    await _dbHelper.insertEvent({
      'event_type': eventType,
      'timestamp': timestamp,
      'latitude': currentLat,
      'longitude': currentLng,
      'speed': currentSpeed,
    });

    print("Event logged: $eventType at $timestamp, Lat: $currentLat, Lng: $currentLng, Speed: $currentSpeed");
  }

  // Public wrapper for logging events
  Future<void> logEvent(String eventType) async {
    await _logEvent(eventType); // Call the private method
  }

  // Optional: Reset event counters
  void resetEventCounters() {
    suddenAccelerationCount = 0;
    suddenBrakingCount = 0;
    sharpTurnCount = 0;
  }
}
