import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracker_app/services/collections.dart';
import 'package:tracker_app/services/firestore.dart';
import 'package:flutter/material.dart';

class DatabaseProvider extends ChangeNotifier {
  final _db = FirestoreDatabase();

  Future<Miles?> userMiles(String uid) => _db.getUserMiles(uid);
  Future<Energy?> userEnergy(String uid) => _db.getUserEnergy(uid);
  Future<Carbon?> userCarbon(String uid) => _db.getUserCarbon(uid);

  Carbon _carbon = Carbon.defaultInputs();
  Miles _miles = Miles.defaultInputs();
  Energy _energy = Energy.defaultInputs();
  bool _setupFinished = false;

  Carbon get carbon => _carbon;
  Miles get miles => _miles;
  Energy get energy => _energy;
  bool get setupFinished => _setupFinished;


  Future<void> loadData(String uid) async {
    Carbon? loadCarbon = (await _db.getUserCarbon(uid));
    Miles? loadMiles = (await _db.getUserMiles(uid));
    Energy? loadEnergy = (await _db.getUserEnergy(uid));
    bool? loadSetup = (await _db.getSetup(uid));
    if (loadCarbon == null || loadMiles == null || loadEnergy == null || loadSetup == null){
      Future.delayed(const Duration(seconds: 5));
      loadData(uid);
    } else {
      _carbon = loadCarbon;
      _miles = loadMiles;
      _energy = loadEnergy;
      _setupFinished = loadSetup;
    }
    notifyListeners();
  }

  Future<void> fillMileage(String uid, double mileage) async {
    miles.data = List.filled(31, roundDouble(mileage / 31, 2), growable: true);
    miles.type = List.filled(31, "Car", growable: true);
    miles.time = [for (int i = 30; i >= 0; i--) Timestamp.fromDate((DateTime.now().subtract(Duration(days: i))))];
    await _db.updateValue("Mileage", uid, miles.toMap());
    notifyListeners();
  }

  Future<void> fillElectric(String uid, double energyInput, double gas) async {
    energy.eMonthRate = List.filled(12, energyInput);
    energy.gasMonthRate = List.filled(12, gas);
    await _db.updateValue("Energy", uid, energy.toMap());
    notifyListeners();
  }

  Future<void> setCarType(String uid, String type) async {
    miles.carType = type;
    await _db.updateValue("Mileage", uid, miles.toMap());
  }

  Future<void> setGoal(String uid, double goal) async {
    carbon.goal = goal;
    await _db.updateValue("Carbon", uid, carbon.toMap());
    notifyListeners();
  }

  Future<void> setAverage(String uid, double average) async {
    carbon.average = average;
    await _db.updateValue("Carbon", uid, carbon.toMap());
    notifyListeners();
  }

  double roundDouble(double value, int places){ 
    num mod = pow(10.0, places); 
    return ((value * mod).round().toDouble() / mod); 
  }

  Future<void> updateEnergyRate(String uid, double rate) async {
    energy.eMonthRate[DateTime.now().month - 1] = rate;
    await _db.updateValue("Energy", uid, energy.toMap());
    notifyListeners();
  }

  Future<void> updateGasRate(String uid, double rate) async {
    energy.gasMonthRate[DateTime.now().month - 1] = rate;
    await _db.updateValue("Energy", uid, energy.toMap());
    notifyListeners();
  }

  Future<void> completeSetup(String uid) async {
    _setupFinished = true;
    await _db.updateValue("Setup", uid, {"setupFinished": true});
    notifyListeners();
  }

  Future<void> addMileage(String uid, double mileage, String type) async {
    DateTime now = DateTime.now();
    Timestamp nowTime = Timestamp.now();
    List<int> indexes = getIndexes(now, type);
    if (indexes.length > 1){
      print("Error: Multiple trips on the same day");
    }
    if (indexes.isNotEmpty){
      miles.data[indexes.first] += mileage;
      miles.time[indexes.first] = nowTime;
    } else {
      miles.data.add(mileage);
      miles.type.add(type);
      miles.time.add(nowTime);
    }
    
    await _db.updateValue("Mileage", uid, miles.toMap());
    notifyListeners();
  }

  List<int> getIndexes(DateTime date, String type){
    List<int> indexes =
        miles.time
        .where((time) => sameDay(date, time.toDate()))
        .map((time) => miles.time.indexOf(time))
        .where((idx) => miles.type[idx] == type)
        .toList();
    if (indexes.length > 1){
        print("Error: Multiple trips on the same day");
    }
    return indexes;
  }

  bool sameDay(DateTime day, DateTime other){
    return day.year == other.year && day.month == other.month && day.day == other.day;
  }

  double getMileageFromDate(DateTime day, String type){
    List<int> indexes = getIndexes(day, type);
    if(indexes.isNotEmpty){
      return miles.data[indexes.first];
    } else {
      return 0.0;
    }
  }

  Future<void> setMileageFromDate(DateTime day, String type, double mileage, String uid) async {
    Timestamp nowTime = Timestamp.now();
    List<int> indexes = getIndexes(day, type);
    if(indexes.isNotEmpty){
      miles.data[indexes.first] = mileage;
    } else {
      miles.data.add(mileage);
      miles.type.add(type);
      miles.time.add(nowTime);
    }
    await _db.updateValue("Mileage", uid, miles.toMap());
    notifyListeners();
  }
}