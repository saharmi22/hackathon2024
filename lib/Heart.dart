import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/*void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Heart Rate and HRV Stats',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HeartRateHRVScreen(),
    );
  }
}
*/
class HeartRateHRVScreen extends StatefulWidget {
  @override
  _HeartRateHRVScreenState createState() => _HeartRateHRVScreenState();
}

class _HeartRateHRVScreenState extends State<HeartRateHRVScreen> {
  // Constants for simulation
  static const int dataPoints = 50; // Number of data points to show (for last few minutes)
  static const int updateInterval = 2000; // Interval to update data in milliseconds

  // Lists to store heart rate and HRV data
  List<double> heartRateData = List.filled(dataPoints, 70); // Start with initial data
  List<double> hrvData = List.filled(dataPoints, 50); // Start with initial data

  // Timer for data simulation
  late Timer _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: updateInterval), (timer) {
      setState(() {
        // Simulate new data points
        _currentIndex = (_currentIndex + 1) % dataPoints;
        heartRateData[_currentIndex] = _generateRandomHeartRate();
        hrvData[_currentIndex] = _generateRandomHRV();
      });
    });
  }

  double _generateRandomHeartRate() {
    return Random().nextInt(30) + 60; // Generate heart rate between 60 and 90 bpm
  }

  double _generateRandomHRV() {
    return Random().nextInt(40) + 40; // Generate HRV between 40 and 80 ms
  }

  double calculateAverage(List<double> data) {
    if (data.isEmpty) return 0.0;
    double sum = data.reduce((value, element) => value + element);
    return sum / data.length;
  }

  double calculateHRV(List<double> data) {
    if (data.isEmpty) return 0.0;
    double variance = 0;
    double mean = calculateAverage(data);
    for (var value in data) {
      variance += pow(value - mean, 2);
    }
    return sqrt(variance / data.length);
  }

  @override
  Widget build(BuildContext context) {
    List<double> recentHeartRateData = heartRateData.sublist(
      _currentIndex > dataPoints - 1 ? _currentIndex - (dataPoints - 1) : 0,
      _currentIndex + 1,
    );
    List<double> recentHRVData = hrvData.sublist(
      _currentIndex > dataPoints - 1 ? _currentIndex - (dataPoints - 1) : 0,
      _currentIndex + 1,
    );

    double averageHeartRate = calculateAverage(recentHeartRateData);
    double averageHRV = calculateHRV(recentHRVData);

    return Scaffold(
      appBar: AppBar(
        title: Text('Heart Rate and HRV Stats'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(7.0),
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Heart Rate',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '${recentHeartRateData.last.toStringAsFixed(1)} bpm',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(7.0),
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current HRV',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 156, 97, 74),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '${recentHRVData.last.toStringAsFixed(1)} ms',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(7.0),
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Average Heart Rate',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '${averageHeartRate.toStringAsFixed(1)} bpm',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(7.0),
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Average HRV',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 156, 97, 74),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '${averageHRV.toStringAsFixed(1)} ms',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(7),
              height: 300,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    drawHorizontalLine: true,
                    horizontalInterval: 25,
                    verticalInterval: 25,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.black12,
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: Colors.black12,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (c, value) => const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      getTitles: (value) {
                        // Replace with actual x-axis labels if needed
                        return '';
                      },
                    ),
                    leftTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (c, value) => const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      getTitles: (value) {
                        // Replace with actual y-axis labels if needed
                        switch (value.toInt()) {
                          case 50:
                            return '50 ms';
                          case 75:
                            return '75 ms';
                          case 100:
                            return '100 ms';
                          case 125:
                            return '125 ms';
                          case 150:
                            return '150 ms';
                          default:
                            return '';
                        }
                      },
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(recentHeartRateData.length, (index) => FlSpot(index.toDouble(), recentHeartRateData[index])),
                      isCurved: true,
                      colors: [Colors.teal],
                      barWidth: 4,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(show: false),
                    ),
                    LineChartBarData(
                      spots: List.generate(recentHRVData.length, (index) => FlSpot(index.toDouble(), recentHRVData[index])),
                      isCurved: true,
                      colors: [Color.fromARGB(255, 156, 97, 74)],
                      barWidth: 4,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}