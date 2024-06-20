import 'package:flutter/material.dart';
import 'package:hackathon2024/homePage.dart';
import 'package:hackathon2024/daily_summary_page.dart';

class EntryFormCardInit extends StatefulWidget {
  const EntryFormCardInit({super.key});

  @override
  State<EntryFormCardInit> createState() => _EntryFormCardInitState();
}

class _EntryFormCardInitState extends State<EntryFormCardInit> {
  @override
  Widget build(BuildContext context) {
    var day = DateTime.now().day;
    var month = DateTime.now().month;
    var year = DateTime.now().year;
    return GestureDetector(
      child: Container(
        height: 300,
        width: 390,
        child: Card(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text("Today: $day/$month/$year", style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                ),
              ),
              const Text("How are you feeling today?", style: TextStyle(fontSize: 20)),
            ]
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EventPage()), //todo: change to FormPage
        );
      },
    );
  }
}

class EntryFormCardUpdate extends StatefulWidget {
  const EntryFormCardUpdate({super.key});

  @override
  State<EntryFormCardUpdate> createState() => _EntryFormCardUpdateState();
}

class _EntryFormCardUpdateState extends State<EntryFormCardUpdate> {
  @override
  Widget build(BuildContext context) {
    var day = DateTime.now().day;
    var month = DateTime.now().month;
    var year = DateTime.now().year;
    var events = []; //todo: get events from database
    var avgMood = (events.isEmpty) ? 0 : events.map((e) => e.mood).reduce((a, b) => a + b) / events.length;
    return GestureDetector(
      child: Card(
        child: Column(
          children: <Widget>[
            Text("Today: $day/$month/$year", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            Text("Number Of Events: $events.length"),
            Text("Avarage Mood: $avgMood")
          ]
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EventPage()), //todo: change to FormPage
        );
      },
    );
  }
}