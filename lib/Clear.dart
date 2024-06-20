import 'package:flutter/material.dart';

class ClearPage extends StatefulWidget {
  const ClearPage({super.key});

  @override
  State<ClearPage> createState() => _ClearPageState();
}

class _ClearPageState extends State<ClearPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("שלום"),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text('הדף הריק הכי טוב בעולם', style: TextStyle(fontSize: 24))],
        ),
      ),
    );
  }
}