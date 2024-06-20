import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class DailySummaryPage extends StatefulWidget {
  @override
  _DailySummaryPageState createState() => _DailySummaryPageState();
}

class _DailySummaryPageState extends State<DailySummaryPage> {
  int _calmLevel = 1;
  int _stressLevel = 1;
  List<Map<String, String>> _todaysEvents = [{'time': '', 'event': ''}];
  List<Map<String, String>> _tomorrowsSchedule = [{'event': '', 'description': ''}];

  @override
  void initState() {
    super.initState();
    Hive.initFlutter();
  }

  Future<void> _selectTime(int index) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _todaysEvents[index]['time'] = picked.format(context);
      });
    }
  }

  Map<String, dynamic> convertWidgetsToJson() {
    return {
      "calmness_level": _calmLevel,
      "stress_level": _stressLevel,
      "Table Today": {for (var event in _todaysEvents) event['time']: event['event']},
      "Table Tomorrow": {for (var schedule in _tomorrowsSchedule) schedule['event']: schedule['description']},
    };
  }

  Future<void> storeJsonInHive(String date, Map<String, dynamic> json) async {
    var box = await Hive.openBox('daily_summary');
    box.put(date, json);
  }

  Future<Map<String, dynamic>?> retrieveJsonFromHive(String date) async {
    var box = await Hive.openBox('daily_summary');
    return box.get(date);
  }

  Map<String, dynamic> parseJsonToWidgets(Map<String, dynamic> json) {
    int calmLevel = json['calmness_level'];
    int stressLevel = json['stress_level'];

    List<Map<String, String>> todaysEvents = (json['Table Today'] as Map<String, String>).entries.map((e) {
      return {'time': e.key, 'event': e.value};
    }).toList();

    List<Map<String, String>> tomorrowsSchedule = (json['Table Tomorrow'] as Map<String, String>).entries.map((e) {
      return {'event': e.key, 'description': e.value};
    }).toList();

    return {
      'calmLevel': calmLevel,
      'stressLevel': stressLevel,
      'todaysEvents': todaysEvents,
      'tomorrowsSchedule': tomorrowsSchedule,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Summary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'How calm were you today?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(6, (index) {
                  return CircleAvatar(
                    radius: 20,
                    backgroundColor: _calmLevel == index + 1 ? Colors.blue : Colors.grey,
                    child: IconButton(
                      icon: Text('${index + 1}'),
                      color: Colors.white,
                      onPressed: () {
                        setState(() {
                          _calmLevel = index + 1;
                        });
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'How stressed were you today?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(6, (index) {
                  return CircleAvatar(
                    radius: 20,
                    backgroundColor: _stressLevel == index + 1 ? Colors.blue : Colors.grey,
                    child: IconButton(
                      icon: Text('${index + 1}'),
                      color: Colors.white,
                      onPressed: () {
                        setState(() {
                          _stressLevel = index + 1;
                        });
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Today\'s Events',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _todaysEvents.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'Time'),
                          onTap: () => _selectTime(index),
                          readOnly: true,
                          controller: TextEditingController(text: _todaysEvents[index]['time']),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'Event'),
                          onChanged: (value) {
                            setState(() {
                              _todaysEvents[index]['event'] = value;
                            });
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Tomorrow\'s Schedule',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _tomorrowsSchedule.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'Event'),
                          onChanged: (value) {
                            setState(() {
                              _tomorrowsSchedule[index]['event'] = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'Description'),
                          onChanged: (value) {
                            setState(() {
                              _tomorrowsSchedule[index]['description'] = value;
                            });
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  String date = DateTime.now().toString().split(' ')[0]; // Get current date
                  Map<String, dynamic> jsonData = convertWidgetsToJson();
                  await storeJsonInHive(date, jsonData);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data saved for $date')));
                },
                child: const Text('Save'),
              ),
              ElevatedButton(
                onPressed: () async {
                  String date = DateTime.now().toString().split(' ')[0]; // Get current date
                  Map<String, dynamic>? jsonData = await retrieveJsonFromHive(date);
                  if (jsonData != null) {
                    Map<String, dynamic> parsedData = parseJsonToWidgets(jsonData);
                    setState(() {
                      _calmLevel = parsedData['calmLevel'];
                      _stressLevel = parsedData['stressLevel'];
                      _todaysEvents = List<Map<String, String>>.from(parsedData['todaysEvents']);
                      _tomorrowsSchedule = List<Map<String, String>>.from(parsedData['tomorrowsSchedule']);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data loaded for $date')));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No data found for $date')));
                  }
                },
                child: const Text('Load'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
