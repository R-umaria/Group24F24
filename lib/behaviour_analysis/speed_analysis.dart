import 'package:flutter/material.dart';
import 'dart:math';
import 'package:drive_wise/database_helper.dart'; // Mohammed_sujahat_ali - Added for DatabaseHelper

//state based on the comparison between the current speed and the limit (based on our chosen thresholds)
enum SpeedState {
  safe, //less than 11km/hr over the limit on city streets
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

// Utility function to determine the speed state
SpeedAnalysis determineSpeedState(double speedDifference, int speedLimit, double currentSpeed, bool notificationsEnabled, SpeedAnalysisTimer timer) {
  const double warningThreshold = 12.0; // Warning threshold
  const double dangerousThreshold = 20.0; // Dangerous threshold

  if (speedDifference > dangerousThreshold) {
    if (notificationsEnabled) {
      debugPrint("DANGER: Speed exceeded by ${speedDifference.toStringAsFixed(1)} km/h."); // Mohammed_sujahat_ali - Added dynamic debug logging
    }
    timer.updateState(SpeedState.dangerous);
    return SpeedAnalysis(
      state: SpeedState.dangerous,
      message: 'DANGER: Exceeding speed by ${speedDifference.toStringAsFixed(1)} km/h.',
      currentSpeed: currentSpeed,
      speedLimit: speedLimit,
    );
  } else if (speedDifference > warningThreshold) {
    timer.updateState(SpeedState.warning);
    return SpeedAnalysis(
      state: SpeedState.warning,
      message: 'WARNING: ${speedDifference.toStringAsFixed(1)} km/h over the limit.',
      currentSpeed: currentSpeed,
      speedLimit: speedLimit,
    );
  } else {
    timer.updateState(SpeedState.safe);
    return SpeedAnalysis(
      state: SpeedState.safe,
      message: 'Speed is safe.',
      currentSpeed: currentSpeed,
      speedLimit: speedLimit,
    );
  }
}

// Analyze current speed vs speed limit
SpeedAnalysis analyzeSpeed(double currentSpeed, int speedLimit, SpeedAnalysisTimer timer) {
  // Use default speed limit if none is provided
  if (speedLimit == 0) {
    speedLimit = 60; // Default city driving limit
    debugPrint('No speed limit data available, using default city speed (60 km/h)'); // Mohammed_sujahat_ali - Default speed check
  }

  double speedDifference = currentSpeed - speedLimit;
  return determineSpeedState(speedDifference, speedLimit, currentSpeed, true, timer);
}

// Times the duration the driver is in each state (safe, warning, dangerous)
class SpeedAnalysisTimer {
  SpeedState _currentState = SpeedState.safe; 
  DateTime? _stateEntryTime; //time when the driver enters a specific state
  Duration _warningStateDuration = Duration.zero; //total warning state time
  Duration _dangerousStateDuration = Duration.zero; //total dangerous state time
  
  // Updates state and calculates duration of the previous state
  void updateState(SpeedState newState) {
    if (newState != _currentState) {
      if (_currentState == SpeedState.warning) {
        _warningStateDuration += DateTime.now().difference(_stateEntryTime!);
      } else if (_currentState == SpeedState.dangerous) {
        _dangerousStateDuration += DateTime.now().difference(_stateEntryTime!);
      }
      _currentState = newState;
      _stateEntryTime = DateTime.now();
    }
  }

  Duration getWarningStateDuration() => _warningStateDuration;
  Duration getDangerousStateDuration() => _dangerousStateDuration;

  void resetTimers() {
    _warningStateDuration = Duration.zero;
    _dangerousStateDuration = Duration.zero;
    _stateEntryTime = null;
  }

  void update() {
    if (_currentState == SpeedState.warning) {
      _warningStateDuration += const Duration(seconds: 1);
    } else if (_currentState == SpeedState.dangerous) {
      _dangerousStateDuration += const Duration(seconds: 1);
    }
  }
}

// Report of the speed analysis
void speedAnalysisReport(SpeedAnalysisTimer timer) {
  int totalTripTime = 1240; // Placeholder for trip duration
  debugPrint('\n--- Speed Analysis Report ---');
  debugPrint('Warning state duration: ${timer.getWarningStateDuration().inSeconds} seconds');
  debugPrint('Dangerous state duration: ${timer.getDangerousStateDuration().inSeconds} seconds');
  debugPrint('Safe state duration: ${totalTripTime - timer.getWarningStateDuration().inSeconds - timer.getDangerousStateDuration().inSeconds} seconds');

  double warningPercentage = (timer.getWarningStateDuration().inSeconds / totalTripTime) * 100;
  double dangerousPercentage = (timer.getDangerousStateDuration().inSeconds / totalTripTime) * 100;
  double safePercentage = 100 - warningPercentage - dangerousPercentage;

  debugPrint('Warning state percentage: ${warningPercentage.toStringAsFixed(2)}%'); // Mohammed_sujahat_ali - Enhanced percentage reporting
  debugPrint('Dangerous state percentage: ${dangerousPercentage.toStringAsFixed(2)}%');
  debugPrint('Safe state percentage: ${safePercentage.toStringAsFixed(2)}%');
}

// Dynamic analysis function using database settings
Future<SpeedAnalysis> dynamicAnalyzeSpeed(double currentSpeed, DatabaseHelper dbHelper, SpeedAnalysisTimer timer) async {
  final speedLimitSetting = await dbHelper.getSetting('speedLimit'); // Mohammed_sujahat_ali - Added database speed limit integration
  final notificationsEnabledSetting = await dbHelper.getSetting('notificationsEnabled'); // Mohammed_sujahat_ali - Added notifications check

  int speedLimit = int.tryParse(speedLimitSetting ?? '60') ?? 60;
  bool notificationsEnabled = notificationsEnabledSetting == 'true';

  double speedDifference = currentSpeed - speedLimit;
  return determineSpeedState(speedDifference, speedLimit, currentSpeed, notificationsEnabled, timer);
}
