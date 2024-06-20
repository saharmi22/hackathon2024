import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';

class EventPage extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  final bool isReadOnly;

  EventPage({this.initialData, this.isReadOnly = false});

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  int _calmLevel = 1;
  int _stressLevel = 1;
  List<Map<String, String>> todaysEvents = [{'time': '', 'event': ''}];
  List<Map<String, String>> tomorrowsSchedule = [{'event': '', 'description': ''}];
  final snackBar = SnackBar(content: Text('Data saved for the day'));

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _initializeWithData(widget.initialData!);
    }
  }

  void _initializeWithData(Map<String, dynamic> data) {
    setState(() {
      _calmLevel = data['calmness_level'] ?? 1;
      _stressLevel = data['stress_level'] ?? 1;
      todaysEvents = (data['Table Today'] as Map<String, String>?)?.entries.map((entry) {
        return {'time': entry.key, 'event': entry.value};
      }).toList() ?? [{'time': '', 'event': ''}];
      tomorrowsSchedule = (data['Table Tomorrow'] as Map<String, String>?)?.entries.map((entry) {
        return {'event': entry.key, 'description': entry.value};
      }).toList() ?? [{'event': '', 'description': ''}];
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEEE, dd/MM/yyyy', 'en_US').format(now);

    return Scaffold(
      appBar: AppBar(
        title: Text(formattedDate),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.0),
                Text(
                  'How calm were you today?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(6, (index) {
                    return CircleAvatar(
                      radius: 20,
                      backgroundColor: _calmLevel == index + 1 ? Colors.blue : Colors.grey,
                      child: IconButton(
                        icon: Text('${index + 1}', style: TextStyle(color: Colors.white)),
                        onPressed: widget.isReadOnly ? null : () {
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
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(6, (index) {
                    return CircleAvatar(
                      radius: 20,
                      backgroundColor: _stressLevel == index + 1 ? Colors.blue : Colors.grey,
                      child: IconButton(
                        icon: Text('${index + 1}', style: TextStyle(color: Colors.white)),
                        onPressed: widget.isReadOnly ? null : () {
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
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
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
                              onTap: widget.isReadOnly ? null : () => _selectTime(context, index),
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: BorderSide(color: Colors.grey[800]!),
                                  ),
                                ),
                                child: Text(
                                  event['time'] ?? 'Time',
                                  style: TextStyle(fontSize: 16.0, color: Colors.black87),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16.0),
                          Expanded(
                            flex: 3,
                            child: TextField(
                              onChanged: (text) {
                                if (!widget.isReadOnly) {
                                  setState(() {
                                    event['event'] = text;
                                  });
                                }
                              },
                              controller: TextEditingController(text: event['event']),

                              style: TextStyle(color: Colors.black87),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide(color: Colors.grey[800]!),
                                ),
                                contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                                hintText: 'Event',
                                hintStyle: TextStyle(color: Colors.grey[600]),
                              ),
                              enabled: !widget.isReadOnly,
                            ),
                          ),
                          if (!widget.isReadOnly)
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.grey[600]),
                              onPressed: () => _removeTodaysEventRow(index),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                if (!widget.isReadOnly)
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: _addTodaysEventRow,
                      child: Icon(Icons.add, color: Colors.white),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                      ),
                    ),
                  ),
                SizedBox(height: 16.0),
                Text(
                  "Tomorrow's Schedule",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
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
                                if (!widget.isReadOnly) {
                                  setState(() {
                                    schedule['event'] = text;
                                  });
                                }
                              },
                              controller: TextEditingController(text: schedule['event']),
                              style: TextStyle(color: Colors.black87),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide(color: Colors.grey[800]!),
                                ),
                                contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                                hintText: 'Event',
                                hintStyle: TextStyle(color: Colors.grey[600]),
                              ),
                              enabled: !widget.isReadOnly,
                            ),
                          ),
                          SizedBox(width: 16.0),
                          Expanded(
                            flex: 2,
                            child: TextField(
                              onChanged: (text) {
                                if (!widget.isReadOnly) {
                                  setState(() {
                                    schedule['description'] = text;
                                  });
                                }
                              },
                              controller: TextEditingController(text: schedule['description']),
                              style: TextStyle(color: Colors.black87),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide(color: Colors.grey[800]!),
                                ),
                                contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                                hintText: 'Description',
                                hintStyle: TextStyle(color: Colors.grey[600]),
                              ),
                              enabled: !widget.isReadOnly,
                            ),
                          ),
                          if (!widget.isReadOnly)
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.grey[600]),
                              onPressed: () => _removeTomorrowsScheduleRow(index),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                if (!widget.isReadOnly)
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: _addTomorrowsScheduleRow,
                      child: Icon(Icons.add, color: Colors.white),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: widget.isReadOnly
          ? null
          : FloatingActionButton(
        onPressed: _saveData,
        child: Icon(Icons.save),
      ),
    );
  }

  void _selectTime(BuildContext context, int index) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        todaysEvents[index]['time'] = pickedTime.format(context);
      });
    }
  }

  void _addTodaysEventRow() {
    setState(() {
      todaysEvents.add({'time': '', 'event': ''});
    });
  }

  void _removeTodaysEventRow(int index) {
    setState(() {
      todaysEvents.removeAt(index);
    });
  }

  void _addTomorrowsScheduleRow() {
    setState(() {
      tomorrowsSchedule.add({'event': '', 'description': ''});
    });
  }

  void _removeTomorrowsScheduleRow(int index) {
    setState(() {
      tomorrowsSchedule.removeAt(index);
    });
  }

  void _saveData() async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEEE, dd/MM/yyyy', 'en_US').format(now);

    var data = {
      'calmness_level': _calmLevel,
      'stress_level': _stressLevel,
      'Table Today': {for (var e in todaysEvents) e['time']!: e['event']!},
      'Table Tomorrow': {for (var e in tomorrowsSchedule) e['event']!: e['description']!},
    };

    await HiveEventDB(Hive.openBox('eventBox')).addEvent(formattedDate, data);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class HiveEventDB {
  Box box = Hive.box('eventBox');

  HiveEventDB(box);

  // HiveEventDB(box);

  // HiveEventDB.empty() : box = Hive.box('eventBox');

  Future<void> addEvent(String date, Map<String, dynamic> event) async {
    await box.put(date, event);
  }

  Future<Map<String, dynamic>?> getEvent(String date) async {
    return box.get(date);
  }
}
