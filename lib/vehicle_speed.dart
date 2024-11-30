import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class VehicleSpeedManager {
  StreamSubscription<Position>? _speedStreamSubscription;
  double currentSpeed = 0.0; // Current speed in meters per second

  // Start tracking vehicle speed
  void startSpeedTracking() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high, // High accuracy for precise updates
      distanceFilter: 5, // Update every 5 meters
    );

    _speedStreamSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      if (position.speed >= 0) {
        currentSpeed = position.speed; // Speed in m/s
        debugPrint('Current speed: ${_formatSpeed(currentSpeed)}');
      }
    });
  }

  // Stop tracking vehicle speed
  void stopSpeedTracking() {
    if (_speedStreamSubscription != null) {
      _speedStreamSubscription?.cancel();
      _speedStreamSubscription = null;
      debugPrint('Speed tracking stopped.');
    } else {
      debugPrint('No active speed tracking to stop.');
    }
  }

  // Format speed to km/h (kilometers per hour)
  String _formatSpeed(double speedInMetersPerSecond) {
    final speedKmPerHour = speedInMetersPerSecond * 3.6; // Convert m/s to km/h
    return '${speedKmPerHour.toStringAsFixed(2)} km/h';
  }

  // Get the current speed formatted as km/h
  String getFormattedSpeed() {
    return _formatSpeed(currentSpeed);
  }
}