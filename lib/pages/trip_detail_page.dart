import 'package:flutter/material.dart';

class TripDetailsPage extends StatelessWidget {
  final int overspeedingInstances;
  final int harshBrakingInstances;
  final int sharpTurnInstances;
  final double tripDurationHours;
  final bool isShortTrip;
  final bool isLongTripWithoutBreaks;
  final double averageSpeed;
  final double topSpeed;
  final double distanceTravel;

  const TripDetailsPage({
    Key? key,
    required this.overspeedingInstances,
    required this.harshBrakingInstances,
    required this.sharpTurnInstances,
    required this.tripDurationHours,
    required this.isShortTrip,
    required this.isLongTripWithoutBreaks,
    required this.averageSpeed,
    required this.topSpeed,
    required this.distanceTravel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(248, 244, 234, 1),
      appBar: AppBar(
        title: const Text('Trip Details'),
        backgroundColor: const Color.fromRGBO(86, 170, 200, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Trip Analysis',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildTextRow('Average Speed:', '${averageSpeed.toStringAsFixed(2)} km/h'),
              _buildTextRow('Top Speed:', '${topSpeed.toStringAsFixed(2)} km/h'),
              _buildTextRow('Distance Travelled:', '${distanceTravel.toStringAsFixed(2)} km'),
              _buildTextRow('Overspeeding Instances:', '$overspeedingInstances'),
              _buildTextRow('Harsh Braking Instances:', '$harshBrakingInstances'),
              _buildTextRow('Sharp Turns:', '$sharpTurnInstances'),
              _buildTextRow('Trip Duration:', '${tripDurationHours.toStringAsFixed(1)} hours'),
            
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
