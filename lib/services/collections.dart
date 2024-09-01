import 'package:cloud_firestore/cloud_firestore.dart';

class Miles {
  List<num> data;
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
        data: List<num>.from(doc['data']),
        type: List<String>.from(doc['type']));
  }

  factory Miles.defaultInputs(){
    return Miles(
      data: [],
      time: [],
      type: []
    );
  }

  Map<String, dynamic> toMap() {
    return {'data': data, 'time': time, 'type': type};
  }

  num getCarMilesForDays(int days) {
    DateTime now = DateTime.now();
    num counter = 0;
    for (int i = 0; i < data.length; i++) {
      DateTime date = time[i].toDate();
      num value = data[i];
      int difference = now.difference(date).inDays;
      if (difference < 7 && type[i] == "Car") {
        counter += value;
      }
    }
    return counter;
  }

  List<num> getAllCarStats() {
    DateTime now = DateTime.now();

    if (data.length != time.length) {
      throw ArgumentError("Lists must be same size");
    }

    num weekSum = 0;
    num monthSum = 0;
    num yearSum = 0;
    for (int i = 0; i < data.length; i++) {
      DateTime date = time[i].toDate();
      num value = data[i];
      int difference = now.difference(date).inDays;
      if (difference < 7 && type[i] == "Car") {
        weekSum += value;
      }
      if (difference < 31) {
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
  num electricRate;
  List<num> eMonthRate;
  num gasRate;
  List<num> gasMonthRate;

  Energy({
    required this.electricRate,
    required this.eMonthRate,
    required this.gasRate,
    required this.gasMonthRate
  });


  factory Energy.fromDocument(DocumentSnapshot doc) {
    return Energy(
        electricRate: doc['electricity'], 
        eMonthRate: List<num>.from(doc['electricityMonth']),
        gasRate: doc['gas'],
        gasMonthRate: List<num>.from(doc['gasMonth']),
      );
  }

  factory Energy.defaultInputs(){
    return Energy(
      electricRate: 0,
      eMonthRate: List.filled(12, 0),
      gasRate: 0,
      gasMonthRate: List.filled(12, 0),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'electricity': electricRate, 
      'electricityMonth': eMonthRate,
      'gas': gasRate,
      'gasMonth': gasMonthRate,
    };
  }
}

class Carbon {
  num average;
  num goal;

  Carbon({
    required this.average,
    required this.goal,
  });

  factory Carbon.fromDocument(DocumentSnapshot doc) {
    return Carbon(average: doc['average'], goal: doc['goal']);
  }

  factory Carbon.defaultInputs(){
    return Carbon(
      average: 0.8,
      goal: 1.6
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'average': average,
      'goal': goal,
    };
  }

  num computeEmissionsForDays(Miles mileage, Energy energy, int days) {
    return average;
  }
}
