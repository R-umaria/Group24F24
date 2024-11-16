//Andy Guest - Nov 15 2024
//driving behaviour analysis of speed limit compared to current speed

import 'package:flutter/material.dart';

//state based on the comparison between the current speed and the limit (based on our chosen thresholds)
//currently set for city driving but adjusted thresholds will be added for highway driving later
enum SpeedState {
  good, //less than 11km/hr over the limit on city streets
  warning, //12-19km/hr over limit on city streets
  dangerous //20+ km/hr over limit on city streets 
}

class SpeedAnalysis {
  final SpeedState state;
  final String message; //to show to the user if they are going too fast
  final double currentSpeed;
  final int speedLimit;

  SpeedAnalysis({
    required this.state,
    required this.message,
    required this.currentSpeed,
    required this.speedLimit,
  });
}

//analyze current speed vs speed limit
SpeedAnalysis analyzeSpeed(double currentSpeed, int speedLimit) {
  //if the speed limit cannot be found, default values will be used
  if (speedLimit == 0) {
    speedLimit = 60; //default assuming the user is driving on city streets (60km/h) - will try to add highway default later as well
    debugPrint('No speed limit data available, using default city speed (60 km/h)');
  }

  //convert current speed to int for comparing to speed limit, bc limit is an int
  double speedDifference = currentSpeed - speedLimit;
  
  //thresholds for what is a warning and what is dangerous (can be changed as we determine what thresholds we should use)
  const double warningThreshold = 12.0;  //12km/hr - 19km/hr over the limit will put them in warning zone
  const double dangerousThreshold = 20.0;  //20km/hr over the limit will put them in dangerous zone

  //categorize what state the driver is in (good, warning or danger) and show message
  if (speedDifference > dangerousThreshold) {
    return SpeedAnalysis(
      state: SpeedState.dangerous,
      message: 'DANGER: SLOW DOWN - You are going ${speedDifference.toStringAsFixed(1)} km/hr over the posted speed limit!',
      currentSpeed: currentSpeed, //for debugging
      speedLimit: speedLimit, //for debugging
    );
  } else if (speedDifference > warningThreshold) {
    return SpeedAnalysis(
      state: SpeedState.warning,
      message: 'WARNING: You are going ${speedDifference.toStringAsFixed(1)} km/hr over the posted speed limit',
      currentSpeed: currentSpeed, //for debugging
      speedLimit: speedLimit, //for debugging
    );
  } else {
    return SpeedAnalysis(
      state: SpeedState.good,
      message: 'Speed is good',
      currentSpeed: currentSpeed, //for debugging
      speedLimit: speedLimit, //for debugging
    );
  }
}