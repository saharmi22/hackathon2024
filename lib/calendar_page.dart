import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import 'package:flutter/services.dart' show rootBundle;

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  bool _isReadOnly = false;

  void _fillIn() async {
    // Load event data from Hive DB for the selected day
    final formattedDate = DateFormat('EEEE, dd/MM/yyyy', 'en_US').format(_selectedDay!);
    var json = await HiveEventDB().getEvent(formattedDate);

    if (json != null) {
      // Parse JSON back into widgets
      setState(() {
        int _calmLevel = json['calmness_level'];
        int _stressLevel = json['stress_level'];

        List<Map<String, String>> todaysEvents = List<Map<String, String>>.from(
            json['Table Today'].map((event) => {
              'time': event['time'],
              'event': event['event']
            })
        );
        List<Map<String, String>> tomorrowsSchedule = List<Map<String, String>>.from(
            json['Table Tomorrow'].map((schedule) => {
              'event': schedule['event'],
              'description': schedule['description']
            })
        );
        _isReadOnly = DateTime.now().difference(_selectedDay!).inDays >= 7;
      });

      // Navigate to the event page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EventPageReadOnly(json)),
      );
    } else {
      // Throw an exception if there isn't a row for that date in the DB
      throw Exception('No data available for $_selectedDay');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar Page'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableCalendar(
              calendarFormat: _calendarFormat,
              focusedDay: _focusedDay,
              firstDay: DateTime(2024),
              lastDay: DateTime.now(),
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                });
                _fillIn(); // Call your function here
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              headerStyle: HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
                headerPadding: EdgeInsets.symmetric(horizontal: 16.0),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                  fontSize: 14, // Adjust the font size for weekdays
                  fontWeight: FontWeight.bold,
                ),
                weekendStyle: TextStyle(
                  fontSize: 14, // Adjust the font size for weekends
                  fontWeight: FontWeight.bold,
                ),
              ),
              calendarStyle: CalendarStyle(
                defaultTextStyle: TextStyle(fontSize: 15),
                weekendTextStyle: TextStyle(fontSize: 15),
                outsideDaysVisible: false,
                todayDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EventPageReadOnly extends StatelessWidget {
  final Map<String, dynamic> json;

  EventPageReadOnly(this.json);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                    backgroundColor: json['calmness_level'] == index + 1 ? Colors.blue : Colors.grey,
                    child: Text('${index + 1}', style: TextStyle(color: Colors.white)),
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
                    backgroundColor: json['stress_level'] == index + 1 ? Colors.blue : Colors.grey,
                    child: Text('${index + 1}', style: TextStyle(color: Colors.white)),
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
                children: (json['Table Today'] as List).map((event) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
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
                        SizedBox(width: 16.0),
                        Expanded(
                          flex: 3,
                          child: InputDecorator(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(color: Colors.grey[800]!),
                              ),
                            ),
                            child: Text(
                              event['event'] ?? 'Event',
                              style: TextStyle(fontSize: 16.0, color: Colors.black87),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 16.0),
              Text(
                "Tomorrow's Schedule",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              SizedBox(height: 8.0),
              Column(
                children: (json['Table Tomorrow'] as List).map((schedule) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: InputDecorator(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(color: Colors.grey[800]!),
                              ),
                            ),
                            child: Text(
                              schedule['event'] ?? 'Event',
                              style: TextStyle(fontSize: 16.0, color: Colors.black87),
                            ),
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Expanded(
                          flex: 2,
                          child: InputDecorator(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(color: Colors.grey[800]!),
                              ),
                            ),
                            child: Text(
                              schedule['description'] ?? 'Description',
                              style: TextStyle(fontSize: 16.0, color: Colors.black87),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HiveEventDB {
  static const String boxName = 'events';

  Future<void> saveEvent(String date, Map<String, dynamic> eventJson) async {
    var box = await Hive.openBox(boxName);
    await box.put(date, eventJson);
    await box.close();
  }

  Future<Map<String, dynamic>?> getEvent(String date) async {
    var box = await Hive.openBox(boxName);
    var eventJson = box.get(date);
    await box.close();
    return eventJson;
  }
}
