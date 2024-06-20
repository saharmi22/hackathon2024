import 'package:flutter/material.dart';
import 'package:hackathon2024/EntryFormCard.dart';
import 'package:hackathon2024/EntryFormTile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
              child: EntryFormTile(date: "12/12/2021"),
            ),
             Padding(
              padding: EdgeInsets.all(10.0),
              child: EntryFormTile(date: "11/12/2021"),
            ),
          ],
        ),
      ),
    );
  }
}
