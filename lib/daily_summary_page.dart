import 'package:flutter/material.dart';

class DailySummaryPage extends StatefulWidget {
  @override
  _DailySummaryPageState createState() => _DailySummaryPageState();
}

class _DailySummaryPageState extends State<DailySummaryPage> {
  int _calmLevel = 1;
  int _stressLevel = 1;
  List<Map<String, String>> _todaysEvents = [{'time': '', 'event': ''}];
  List<Map<String, String>> _tomorrowsSchedule = [{'event': '', 'description': ''}];

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
                    backgroundColor: _stressLevel == index + 1 ? Colors.red : Colors.grey,
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
              const Text("Today's Events"),
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(1.2),
                  1: FlexColumnWidth(2),
                },
                border: TableBorder.all(),
                children: _todaysEvents
                    .asMap()
                    .entries
                    .map(
                      (entry) => TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () => _selectTime(entry.key),
                            child: IgnorePointer(
                              child: TextField(
                                controller: TextEditingController(text: entry.value['time']),
                                decoration: const InputDecoration.collapsed(hintText: 'Time'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            onChanged: (value) {
                              entry.value['event'] = value;
                            },
                            decoration: const InputDecoration.collapsed(hintText: 'Event'),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                    .toList(),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      _todaysEvents.add({'time': '', 'event': ''});
                    });
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              const Text("Tomorrow's Schedule"),
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(1.5),
                  1: FlexColumnWidth(2.5),
                },
                border: TableBorder.all(),
                children: _tomorrowsSchedule
                    .map(
                      (row) => TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            onChanged: (value) {
                              row['event'] = value;
                            },
                            decoration: const InputDecoration.collapsed(hintText: 'Event'),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            onChanged: (value) {
                              row['description'] = value;
                            },
                            decoration: const InputDecoration.collapsed(hintText: 'Description'),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                    .toList(),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      _tomorrowsSchedule.add({'event': '', 'description': ''});
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
