//Andy Guest - Nov 21 2024
//categorizes the drivers corner behaviour and creates report

import 'package:flutter/material.dart';

enum CornerBehaviourState {
  safe, //0-30% of corners are harsh
  warning, //30%-50% of corners are harsh
  dangerous //over 50% of corners are harsh
}

class CornerAnalysis {
  final CornerBehaviourState state;
  final String message; //to print on report
  final int numHarshCorners;
  final int totalCornersTaken;

  CornerAnalysis({
    required this.state,
    required this.message,
    required this.numHarshCorners,
    required this.totalCornersTaken,
  });
}

CornerAnalysis analyzeCorners(int totalHarshCorners, int totalCorners) {
  //get the percentage of how many corners were harsh
  double percentHarshCorners = (totalHarshCorners/totalCorners) *100;

  //categorize based on percentage
  if (percentHarshCorners < 30){
    return CornerAnalysis(
      state: CornerBehaviourState.safe,
      message: 'Cornering behaviour is safe.',
      numHarshCorners: totalHarshCorners,
      totalCornersTaken: totalCorners
    );
  }
  else if (percentHarshCorners >30 && percentHarshCorners < 50){
    return CornerAnalysis(
      state: CornerBehaviourState.warning,
      message: 'Warning: a moderate amount of corners were taken too harshly',
      numHarshCorners: totalHarshCorners,
      totalCornersTaken: totalCorners
    );
  } else{
    return CornerAnalysis(
      state: CornerBehaviourState.dangerous,
      message: 'DANGER: a dangerous amount of corners were taken too harshly',
      numHarshCorners: totalHarshCorners,
      totalCornersTaken: totalCorners
    );
  }
}

  void corneringAnalysisReport(CornerAnalysis analysis) {
    double percentHarshCorners = (analysis.numHarshCorners/analysis.totalCornersTaken) *100;

    debugPrint('\n---cornering anaylsis report---'); // Header for the final report
    debugPrint(analysis.message);    
    debugPrint('${percentHarshCorners.toStringAsFixed(2)}% of corners were taken too harshly');
  }