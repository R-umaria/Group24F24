import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart'; 
import 'package:drive_wise/gps.dart'; 
import 'package:drive_wise/sensors.dart'; 
import 'package:drive_wise/auto_trip.dart'; 
import 'trip_detail_page.dart'; 

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isTripActive = false;
  final SensorData _sensorData = SensorData();
  final AutoTripManager _autoTripManager = AutoTripManager();

  int overspeedingInstances = 1;
  int harshBrakingInstances = 2;
  int sharpTurnInstances = 3;
  bool isShortTrip = false;
  bool isLongTripWithoutBreaks = true;
  double averageSpeed = 50;
  double topSpeed = 100;
  double distanceTravel = 999;
  double tripDurationHours = 10.0;

  @override
  void initState() {
    super.initState();
    _autoTripManager.startMonitoring(context);
    _sensorData.onEventDetected = (event) {
      debugPrint(event);
    };
    _autoTripManager.isTripActive = isTripActive;
  }

  @override
  void dispose() {
    _sensorData.stopSensors();
    stopGpsTracking();
    super.dispose();
  }

  void _toggleTrip() async {
    if (isTripActive) {
      stopGpsTracking();
      _sensorData.stopSensors();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Trip stopped!"),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      await gpsTracking();
      _sensorData.startSensors();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Trip started!"),
          duration: Duration(seconds: 2),
        ),
      );
    }

    setState(() {
      isTripActive = !isTripActive;
      _autoTripManager.isTripActive = isTripActive;
    });
  }

  int calculateTripScore() {
    int score = 100;

    const int overspeedingPenalty = 5;
    const int harshBrakingPenalty = 4;
    const int sharpTurnPenalty = 3;
    const int shortTripReward = 5;
    const int longTripPenalty = 10;

    score -= overspeedingInstances * overspeedingPenalty;
    score -= harshBrakingInstances * harshBrakingPenalty;
    score -= sharpTurnInstances * sharpTurnPenalty;

    if (isShortTrip) {
      score += shortTripReward;
    }
    if (isLongTripWithoutBreaks) {
      score -= longTripPenalty;
    }

    return score.clamp(0, 100);
  }

  @override
  Widget build(BuildContext context) {
    int tripScore = calculateTripScore();

    return Scaffold(
      backgroundColor: const Color.fromRGBO(248, 244, 234, 1),
      appBar: AppBar(
        toolbarHeight: 35,
        backgroundColor: const Color.fromRGBO(86, 170, 200, 1),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipPath(
                  clipper: WaveClipperOne(reverse: false, flip: true),
                  child: Container(
                    height: 105,
                    width: double.infinity,
                    color: const Color.fromRGBO(86, 170, 200, 1),
                  ),
                ),
                const Positioned(
                  left: 16,
                  bottom: 50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello Driver,",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Let's Start!",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   const SizedBox(height: 10),
                  Card(
                    color: const Color.fromRGBO(225, 225, 225, 1),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            'Last Trip',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromRGBO(112, 112, 112, 1),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: const Color.fromRGBO(163, 163, 163, 0.5),
                            ),
                            child: const Center(
                              child: Text(
                                'Map Placeholder',
                                style: TextStyle(color: Colors.black45),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildDetailRow(
                                    'Date:',
                                    '24/10/2024',
                                    const Color.fromRGBO(112, 112, 112, 1),
                                  ),
                                  const SizedBox(height: 8),
                                  _buildDetailRow(
                                    'Distance Traveled:',
                                    '${distanceTravel} Kms',
                                    const Color.fromRGBO(112, 112, 112, 1),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  const Text(
                                    'Score',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: const Color.fromRGBO(112, 112, 112, 1),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        width: 80,
                                        height: 80,
                                        child: CircularProgressIndicator(
                                          value: tripScore / 100,
                                          strokeWidth: 12,
                                          backgroundColor:
                                              const Color.fromRGBO(0, 0, 0, 0.05),
                                          color: tripScore > 80
                                              ? Colors.green
                                              : tripScore > 50
                                                  ? Colors.orange
                                                  : Colors.red,
                                        ),
                                      ),
                                      Text(
                                        '$tripScore',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: tripScore > 80
                                              ? Colors.green
                                              : tripScore > 50
                                                  ? Colors.orange
                                                  : Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TripDetailsPage(
                                    overspeedingInstances: overspeedingInstances,
                                    harshBrakingInstances: harshBrakingInstances,
                                    sharpTurnInstances: sharpTurnInstances,
                                    tripDurationHours: tripDurationHours,
                                    isShortTrip: isShortTrip,
                                    isLongTripWithoutBreaks: isLongTripWithoutBreaks,
                                    averageSpeed: averageSpeed,
                                    topSpeed: topSpeed,
                                    distanceTravel: distanceTravel,
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              'More Details',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(86, 170, 200, 1),
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildDetailRow(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: color,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
