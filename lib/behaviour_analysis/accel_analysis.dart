//Andy Guest - Nov 21 2024
//categorizes the drivers acceleration behaviour and creates report

import 'package:flutter/material.dart';

enum AccelerationBehaviourState {
  safe, //0-30% of accelerations are harsh
  warning, //30%-50% of accelerations are harsh
  dangerous //over 50% of accelerations are harsh
}

class AccelerationAnalysis {
  final AccelerationBehaviourState state;
  final String message; //to print on report
  final int numHarshAccelerations;
  final int totalAccelerationsTaken;

  AccelerationAnalysis({
    required this.state,
    required this.message,
    required this.numHarshAccelerations,
    required this.totalAccelerationsTaken,
  });
}

AccelerationAnalysis analyzeAccelerations(int totalHarshAccelerations, int totalAccelerations) {
  //get the percentage of how many accelerations were harsh
  double percentHarshAccelerations = (totalHarshAccelerations/totalAccelerations) *100;

  //categorize based on percentage
  if (percentHarshAccelerations < 30){
    return AccelerationAnalysis(
      state: AccelerationBehaviourState.safe,
      message: 'Accelerationing behaviour is safe.',
      numHarshAccelerations: totalHarshAccelerations,
      totalAccelerationsTaken: totalAccelerations
    );
  }
  else if (percentHarshAccelerations >30 && percentHarshAccelerations < 50){
    return AccelerationAnalysis(
      state: AccelerationBehaviourState.warning,
      message: 'Warning: a moderate amount of accelerations were taken too harshly',
      numHarshAccelerations: totalHarshAccelerations,
      totalAccelerationsTaken: totalAccelerations
    );
  } else{
    return AccelerationAnalysis(
      state: AccelerationBehaviourState.dangerous,
      message: 'DANGER: a dangerous amount of accelerations were taken too harshly',
      numHarshAccelerations: totalHarshAccelerations,
      totalAccelerationsTaken: totalAccelerations
    );
  }
}

  void accelerationingAnalysisReport(AccelerationAnalysis analysis) {
    double percentHarshAccelerations = (analysis.numHarshAccelerations/analysis.totalAccelerationsTaken) *100;

    debugPrint('\n---accelerationing anaylsis report---'); // Header for the final report
    debugPrint(analysis.message);    
    debugPrint('${percentHarshAccelerations.toStringAsFixed(2)}% of accelerations were taken too harshly');
  }