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
        primaryColor: Color(0xFF4A6FA5), // Moonlit Blue
        hintColor: Color.fromARGB(255, 139, 195, 169), // Deep Space Blue
        scaffoldBackgroundColor: Color.fromARGB(255, 223, 253, 247), // Deep Space Blue
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Color.fromARGB(255, 6, 25, 63)), // Pale Moon
          bodyText2: TextStyle(color: Color.fromARGB(255, 6, 25, 63)), // Pale Moon
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xFF4A6FA5), // Moonlit Blue
          textTheme: ButtonTextTheme.primary,
        ),
        iconTheme: IconThemeData(
          color: Color.fromARGB(255, 153, 191, 182), // Pale Moon
        ),
        cardColor: Color(0xFF2C3E50), // Darker shade for cards
        dividerColor: Color(0xFF3C4F76), // Shadow Gray
        errorColor: Color(0xFFC0392B), 
        // Additional theme settings       // Additional theme settings
      ),
      home: HomePageNavigator(),
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
