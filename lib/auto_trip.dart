// File path: lib/auto_trip.dart
import 'package:flutter/material.dart';
import 'package:drive_wise/gps.dart';
import 'package:drive_wise/sensors.dart';
import 'package:drive_wise/vehicle_speed.dart'; // Speed tracking manager
import 'package:drive_wise/database_helper.dart'; // Database helper
import 'package:pedometer/pedometer.dart'; // Step counter for auto trip functionality
import 'dart:math'; // For math functions like sqrt, sin, cos, etc.

class AutoTripManager {
  final SensorData _sensorData = SensorData();
  final VehicleSpeedManager _speedManager = VehicleSpeedManager();
  final DatabaseHelper _dbHelper = DatabaseHelper(); // Database instance
  Stream<StepCount>? _stepCountStream;
  bool isTripActive = false;
  int? lastStepCount;
  double lastLatitude = 0.0;
  double lastLongitude = 0.0;

  AutoTripManager() {
    _initStepCounter();
  }

  // Initialize step counter stream
  void _initStepCounter() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream?.listen((StepCount stepCount) {
      lastStepCount = stepCount.steps;
    }).onError((error) {
      print("Step Counter Error: $error");
    });
  }

  // UnComment to enable AutoTrip
  //  // Start monitoring for auto trip
  // void startMonitoring(BuildContext context) {
  //   gpsTracking(); // Start GPS tracking

  //   const locationChangeThreshold = 10.0; // Minimum change in meters
  //   const stepStopThreshold = 3; // Steps needed to stop the trip

  //   // Periodically check the conditions
  //   Stream.periodic(Duration(seconds: 3)).listen((_) async {
  //     // Get current location
  //     final currentLat = currentLatitude ?? 0.0; // Handle null values
  //     final currentLng = currentLongitude ?? 0.0;

  //     // Compute distance change
  //     final distanceMoved = _calculateDistance(
  //       lastLatitude,
  //       lastLongitude,
  //       currentLat,
  //       currentLng,
  //     );

  //     // Conditions to start a trip
  //     if (!isTripActive &&
  //         distanceMoved > locationChangeThreshold &&
  //         (lastStepCount == null || lastStepCount! == 0)) {
  //       isTripActive = true;
  //       _startTrip(context, currentLat, currentLng);
  //     }

  //     // Conditions to stop a trip
  //     if (isTripActive &&
  //         distanceMoved < locationChangeThreshold &&
  //         lastStepCount != null &&
  //         lastStepCount! >= stepStopThreshold) {
  //       isTripActive = false;
  //       _stopTrip(context, currentLat, currentLng);
  //     }

  //     // Update last location
  //     lastLatitude = currentLat;
  //     lastLongitude = currentLng;
  //   });

  //   // Monitor sensor events
  //   _sensorData.onEventDetected = (eventType) async {
  //     if (isTripActive) {
  //       final currentLat = currentLatitude ?? 0.0;
  //       final currentLng = currentLongitude ?? 0.0;
  //       final currentSpeed = await _speedManager.getCurrentSpeed();
  //      // _sensorData.logEvent(eventType);
  //     }
  //   };
  // }

  void _startTrip(BuildContext context, double lat, double lng) async {
    // Start sensors and speed tracking
    _sensorData.startSensors();
    _speedManager.startSpeedTracking();

    final speed = await _speedManager.getCurrentSpeed();
    //_sensorData.logEvent("start");

    // Notify UI
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Auto trip started!"),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _stopTrip(BuildContext context, double lat, double lng) async {
    // Stop sensors and speed tracking
    _sensorData.stopSensors();
    _speedManager.stopSpeedTracking();
    stopGpsTracking();

    final speed = await _speedManager.getCurrentSpeed();
    //_sensorData.logEvent("stop");

    // Notify UI
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Auto trip stopped!"),
        duration: Duration(seconds: 1),
      ),
    );
  }



  // Utility function to calculate distance between two coordinates
  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371e3; // Earth's radius in meters
    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c; // Distance in meters
  }

  double _degreesToRadians(double degrees) => degrees * (pi / 180);
}
