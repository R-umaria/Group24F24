//Andy Guest - dec 3 2024
//frontend for the previous trips page, shows the drivers last few trips

import 'package:flutter/material.dart';
import './prev_trips_backend.dart';
import '../my_trips.dart'; 

class PrevTripsPage extends StatefulWidget {
  const PrevTripsPage({super.key});

  @override
  PrevTripsPageState createState() => PrevTripsPageState();
}

class PrevTripsPageState extends State<PrevTripsPage> {
  List<PrevTripEntry> PrevTripEntries = [];

  @override
  void initState() {
    super.initState();
    _fetchPrevTripData();
  }

  void _fetchPrevTripData() {
    //get PrevTrip data from backend
    PrevTripEntries = getPrevTripData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(248, 244, 234, 1), //match to the main screen bg colour
      appBar: AppBar(
        title: const Text('Previous Trips', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(86, 170, 200, 1),
        elevation: 4.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(26.0),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Your Past Trips',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            
            //prevTrip entries
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(225, 225, 225, 1),
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ListView.builder(
                shrinkWrap: true, //needed to stop the list from taking up extra space
                itemCount: PrevTripEntries.length,
                itemBuilder: (context, index) {
                  final entry = PrevTripEntries[index];
                  return PrevTripItem(
                    date: entry.date,
                    score: entry.score,
                    map: entry.map,
                    distance: entry.distance,
                  );
                },
              ),
            ),

            const SizedBox(height: 13), //space between list and button

            //button to get to old trips page to see events 
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MyTrips()),
                        );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: const Color.fromRGBO(49, 49, 49, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // to separate text from the icon on the right
                children: [
                  Text(
                    'See Logged Trip Events',
                    style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 1), 
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Icon(
                    Icons.assessment_rounded,
                    color: Color.fromRGBO(255, 255, 255, 1), 
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PrevTripItem extends StatelessWidget {
  final String date;
  final int score;
  final String map;
  final double distance;
  final String behaviour;

  const PrevTripItem({super.key, 
    required this.date,
    required this.score,
    required this.map,
    required this.distance,
    this.behaviour = 'Safe',
  });

  @override
Widget build(BuildContext context) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 7.0),
    elevation: 8.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.0),
    ),
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          const SizedBox(width: 16.0),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 50.0,
                  height: 50.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Image.asset(
                      map,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      'Distance: $distance',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey[600],
                      ),
                    ),
                    // Behavior Text
                    Text(
                      'Behaviour: $behaviour',
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                // Score Text
                Text(
                  '$score%',
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
}