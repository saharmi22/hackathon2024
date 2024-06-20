import 'package:flutter/material.dart';
import 'package:hackathon2024/EntryFormCard.dart';

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
      body: const Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: EntryFormCardInit(),
            ),
            // todo: add list of small entries here
          ],
        ),
      ),
    );
  }
}
