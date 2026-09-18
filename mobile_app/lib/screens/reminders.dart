import 'package:flutter/material.dart';

class RemindersScreen extends StatelessWidget {
  final List<Map<String, dynamic>> dailyRoutines = [
    {"time": "08:00 AM", "task": "Take Morning Medicine", "icon": Icons.medical_services, "completed": true},
    {"time": "01:00 PM", "task": "Drink Water & Lunch", "icon": Icons.local_drink, "completed": false},
    {"time": "05:00 PM", "task": "Evening Walk", "icon": Icons.directions_walk, "completed": false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Daily Routine & Reminders', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal[800],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: dailyRoutines.length,
        itemBuilder: (context, index) {
          final routine = dailyRoutines[index];
          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              contentPadding: EdgeInsets.all(24),
              leading: Icon(routine["icon"], size: 48, color: Colors.teal[800]),
              title: Text(routine["task"], style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              subtitle: Text(routine["time"], style: TextStyle(fontSize: 22, color: Colors.grey[700])),
              trailing: ElevatedButton(
                onPressed: () {
                  // Connect to Local SQLite to save reminder log
                  print("Logged reminder completion in local_db");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: routine["completed"] ? Colors.grey : Colors.green[700],
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
                child: Text(
                  routine["completed"] ? "DONE" : "MARK DONE", 
                  style: TextStyle(fontSize: 24, color: Colors.white)
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
