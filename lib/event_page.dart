import 'package:flutter/material.dart';


class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}


class _EventPageState extends State<EventPage> {
  final TextEditingController _timeStartController = TextEditingController();
  final TextEditingController _timeEndController = TextEditingController();
  String _eventType = 'Meeting';
  String _customEventType = '';
  String _whatHappened = '';
  double _emotionalState = 5.0;
  int x = 0;


  @override
  void dispose() {
    _timeStartController.dispose();
    _timeEndController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Time:'),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _timeStartController,
                    decoration: const InputDecoration(
                      hintText: 'hh:mm',
                    ),
                    keyboardType: TextInputType.datetime,
                  ),
                ),
                const Text(' - '),
                Expanded(
                  child: TextField(
                    controller: _timeEndController,
                    decoration: const InputDecoration(
                      hintText: 'hh:mm',
                    ),
                    keyboardType: TextInputType.datetime,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            const Text('Type of Event:'),
            DropdownButton<String>(
              value: _eventType,
              onChanged: (String? newValue) {
                setState(() {
                  _eventType = newValue!;
                });
              },
              items: <String>['Meeting', 'Appointment', 'Other']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            if (_eventType == 'Other')
              TextField(
                onChanged: (text) {
                  setState(() {
                    _customEventType = text;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Specify event type',
                ),
              ),
            const SizedBox(height: 16.0),
            const Text('What happened:'),
            TextField(
              onChanged: (text) {
                setState(() {
                  _whatHappened = text;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16.0),
            const Text('Emotional state:'),
            Slider(
              value: _emotionalState,
              onChanged: (double value) {
                setState(() {
                  _emotionalState = value;
                });
              },
              min: 1,
              max: 10,
              divisions: 9,
              label: _emotionalState.round().toString(),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Handle form submission logic here
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}


//Hello people
