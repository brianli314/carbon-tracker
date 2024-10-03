import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:tracker_app/units.dart';

class Miles {
  List<double> data;
  List<Timestamp> time;
  List<String> type;
  String carType;

  Miles({
    required this.data,
    required this.time,
    required this.type,
    required this.carType,
  });

  factory Miles.fromDocument(DocumentSnapshot doc) {
    return Miles(
        time: List<Timestamp>.from(doc['time']),
        data: List<double>.from(doc['data']),
        type: List<String>.from(doc['type']),
        carType: doc['carType']);
  }

  factory Miles.defaultInputs() {
    return Miles(data: [], time: [], type: [], carType: "Gas");
  }

  Map<String, dynamic> toMap() {
    return {'data': data, 'time': time, 'type': type, 'carType': carType};
  }

  Map<String, double> getDistr(int days) {
    DateTime now = DateTime.now();
    Map<String, double> output = {"Car": 0, "Bike": 0, "Walk": 0, "Plane": 0};
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
      int difference =
          now.diff(Jiffy.parseFromDateTime(date), unit: Unit.month).toInt();
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
      if (Jiffy.now().diff(Jiffy.parseFromDateTime(date), unit: Unit.month) <
              1 &&
          type[i] == "Car") {
        monthSum += value;
      }
      if (difference < 365 && type[i] == "Car") {
        yearSum += value;
      }
    }
    return [weekSum, monthSum, yearSum];
  }
}

class Energy {
  List<double> eMonthRate;
  List<double> gasMonthRate;

  Energy({
    required this.eMonthRate,
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
      eMonthRate: List<double>.filled(12, 0, growable: false),
      gasMonthRate: List<double>.filled(12, 0, growable: false),
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
    return Carbon(average: 0, goal: 0);
  }

  Map<String, dynamic> toMap() {
    return {
      'average': average,
      'goal': goal,
    };
  }

  double computeEmissionsForDays(
      Miles mileage, Energy energy, int days, BuildContext context) {
    final now = DateTime.now();
    final daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

    List<DateTime> dates = [
      for (int i = days - 1; i >= 0; i--)
        DateTime.now().subtract(Duration(days: i))
    ];

    final units = Provider.of<UnitsProvider>(context, listen: false);
    double electricMonths = 0;
    double gasMonths = 0;
    for (DateTime day in dates) {
      electricMonths +=
          energy.eMonthRate[day.month - 1] / daysInMonth[day.month - 1];
      gasMonths +=
          energy.gasMonthRate[day.month - 1] / daysInMonth[day.month - 1];
    }

    double miles = 0;
    double planes = 0;
    for (int i = 0; i < mileage.time.length; i++) {
      DateTime date = mileage.time[i].toDate();
      int difference = now.difference(date).inDays;
      if (difference < days) {
        if (mileage.type[i] == "Car") {
          miles += mileage.data[i];
        } else if (mileage.type[i] == "Plane") {
          planes += mileage.data[i];
        }
      }
    }
    double carFactor = 0;
    switch (mileage.carType) {
      case "Gas":
        carFactor = 0.170;
      case "Diesel":
        carFactor = 0.171;
      case "Hybrid":
        carFactor = 0.068;
      case "Electric":
        carFactor = 0.047;
    }

    double emissions = units.roundDouble(
        (carFactor * miles +
                1.92 * gasMonths +
                0.475 * electricMonths +
                0.2 * planes) /
            (days * 24),
        2);

    return emissions;
  }

  double computeEmissionPercent(double emissions, BuildContext context){
    final units = Provider.of<UnitsProvider>(context, listen: false);
    double target = average * (1 - (goal / 100));

    if (emissions <= target) {
      return 100;
    }

    return units.roundDouble((target / emissions) * 100, 2);
  }
}
