import 'package:flutter/material.dart';
import '../database_helper.dart';

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
      appBar: AppBar(
        title: Text('Parental Settings'),
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
                Text('Speed Limit: ${speedLimit.toInt()} km/h'),
                Slider(
                  value: speedLimit,
                  min: 20,
                  max: 150,
                  divisions: 13,
                  label: speedLimit.toInt().toString(),
                  onChanged: (value) {
                    setState(() {
                      speedLimit = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveSettings,
              child: Text('Save Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
