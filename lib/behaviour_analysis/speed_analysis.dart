//Andy Guest - Nov 15 2024
//driving behaviour analysis of speed limit compared to current speed

import 'package:flutter/material.dart';
import 'dart:math';
import '../database_helper.dart';

//state based on the comparison between the current speed and the limit (based on our chosen thresholds)
//currently set for city driving but adjusted thresholds will be added for highway driving later
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


//analyze current speed vs speed limit
SpeedAnalysis analyzeSpeed(double currentSpeed, int speedLimit, SpeedAnalysisTimer timer) {
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

  //categorize what state the driver is in (safe, warning or danger) and show message
  if (speedDifference > dangerousThreshold) {
    timer.updateState(SpeedState.dangerous);
    return SpeedAnalysis(
      state: SpeedState.dangerous,
      message: 'DANGER: SLOW DOWN - You are going ${speedDifference.toStringAsFixed(1)} km/hr over the posted speed limit!',
      currentSpeed: currentSpeed, //for debugging
      speedLimit: speedLimit, //for debugging
    );
  } else if (speedDifference > warningThreshold) {
    timer.updateState(SpeedState.warning);
    return SpeedAnalysis(
      state: SpeedState.warning,
      message: 'WARNING: You are going ${speedDifference.toStringAsFixed(1)} km/hr over the posted speed limit',
      currentSpeed: currentSpeed, //for debugging
      speedLimit: speedLimit, //for debugging
    );
  } else {
    timer.updateState(SpeedState.safe);
    return SpeedAnalysis(
      state: SpeedState.safe,
      message: 'Speed is safe',
      currentSpeed: currentSpeed, //for debugging
      speedLimit: speedLimit, //for debugging
    );
  }
}

//times the duration the driver is in each state (safe, warning, dangerous)
class SpeedAnalysisTimer {
  SpeedState _currentState = SpeedState.safe; 
  DateTime? _stateEntryTime; //time when the driver enters a specific state
  Duration _warningStateDuration = Duration.zero; //total warning state time
  Duration _dangerousStateDuration = Duration.zero; //total dangeours state time
  
 //updates state and calculates duration of the previous state
  void updateState(SpeedState newState) {
    if (newState != _currentState) {
      //save time of the previous state before switching to timing new state
      if (_currentState == SpeedState.warning) {
        _warningStateDuration += DateTime.now().difference(_stateEntryTime!);
      } else if (_currentState == SpeedState.dangerous) {
        _dangerousStateDuration += DateTime.now().difference(_stateEntryTime!);
      }
      // debugPrint('state changed from $_currentState to $newState');
      _currentState = newState; //change state now that time has been saved
      _stateEntryTime = DateTime.now(); //reset state entry time to current time
    }
  }

  Duration getWarningStateDuration() => _warningStateDuration; //call this to get the total duration spent in the warning state after trip is over
  Duration getDangerousStateDuration() => _dangerousStateDuration; //same but for dangerous

  //reset everything back to 0 (only use after saving the durations)
  void resetTimers() {
    _warningStateDuration = Duration.zero;
    _dangerousStateDuration = Duration.zero;
    _stateEntryTime = null;
  }

  //update the duration
  void update() {
  if (_currentState == SpeedState.warning) {
    _warningStateDuration += const Duration(seconds: 1);
  } else if (_currentState == SpeedState.dangerous) {
    _dangerousStateDuration += const Duration(seconds: 1);
  }
}
}

  //report of the speed analysis and how long they were in each state 
  //later i'll change it to return the info and we can use this to put into in the trip report
  void speedAnalysisReport(timer) {
    int totalTripTime = 1240; //hardcoded for now but will need to replace with actual total trip time later

    debugPrint('\n---speed anaylsis report---'); // Header for the final report
    debugPrint('warning state duration: ${timer.getWarningStateDuration().inSeconds} seconds'); // debugPrint total warning state time
    debugPrint('dangerous state duration: ${timer.getDangerousStateDuration().inSeconds} seconds'); // debugPrint total dangerous state time
    debugPrint('safe state duration: ${totalTripTime - timer.getWarningStateDuration().inSeconds - timer.getDangerousStateDuration().inSeconds} seconds');

    //percent of time in each state
    double warningPercentage = (timer.getWarningStateDuration().inSeconds / totalTripTime) * 100;
    double dangerousPercentage = (timer.getDangerousStateDuration().inSeconds / totalTripTime) * 100;
    double safePercentage = (100 - warningPercentage - dangerousPercentage);
    
    debugPrint('warning state percent: ${warningPercentage.toStringAsFixed(2)}%');
    debugPrint('dangerous state percent: ${dangerousPercentage.toStringAsFixed(2)}%');
    debugPrint('safe state percent: ${safePercentage.toStringAsFixed(2)}%');

  }

 final DatabaseHelper _dbHelper = DatabaseHelper();

 Future<void> _logBehaviourReport(double safespeedpercent, double warningspeedpercent, double dangerspeedpercent) async{
    await _dbHelper.insertBehaviour({
      'warning_speed_percent': warningspeedpercent,
      'safe_speed_percent': safespeedpercent,
      'danger_speed_percent': dangerspeedpercent
    });

 }

//for the danger popup for speed:
class SpeedStateNotifier extends ChangeNotifier {
  SpeedState _state = SpeedState.safe;
  SpeedState get state => _state;

  void updateState(SpeedState newState) {
    if (_state != newState) {
      _state = newState;
      notifyListeners();
    }
  }
}

//this is to go into the database
class behaviourAnalysisInfo {
  final int id;
  final double warningSpeedPercent;
  final double dangerSpeedPercent;
  final double safeSpeedPercent;

  behaviourAnalysisInfo({
    required this.id,
    required this.warningSpeedPercent,
    required this.dangerSpeedPercent,
    required this.safeSpeedPercent,
  });

    @override
  String toString() {
    return 'Trip{id: $id, warningSpeedPercent: $warningSpeedPercent, dangerSpeedPercent: $dangerSpeedPercent, safeSpeedPercent: $safeSpeedPercent}';
  }
}

//---------------------------------------------------------------------------------
//-----------------simulation!!! only for testing purposes ------------------------
//---------------------------------------------------------------------------------

class SpeedTrackingSimulation {
  final int speedLimit;
  SpeedAnalysisTimer timer;
  Random random = Random(); //to generate random speeds 
  SpeedTrackingSimulation({required this.speedLimit}) 
      : timer = SpeedAnalysisTimer(); 
 
  void runSimulation() {
    debugPrint('simulation started'); 
    debugPrint('speed limit: $speedLimit km/h');

    //simulate driving for 1240 secs with random speed variation (+- 25km/hr based on the speed limit given)
    for (int second = 0; second < 1240; second++) {
      double currentSpeed = simulateSpeedVariation();
      SpeedAnalysis analysis = analyzeSpeed(currentSpeed, speedLimit, timer);
      timer.update();
      //print every 30secs to rhe console
      if (second % 30 == 0) {
        debugPrint('time: ${second}s | '
              'speed: ${currentSpeed.toStringAsFixed(1)} km/h | '
              'status: ${analysis.message}');
      }
    }
    //after simulation print the report to console

    speedAnalysisReport(timer);
  }

  double simulateSpeedVariation() {
    double baseSpeed = speedLimit.toDouble(); //speed limit -> base speed
    
    //random variation added to the speed limit -25 to +25 km/h
    double speedVariation = random.nextDouble() * 30 - 25;
    if (random.nextInt(10) < 9) {
      speedVariation += random.nextDouble() * 25;
    } 
    
    return baseSpeed + speedVariation;
  }
}


