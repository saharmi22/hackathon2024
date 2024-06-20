import 'package:flutter/material.dart';
import 'package:hackathon2024/homePage.dart';
import 'package:hackathon2024/daily_summary_page.dart';

class EntryFormTile extends StatelessWidget {
  final String date;
  final double avg;

  EntryFormTile({required this.date, required this.avg});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 390,
        height: 100,
        child: Card(
          elevation: 10,
          child: Column(
            children: [Text(date, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text("Avg Event Rating: $avg", style: const TextStyle(fontSize: 20)),],
            mainAxisAlignment: MainAxisAlignment.center,
        ),
            ),
      ),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EventPage()), //todo: change to FormPage AND pass date as argument
      );
      },
    );
  }
}