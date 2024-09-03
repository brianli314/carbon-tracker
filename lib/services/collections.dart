import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:tracker_app/units.dart';

class Miles {
  List<double> data;
  List<Timestamp> time;
  List<String> type;

  Miles({
    required this.data,
    required this.time,
    required this.type,
  });

  factory Miles.fromDocument(DocumentSnapshot doc) {
    return Miles(
        time: List<Timestamp>.from(doc['time']),
        data: List<double>.from(doc['data']),
        type: List<String>.from(doc['type']));
  }

  factory Miles.defaultInputs() {
    return Miles(data: [], time: [], type: []);
  }

  Map<String, dynamic> toMap() {
    return {'data': data, 'time': time, 'type': type};
  }

  Map<String, double> getDistr(int days) {
    DateTime now = DateTime.now();
    Map<String, double> output = {
      "Car": 0,
      "Bike": 0,
      "Walk": 0,
      "Metro": 0,
      "Plane": 0
    };
    for (int i = 0; i < data.length; i++) {
      DateTime date = time[i].toDate();
      double value = data[i];
      int difference = now.difference(date).inDays;
      if (difference < days) {
        output.update(type[i], (curr) => curr + value);
      }
    }
    return output;
  }

  Map<String, double> getWeeklyDistr() {
    return getDistr(7);
  }

  Map<String, double> getYearlyDistr() {
    return getDistr(365);
  }

  List<double> getWeekly() {
    DateTime now = DateTime.now();
    List<double> output = List.filled(7, 0);
    for (int i = 0; i < data.length; i++) {
      DateTime date = time[i].toDate();
      double value = data[i];
      int difference = now.difference(date).inDays;
      if (difference < 7 && type[i] == "Car") {
        output[date.weekday - 1] += value;
      }
    }
    return output;
  }

  List<double> getYearly() {
    Jiffy now = Jiffy.now();
    List<double> output = List.filled(12, 0);
    for (int i = 0; i < data.length; i++) {
      DateTime date = time[i].toDate();
      double value = data[i];
      int difference = now.diff(Jiffy.parseFromDateTime(date), unit: Unit.month).toInt();
      if (difference < 12 && type[i] == "Car") {
        output[date.month - 1] += value;
      }
    }
    return output;
  }

  List<double> getAllCarStats() {
    DateTime now = DateTime.now();

    if (data.length != time.length) {
      throw ArgumentError("Lists must be same size");
    }

    double weekSum = 0;
    double monthSum = 0;
    double yearSum = 0;
    for (int i = 0; i < data.length; i++) {
      DateTime date = time[i].toDate();
      double value = data[i];
      int difference = now.difference(date).inDays;
      if (difference < 7 && type[i] == "Car") {
        weekSum += value;
      }
      if (Jiffy.now().diff(Jiffy.parseFromDateTime(date), unit: Unit.month) < 1) {
        monthSum += value;
      }
      if (difference < 365) {
        yearSum += value;
      }
    }
    return [weekSum, monthSum, yearSum];
  }
}

class Energy {
  List<double> eMonthRate;
  List<double> gasMonthRate;

  Energy(
      {required this.eMonthRate,
      required this.gasMonthRate,
    });

  factory Energy.fromDocument(DocumentSnapshot doc) {
    return Energy(
      eMonthRate: List<double>.from(doc['electricityMonth']),
      gasMonthRate: List<double>.from(doc['gasMonth']),
    );
  }

  factory Energy.defaultInputs() {
    return Energy(
      eMonthRate: List<double>.filled(12, 900, growable: false),
      gasMonthRate: List<double>.filled(12, 5.55, growable: false),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'electricityMonth': eMonthRate,
      'gasMonth': gasMonthRate,
    };
  }
}

class Carbon {
  double average;
  double goal;

  Carbon({
    required this.average,
    required this.goal,
  });

  factory Carbon.fromDocument(DocumentSnapshot doc) {
    return Carbon(average: doc['average'], goal: doc['goal']);
  }

  factory Carbon.defaultInputs() {
    return Carbon(average: 25, goal: 50);
  }

  Map<String, dynamic> toMap() {
    return {
      'average': average,
      'goal': goal,
    };
  }

  static double computeEmissionsForDays(Miles mileage, Energy energy, int days) {
    return 0.8;
  }
}
