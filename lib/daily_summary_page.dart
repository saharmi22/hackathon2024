import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  int _calmLevel = 1;
  int _stressLevel = 1;
  List<Map<String, String>> todaysEvents = [{'time': '', 'event': ''}];
  List<Map<String, String>> tomorrowsSchedule = [{'event': '', 'description': ''}];
  final snackBar = SnackBar(content: Text('Data saved for the day'));
  Timer? _breathingTimer;

  void _addTodaysEventRow() {
    setState(() {
      todaysEvents.add({'time': '', 'event': ''});
    });
  }

  void _removeTodaysEventRow(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Event'),
          content: Text('Are you sure you want to delete this event?'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  todaysEvents.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  void _addTomorrowsScheduleRow() {
    setState(() {
      tomorrowsSchedule.add({'event': '', 'description': ''});
    });
  }

  void _removeTomorrowsScheduleRow(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Event'),
          content: Text('Are you sure you want to delete this event?'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  tomorrowsSchedule.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectTime(BuildContext context, int index) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        todaysEvents[index]['time'] = picked.format(context);
      });
    }
  }

  Future<void> _showBreathingExerciseDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Let\'s start breathing exercise and measure HRV?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                _startBreathingExercise();
              },
            ),
          ],
        );
      },
    );
  }

  void _startBreathingExercise() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Breathing Exercise'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      'Until timer runs out repeat:\n1. Inhale through nose for 4 seconds\n2. Hold your breath for 7 seconds\n3. Exhale out for 8 seconds'),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _startTimer();
                    },
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _startTimer() {
    int timerSeconds = 90;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Breathing Exercise'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              _breathingTimer = Timer.periodic(Duration(seconds: 1), (timer) {
                if (timerSeconds > 0) {
                  setState(() {
                    timerSeconds--;
                  });
                } else {
                  timer.cancel();
                  _showCompletionDialog();
                  Navigator.of(context).pop();
                }
              });

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      'Until timer runs out repeat:\n1. Inhale through nose for 4 seconds\n2. Hold your breath for 7 seconds\n3. Exhale out for 8 seconds'),
                  SizedBox(height: 16.0),
                  Text(
                    '$timerSeconds seconds remaining',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton.icon(
                    onPressed: () {
                      _breathingTimer?.cancel();
                      Navigator.of(context).pop();
                    },
                    label: Text('Stop breathing exercise'),
                  ),
                ],
              );
            },
          ),
        );
      },
    ).then((_) {
      _breathingTimer?.cancel(); // Ensure timer is canceled when dialog is dismissed
    });
  }

  Future<void> _showCompletionDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });
        return AlertDialog(
          title: Text('All done'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get current date
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEEE, dd/MM/yyyy', 'en_US').format(now);

    return Scaffold(
        appBar: AppBar(
        title: Text(formattedDate),
    ),
    body: Container(
    color: Colors.white, // Set background color to white
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: SingleChildScrollView(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    SizedBox(height: 16.0),
    Text(
    'How calm were you today?',
    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87), // Black text color
    ),
    SizedBox(height: 8.0),
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: List.generate(6, (index) {
    return CircleAvatar(
    radius: 20,
    backgroundColor: _calmLevel == index + 1 ? Colors.blue : Colors.grey,
    child: IconButton(
    icon: Text('${index + 1}', style: TextStyle(color: Colors.white)), // White text color
    onPressed: () {
    setState(() {
    _calmLevel = index + 1;
    });
    },
    ),
    );
    }),
    ),
    SizedBox(height: 16.0),
    Text(
    'How stressed were you today?',
    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87), // Black text color
    ),
    SizedBox(height: 8.0),
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: List.generate(6, (index) {
    return CircleAvatar(
    radius: 20,
    backgroundColor: _stressLevel == index + 1 ? Colors.blue : Colors.grey,
    child: IconButton(
    icon: Text('${index + 1}', style: TextStyle(color: Colors.white)), // White text color
    onPressed: () {
    setState(() {
    _stressLevel = index + 1;
    });
    },
    ),
    );
    }),
    ),
    SizedBox(height: 16.0),
    Text(
    "Today's Events",
    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87), // Black text color
    ),
    SizedBox(height: 8.0),
    Column(
    children: todaysEvents.asMap().entries.map((entry) {
    int index = entry.key;
    Map<String, String> event = entry.value;
    return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
    children: [
    Expanded(
    flex: 1,
    child: InkWell(
    onTap: () => _selectTime(context, index),
    child: InputDecorator(
    decoration: InputDecoration(
    contentPadding: EdgeInsets.symmetric(vertical:
    12.0, horizontal: 16.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: Colors.grey[800]!), // Darker border color
      ),
    ),
      child: Text(
        'Time', // Updated label "Time"
        style: TextStyle(fontSize: 16.0, color: Colors.black87), // Black text color
      ),
    ),
    ),
    ),
      SizedBox(width: 16.0),
      Expanded(
        flex: 3,
        child: TextField(
          onChanged: (text) {
            setState(() {
              event['event'] = text;
            });
          },
          style: TextStyle(color: Colors.black87), // Black text color
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.grey[800]!), // Darker border color
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            hintText: 'Event',
            hintStyle: TextStyle(color: Colors.grey[600]), // Light grey hint text color
          ),
        ),
      ),
      IconButton(
        icon: Icon(Icons.delete, color: Colors.grey[600]), // Light grey icon color
        onPressed: () => _removeTodaysEventRow(index),
      ),
    ],
    ),
    );
    }).toList(),
    ),
      Align(
        alignment: Alignment.centerRight,
        child: IconButton(
          onPressed: _addTodaysEventRow,
          icon: Icon(Icons.add), // + icon
        ),
      ),
      SizedBox(height: 16.0),
      Text(
        "Tomorrow's Schedule",
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87), // Black text color
      ),
      SizedBox(height: 8.0),
      Column(
        children: tomorrowsSchedule.asMap().entries.map((entry) {
          int index = entry.key;
          Map<String, String> schedule = entry.value;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    onChanged: (text) {
                      setState(() {
                        schedule['event'] = text;
                      });
                    },
                    style: TextStyle(color: Colors.black87), // Black text color
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.grey[800]!), // Darker border color
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                      hintText: 'Event',
                      hintStyle: TextStyle(color: Colors.grey[600]), // Light grey hint text color
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  flex: 2,
                  child: TextField(
                    onChanged: (text) {
                      setState(() {
                        schedule['description'] = text;
                      });
                    },
                    style: TextStyle(color: Colors.black87), // Black text color
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.grey[800]!), // Darker border color
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                      hintText: 'Description',
                      hintStyle: TextStyle(color: Colors.grey[600]), // Light grey hint text color
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.grey[600]), // Light grey icon color
                  onPressed: () => _removeTomorrowsScheduleRow(index),
                ),
              ],
            ),
          );
        }).toList(),
      ),
      Align(
        alignment: Alignment.centerRight,
        child: IconButton(
          onPressed: _addTomorrowsScheduleRow,
          icon: Icon(Icons.add), // + icon
        ),
      ),
      SizedBox(height: 16.0),
      Center(
        child: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            _showBreathingExerciseDialog();
          },
          child: Text('Save'),
        ),
      ),
    ],
    ),
    ),
    ),
    ),
    );
  }
}
