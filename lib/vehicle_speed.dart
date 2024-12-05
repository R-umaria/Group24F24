import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import './behaviour_analysis/speed_analysis.dart';

class VehicleSpeedManager {
  StreamSubscription<Position>? _speedStreamSubscription;
  double _currentSpeed = 0.0; // Current speed in meters per second

  //this is for behaviour analysis
  SpeedAnalysisTimer timer = SpeedAnalysisTimer();

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
        _currentSpeed = position.speed; // Speed in m/s

        debugPrint('Current speed: ${_formatSpeed(_currentSpeed)}');


        //adding this for speed behaviour analysis
        SpeedAnalysis analysis = analyzeSpeed(_currentSpeed, 60, timer);
        timer.update();
        debugPrint('status: ${analysis.message}');        
      }
    });
  }

  // Stop tracking vehicle speed
  void stopSpeedTracking() {
    if (_speedStreamSubscription != null) {
      _speedStreamSubscription?.cancel();
      _speedStreamSubscription = null;
      debugPrint('Speed tracking stopped.');

      //adding this for speed behaviour analysis
      speedAnalysisReport(timer);
      
    } else {
      debugPrint('No active speed tracking to stop.');
    }
  }

  // Get the current speed in meters per second
  double getCurrentSpeed() {
    return _currentSpeed;
  }

  // Format speed to km/h (kilometers per hour)
  String _formatSpeed(double speedInMetersPerSecond) {
    final speedKmPerHour = speedInMetersPerSecond * 3.6; // Convert m/s to km/h
    return '${speedKmPerHour.toStringAsFixed(2)} km/h';
  }

  // Get the current speed formatted as km/h
  String getFormattedSpeed() {
    return _formatSpeed(_currentSpeed);
  }
}
