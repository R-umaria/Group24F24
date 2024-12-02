import 'package:flutter/material.dart';
import 'package:drive_wise/database_helper.dart';

class MyTrips extends StatefulWidget {
  const MyTrips({super.key});

  @override
  _MyTripsState createState() => _MyTripsState();
}

class _MyTripsState extends State<MyTrips> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _trips = [];

  @override
  void initState() {
    super.initState();
    _loadTrips();
  }

  // Load all trips from the database
  Future<void> _loadTrips() async {
    final trips = await _dbHelper.getAllTrips();
    setState(() {
      _trips = trips;
    });
  }

  // Clear all trips from the database
  Future<void> _clearAllTrips() async {
    await _dbHelper.clearAllEvents();
    // Reload trips after clearing
    _loadTrips();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('All trips have been cleared.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(248, 244, 234, 1), //match to the main screen bg colour
      appBar: AppBar(
        title: const Text('My Trips Log', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(86, 170, 200, 1),
        elevation: 4.0,
      ),
      body: Column(
        children: [
          // ListView to display trips
          Expanded(
            child: ListView.builder(
              itemCount: _trips.length,
              itemBuilder: (context, index) {
                final trip = _trips[index];
                return Container(
                    width: 800,
                    margin: const EdgeInsets.symmetric(vertical: 3.0), // Optional for spacing
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(225, 225, 225, 1), // Background color of the ListTile
                      borderRadius: BorderRadius.circular(8.0), // Optional rounded corners
                    ),
                    child: ListTile(
                    title: Text('Event: ${trip['event_type']}'),
                    subtitle: Text(
                        'Time: ${trip['timestamp']}\nLat: ${trip['latitude']}, Lng: ${trip['longitude']}, Speed: ${trip['speed']}'
                      ),
                  ),
                );
              },
            ),
          ),
          // Button to clear all trips
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _clearAllTrips,
              child: Text("Clear All Data", style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(49, 49, 49, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),            
            ),
          ),
        ],
      ),
    );
  }
}
