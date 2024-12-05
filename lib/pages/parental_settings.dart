import 'package:flutter/material.dart';
import '../../database_helper.dart';

class ParentalSettingsPage extends StatefulWidget {
  @override
  _ParentalSettingsPageState createState() => _ParentalSettingsPageState();
}

class _ParentalSettingsPageState extends State<ParentalSettingsPage> {
  bool notificationsEnabled = true; // Default value
  double speedLimit = 60; // Default city speed limit

  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    final notificationSetting = await dbHelper.getSetting('notificationsEnabled');
    final speedLimitSetting = await dbHelper.getSetting('speedLimit');
    setState(() {
      notificationsEnabled = notificationSetting == 'true';
      speedLimit = double.tryParse(speedLimitSetting ?? '60') ?? 60;
    });
  }

  Future<void> saveSettings() async {
    await dbHelper.saveSetting('notificationsEnabled', notificationsEnabled.toString());
    await dbHelper.saveSetting('speedLimit', speedLimit.toString());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Settings saved successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(248, 244, 234, 1), //match to the main screen bg colour
      appBar: AppBar(
        title: Text('Parental Settings', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color.fromRGBO(86, 170, 200, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: Text('Enable Notifications'),
              value: notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
              },
            ),
            Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Flexible(
      child: Text(
        'Speed Limit: ${speedLimit.toInt()} km/h',
        overflow: TextOverflow.ellipsis, // Prevent long text from overflowing
      ),
    ),
    Expanded(
      child: Slider(
        value: speedLimit,
        min: 20,
        max: 150,
        divisions: 13,
        label: speedLimit.toInt().toString(),
        activeColor: Color.fromRGBO(86, 170, 200, 1), // Color of the filled part of the slider
        inactiveColor: Colors.grey, // Color of the unfilled part of the slider
        onChanged: (value) {
          setState(() {
            speedLimit = value;
          });
        },
      ),
    ),
  ],
),
SizedBox(height: 20),
ElevatedButton(
  onPressed: saveSettings,
  style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(86, 170, 200, 1), // Button background color
    foregroundColor: Colors.white, // Button text color
    padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0), // Rounded button corners
    ),
  ),
  child: Text('Save Settings'),
),
          ],
        ),
      ),
    );
  }
}
