import 'package:flutter/material.dart';
import 'package:hackathon2024/Heart.dart';
import 'calendar_page.dart';
import 'daily_summary_page.dart';
import 'navigation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Summary App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HeartRateHRVScreen(),
      home: HomePage(),
    );
  }
}
/*
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Summary App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CalendarPage()),
                );
              },
              child: Text('Open Calendar'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EventPage()),
                );
              },
              child: Text('Daily Summary'),
            ),
          ],
        ),
      ),
    );
  }
}*/
