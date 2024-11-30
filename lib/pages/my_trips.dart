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
      appBar: AppBar(title: Text("My Trips")),
      body: Column(
        children: [
          // Button to clear all trips
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _clearAllTrips,
              child: Text("Clear All Data"),
            ),
          ),
          // ListView to display trips
          Expanded(
            child: ListView.builder(
              itemCount: _trips.length,
              itemBuilder: (context, index) {
                final trip = _trips[index];
                return ListTile(
                  title: Text('Event: ${trip['event_type']}'),
                  subtitle: Text(
                      'Time: ${trip['timestamp']}\nLat: ${trip['latitude']}, Lng: ${trip['longitude']}, Speed: ${trip['speed']}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
