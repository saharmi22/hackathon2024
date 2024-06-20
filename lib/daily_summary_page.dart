import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  String _calmLevel = '1';
  String _stressLevel = '1';
  List<Map<String, String>> todaysEvents = [{'time': '', 'event': ''}];
  List<Map<String, String>> tomorrowsSchedule = [{'event': '', 'description': ''}];
  final snackBar = SnackBar(content: Text('Data saved for the day'));

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
        decoration: BoxDecoration(
          color: Colors.grey[900], // Dark background color
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.0),
                Text(
                  'How calm were you today?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white), // White text color
                ),
                SizedBox(height: 8.0),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8.0,
                  children: List.generate(6, (index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _calmLevel = (index + 1).toString();
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: _calmLevel == (index + 1).toString() ? Colors.blue : Colors.grey[700], // Darker grey
                        ),
                        child: Text(
                          (index + 1).toString(),
                          style: TextStyle(
                            color: _calmLevel == (index + 1).toString() ? Colors.white : Colors.white70, // White text or lighter grey
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(height: 16.0),
                Text(
                  'How stressed were you today?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white), // White text color
                ),
                SizedBox(height: 8.0),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8.0,
                  children: List.generate(6, (index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _stressLevel = (index + 1).toString();
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: _stressLevel == (index + 1).toString() ? Colors.blue : Colors.grey[700], // Darker grey
                        ),
                        child: Text(
                          (index + 1).toString(),
                          style: TextStyle(
                            color: _stressLevel == (index + 1).toString() ? Colors.white : Colors.white70, // White text or lighter grey
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(height: 16.0),
                Text(
                  "Today's Events",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white), // White text color
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
                                  contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: BorderSide(color: Colors.grey[800]!), // Darker border color
                                  ),
                                ),
                                child: Text(
                                  'Time',
                                  style: TextStyle(fontSize: 16.0, color: Colors.white), // White text color
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
                              style: TextStyle(color: Colors.white), // White text color
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide(color: Colors.grey[800]!), // Darker border color
                                ),
                                contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                                hintText: 'Event',
                                hintStyle: TextStyle(color: Colors.white70), // Lighter grey hint text color
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.white70), // Lighter grey icon color
                            onPressed: () => _removeTodaysEventRow(index),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: _addTodaysEventRow,
                    child: Icon(Icons.add),
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  "Tomorrow's Schedule",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white), // White text color
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
                              style: TextStyle(color: Colors.white), // White text color
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide(color: Colors.grey[800]!), // Darker border color
                                ),
                                contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                                hintText: 'Event',
                                hintStyle: TextStyle(color: Colors.white70), // Lighter grey hint text color
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
                              style: TextStyle(color: Colors.white), // White text color
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide(color: Colors.grey[800]!), // Darker border color
                                ),
                                contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                                hintText: 'Description',
                                hintStyle: TextStyle(color: Colors.white70), // Lighter grey hint text color
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.white70), // Lighter grey icon color
                            onPressed: () => _removeTomorrowsScheduleRow(index),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: _addTomorrowsScheduleRow,
                    child: Icon(Icons.add),
                  ),
                ),
                SizedBox(height: 16.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
