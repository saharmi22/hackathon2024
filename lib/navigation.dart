import 'package:flutter/material.dart';
//import 'package:pillaway/pages/personalprofilePage.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:hackathon2024/calendar_page.dart';
import 'package:hackathon2024/daily_summary_page.dart';
import 'package:hackathon2024/homePage.dart';
import 'package:hackathon2024/Heart.dart';


class HomePageNavigator extends StatefulWidget {
  const HomePageNavigator({super.key});

  @override
  _HomePageNavigatorState createState() => _HomePageNavigatorState();
}

class _HomePageNavigatorState extends State<HomePageNavigator> {
  int _currentIndex = 0;
  final _pages = [HomePage(), CalendarPage(), HeartRateHRVScreen()];

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
            icon: const Icon(Icons.home),
            //make the title in the center
            title: const Text('Home', textAlign: TextAlign.center),
            activeColor: const Color.fromRGBO(109, 182, 214, 1),
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.calendar_month),
            title: const Text('CalendarPage', textAlign: TextAlign.center),
            activeColor: const Color.fromRGBO(109, 182, 214, 1),
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.favorite),
            //make the title in the center
            title: const Text('Heart', textAlign: TextAlign.center),
            activeColor: const Color.fromRGBO(109, 182, 214, 1),
          ),
        ],
      ),
    );
  }
}
