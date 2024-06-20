import 'package:flutter/material.dart';
import 'dart:async';

class BreathingExercisePage extends StatefulWidget {
  @override
  _BreathingExercisePageState createState() => _BreathingExercisePageState();
}

class _BreathingExercisePageState extends State<BreathingExercisePage> with SingleTickerProviderStateMixin {
  Timer? _breathingTimer;
  int _timerSeconds = 90;
  final int _inhaleTime = 4;
  final int _holdTime = 7;
  final int _exhaleTime = 8;
  bool _isExerciseStarted = false;

  AnimationController? _animationController;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOut,
    );
  }

  void _startTimer() {
    setState(() {
      _isExerciseStarted = true;
      _timerSeconds = 90;
    });

    _animationController?.repeat(reverse: true);

    _breathingTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timerSeconds > 0) {
        setState(() {
          _timerSeconds--;
        });
      } else {
        timer.cancel();
        _showCompletionDialog();
      }
    });
  }

  void _stopTimer() {
    _breathingTimer?.cancel();
    _animationController?.stop();
    setState(() {
      _isExerciseStarted = false;
    });
  }

  Future<void> _showCompletionDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).popUntil((route) => route.isFirst);
        });
        return AlertDialog(
          title: Text('All done!'),
        );
      },
    ).then((_) {
      setState(() {
        _isExerciseStarted = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Breathing Exercise'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Follow the breathing pattern',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            SizedBox(height: 16.0),
            Text(
              'Repeat until the timer runs out:',
              style: TextStyle(fontSize: 20, color: Colors.black54),
            ),
            SizedBox(height: 16.0),
            Text(
              '1. Inhale through your nose for $_inhaleTime seconds\n'
              '2. Hold your breath for $_holdTime seconds\n'
              '3. Exhale through your mouth for $_exhaleTime seconds',
              style: TextStyle(fontSize: 18, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.0),
            if (_isExerciseStarted) ...[
              Text(
                '$_timerSeconds seconds remaining',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
              ),
              SizedBox(height: 32.0),
              ScaleTransition(
                scale: _animation!,
                child: Icon(
                  Icons.favorite,
                  color: Colors.teal,
                  size: 100,
                ),
              ),
              SizedBox(height: 32.0),
              ElevatedButton.icon(
                onPressed: _stopTimer,
                icon: Icon(Icons.stop),
                label: Text('Stop'),
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromARGB(255, 239, 131, 123),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ] else ...[
              ElevatedButton(
                onPressed: _startTimer,
                child: Text('Start Breathing Exercise'),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 140, 201, 195),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _breathingTimer?.cancel();
    _animationController?.dispose();
    super.dispose();
  }
}

