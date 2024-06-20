import 'dart:math';

class HRVCalculator {
  // Function to calculate SDNN
  double calculateSDNN(List<int> rrIntervals) {
    double mean = rrIntervals.reduce((a, b) => a + b) / rrIntervals.length;
    double sumOfSquaredDiffs = rrIntervals
    .map((interval) => pow(interval - mean, 2.0))
    .reduce((a, b) => a + b);
    return sqrt(sumOfSquaredDiffs / rrIntervals.length);
  }

  // Function to calculate RMSSD
  double calculateRMSSD(List<int> rrIntervals) {
    List<int> rrDiffs = [];
    for (int i = 1; i < rrIntervals.length; i++) {
      rrDiffs.add(rrIntervals[i] - rrIntervals[i - 1]);
    }
    double sumOfSquaredDiffs =
        rrDiffs.map((diff) => pow(diff, 2)).reduce((a, b) => a + b);
    return sqrt(sumOfSquaredDiffs / rrDiffs.length);
  }
}

void main() {
  // Example list of RR intervals in milliseconds
  List<int> rrIntervals = [800, 810, 790, 820, 800, 780, 830, 790];

  HRVCalculator hrvCalculator = HRVCalculator();

  double sdnn = hrvCalculator.calculateSDNN(rrIntervals);
  double rmssd = hrvCalculator.calculateRMSSD(rrIntervals);

  print('SDNN: ${sdnn.toStringAsFixed(2)} ms');
  print('RMSSD: ${rmssd.toStringAsFixed(2)} ms');
}
