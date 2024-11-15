//GPS tracking functionality - Andy Guest - Nov 12 2024
//for tracking the user's location during a trip

import 'dart:async';//so location tracking can work async with rest of app
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';//to ask for location permissions

StreamSubscription<Position>? _positionStreamSubscription;

//call when trip starts -> will check location permissions then start tracking the devices location
Future<void> gpsTracking() async {
  await _requestLocationPermission();//need to get permission from user before tracking location
  if (await Permission.location.isGranted){
    _getCurrentLocation();//runs after permissions are given
  } else {
    debugPrint('Permissions not granted, no locaton can be tracked');
  }
}

//call when trip is over, to stop the location tracking. cancels location stream subscription
void stopGpsTracking() {
  _positionStreamSubscription?.cancel();
  _positionStreamSubscription = null;
  debugPrint('Location tracking stopped');
}


//-----------------private functions--------------------//

//request permissions from device(works on windows currently)
Future<void> _requestLocationPermission() async {
  var status = await Permission.location.request();
  if (status.isGranted) {
    debugPrint('Location granted');
  } else {
    debugPrint('Location denied, please enable location permissions for drivewise in your device settings');
  }
}

//get the current location of the device with the geolocator positionstream
void _getCurrentLocation() {
  _positionStreamSubscription = Geolocator.getPositionStream().listen((Position position) {
    _logLocation(position);
  });
}

void _storeLocationInfo() {
  // will store the location info once we decide what/how often info needs to be stored
}

//for debugging, prints lat and long in terminal
void _logLocation(Position position) {
  debugPrint('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
}