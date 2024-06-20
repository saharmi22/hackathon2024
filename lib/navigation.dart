import 'package:flutter/material.dart';
//import 'package:pillaway/pages/personalprofilePage.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:hackathon2024/calendar_page.dart';
import 'package:hackathon2024/daily_summary_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final _pages = [EventPage(), CalendarPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: const Icon(Icons.menu_book),
            //make the title in the center
            title: const Text('EventPage', textAlign: TextAlign.center),
            activeColor: const Color.fromRGBO(109, 182, 214, 1),
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.calendar_month),
            title: const Text('CalendarPage', textAlign: TextAlign.center),
            activeColor: const Color.fromRGBO(109, 182, 214, 1),
          ),
          
        ],
      ),
    );
  }
}
