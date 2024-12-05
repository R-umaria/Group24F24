import 'package:flutter/material.dart';

class MonthlyReportPage extends StatelessWidget {
  const MonthlyReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(248, 244, 234, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(86, 170, 200, 1),
        title: Row(
          children: [
            const SizedBox(width: 8),
            const Text(
              "Monthly Report",
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        centerTitle: false,
        elevation: 0,
      ),
      //backgroundColor: const Color.fromRGBO(248, 244, 234, 1),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Summary Section
                    const Text(
                      "Summary",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSummaryCard(
                          icon: Icons.map,
                          label: "Total Miles",
                          value: "1,250",
                          color: Colors.blue,
                        ),
                        _buildSummaryCard(
                          icon: Icons.speed,
                          label: "Avg Speed",
                          value: "60 mph",
                          color: Colors.green,
                        ),
                        _buildSummaryCard(
                          icon: Icons.timer,
                          label: "Driving Time",
                          value: "20 hrs",
                          color: Colors.orange,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Score Variation Section
                    const Text(
                      "Score Variation",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          "Score Variation Data Unavailable",
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Alerts Section
                    const Text(
                      "Alerts",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildAlertsCard(
                      alerts: [
                        "Speed Alert: Exceeded 80 mph on 5 instances",
                        "Harsh Braking: Detected 3 times",
                        "Rapid Acceleration: Noted 2 times",
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Widget to build summary cards
  Widget _buildSummaryCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        height: 100,
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to build the alerts section card
  Widget _buildAlertsCard({required List<String> alerts}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: alerts.map((alert) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              alert,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
