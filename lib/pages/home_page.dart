import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart'; // Ensure this package is added in pubspec.yaml

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(248, 244, 234, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(86, 170, 200, 1),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // Handle notifications
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with wavy background and text
            _buildHeader(),

            // Main content with padding
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20), // Spacing after the header

                  // Last Trip Card
                  _buildLastTripCard(),

                  SizedBox(height: 20), // Spacing before the Start Trip button

                  // Start Trip Button
                  _buildStartTripButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the header section with a wavy background and text.
  Widget _buildHeader() {
    return Stack(
      children: [
        ClipPath(
          clipper: WaveClipperOne(reverse: false, flip: true),
          child: Container(
            height: 105,
            width: double.infinity,
            color: const Color.fromRGBO(86, 170, 200, 1),
          ),
        ),
        Positioned(
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
    );
  }

  /// Builds the Last Trip card with details and a placeholder for the map.
  Widget _buildLastTripCard() {
    return Card(
      color: const Color.fromRGBO(225, 225, 225, 1),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Title
            Text(
              'Last Trip',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color.fromRGBO(112, 112, 112, 1),
              ),
            ),
            SizedBox(height: 10),

            // Map Placeholder
            Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color.fromRGBO(163, 163, 163, 0.5),
              ),
              child: Center(
                child: Text(
                  'Map Placeholder',
                  style: TextStyle(color: Colors.black45),
                ),
              ),
            ),
            SizedBox(height: 10),

            // Details Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Date and Distance
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Date:', '24/10/2024'),
                    SizedBox(height: 8),
                    _buildDetailRow('Distance Traveled:', '36 Kms'),
                  ],
                ),

                // Score
                Column(
                  children: [
                    Text(
                      'Score',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: CircularProgressIndicator(
                            value: 0.75,
                            strokeWidth: 12,
                            backgroundColor: Colors.grey.shade300,
                            color: const Color.fromRGBO(170, 200, 86, 1),
                          ),
                        ),
                        Text(
                          '75',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromRGBO(170, 200, 86, 1),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),

            // More Details Button
            ElevatedButton(
              onPressed: () {
                // Handle more details action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(50, 50, 50, 1),
                minimumSize: Size(double.infinity, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'More Details',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a detail row with a label and a value.
  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// Builds the Start Trip button.
  Widget _buildStartTripButton() {
    return ElevatedButton(
      onPressed: () {
        // Handle start trip action
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(86, 170, 200, 1),
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Start Trip',
            style: TextStyle(
              color: const Color.fromRGBO(255, 255, 255, 1),
              fontSize: 22,
            ),
          ),
          SizedBox(width: 8),
          Icon(
            Icons.directions_car,
            color: const Color.fromRGBO(255, 255, 255, 1),
          ),
        ],
      ),
    );
  }
}
