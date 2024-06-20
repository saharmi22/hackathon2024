import 'package:flutter/material.dart';
import 'package:hackathon2024/homePage.dart';
import 'package:hackathon2024/daily_summary_page.dart';

class EntryFormTile extends StatelessWidget {
  final String date;

  EntryFormTile({required this.date});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 390,
        height: 100,
        child: Card(
          
          child: Column(
            children: [Text(date, style: const TextStyle(fontWeight: FontWeight.bold))],
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