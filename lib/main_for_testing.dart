//Andy - Nov 20 2024
//this file is an alternate main() meant for testing out stuff 
//you can see the working analysis functions here, everything is printed to the debug console
//note this is a temporary file, will be deleted later

import 'package:flutter/material.dart';
import 'behaviour_analysis/speed_analysis.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //testing the speeds through a simulation (see it in the behaviour_analysis/speed_analysis file at the bottom)
  //simulation is to test functionality without actually needing to drive somewhere
  debugPrint('city speeds');
  SpeedTrackingSimulation city = SpeedTrackingSimulation(speedLimit: 60);
  city.runSimulation();

  debugPrint('highway speeds');
  SpeedTrackingSimulation highway = SpeedTrackingSimulation(speedLimit: 100);
  highway.runSimulation();
}