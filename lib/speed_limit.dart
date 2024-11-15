//Andy Guest - Nov 15 2024
//speed limit of road based on current location

import 'dart:convert'; //for json data
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; //needed for openstmap calls
import 'gps.dart';

Future<int> getSpeedLimit() async {
  //check if we have valid location data
  if (currentLatitude == null || currentLongitude == null) {
    debugPrint('Location info could not be determined - (for speed limits)');
    return 0; //if no location is avaliable, return 0
  }

  //the url used for openstreetmap api calls 
  final url = Uri.parse('https://nominatim.openstreetmap.org/reverse?' //reverse is for converting coords to address
      'format=json&'
      'lat=$currentLatitude&'
      'lon=$currentLongitude&'
      'zoom=18&' //18 is street level 
      'addressdetails=1'); //needed to get the speed limit info

  //wait for the response
  final response = await http.get(url);

  if (response.statusCode == 200) { //200 status code means request went through successfully
    final data = jsonDecode(response.body); //changes from json -> dart object
    final roadInfo = data['address']; //address info is the only thing needed from response, this extracts it
    
    //see if the road info has speed limit info - (not all roads have speed limit data on openstreetmap)
    if (roadInfo.containsKey('maxspeed')) {
      final speedLimit = int.tryParse(roadInfo['maxspeed']);//try to change from string to int (null returned if cant)
      if (speedLimit != null) { 
        return speedLimit;
      }
    }
  }

  return 0; //currently returns 0 if no speed limit data is avaliable for the location on openstreet map 
  //but this can be changed to default values for highway and city driving later
}