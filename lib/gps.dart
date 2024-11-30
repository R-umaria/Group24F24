//Andy Guest - Nov 12 2024
//GPS tracking functionality - for tracking the user's location during a trip
//NOTE: you can access the current lat and long in your files by using the variables: currentLatitude and currentLongitude

// ignore_for_file: unused_element

import 'dart:async';//so location tracking can work async with rest of app
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';//to ask for location permissions

StreamSubscription<Position>? _positionStreamSubscription;
double? currentLatitude;
double? currentLongitude;

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
  if (_positionStreamSubscription != null) {
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
    debugPrint('Location tracking stopped');
  } else {
    debugPrint('No active location tracking to stop.');
  }
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
  const LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high, // High accuracy for precise updates
    distanceFilter: 5, // Trigger an update every 100 meters
  );

  _positionStreamSubscription =
      Geolocator.getPositionStream(locationSettings: locationSettings)
          .listen((Position position) {
    _logLocation(position);
  });
}


void _storeLocationInfo() {
  // will store the location info once we decide what/how often info needs to be stored
}

//for debugging, prints lat and long in terminal
void _logLocation(Position position) {
  debugPrint('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
  currentLatitude = position.latitude;
  currentLongitude = position.longitude;
}