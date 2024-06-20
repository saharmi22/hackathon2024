import 'package:flutter/material.dart';
import 'package:hackathon2024/EntryFormCard.dart';
import 'package:hackathon2024/EntryFormTile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    
    // Call a function to check your condition and show alert if necessary
    _checkConditionToShowAlert();
  }

  void _checkConditionToShowAlert() {
    bool shouldShowAlert = true; // Replace with your condition

    if (shouldShowAlert) {
      
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Alert"),
              content: Text("According to our calculation, you need a rest day!"),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recent Entries"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: EntryFormCardInit(),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: EntryFormTile(date: "19/06/2024 entry", avg: 7.4),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: EntryFormTile(date: "18/06/2024 entry", avg: 2.6),
            ),
          ],
        ),
      ),
    );
  }
}
