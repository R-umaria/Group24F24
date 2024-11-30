// sensors.dart
// Handles accelerometer and gyroscope sensor tracking for DriveWise

import 'dart:async';
import 'dart:math'; // Import for sqrt
import 'package:sensors_plus/sensors_plus.dart';

class SensorData {
  // Stream subscriptions for accelerometer and gyroscope
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;

  // Thresholds for detecting events
  final double accelerationThreshold = 15; // Sudden braking/acceleration threshold (m/s^2)
  final double gyroscopeThreshold = 4.0;    // Sharp turn threshold (rad/s)

  // Event callback functions
  void Function(String event)? onEventDetected;

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
  void _analyzeAccelerometerData(AccelerometerEvent event) {
    final double totalAcceleration =
        sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

    if (totalAcceleration > accelerationThreshold) {
      onEventDetected?.call("Sudden Acceleration/Braking Detected");
    }
  }

  // Analyze gyroscope data to detect sharp turns
  void _analyzeGyroscopeData(GyroscopeEvent event) {
    final double angularVelocity =
        sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

    if (angularVelocity > gyroscopeThreshold) {
      onEventDetected?.call("Sharp Turn Detected");
    }
  }
}
