import 'package:tracker_app/services/collections.dart';
import 'package:tracker_app/services/firestore.dart';
import 'package:flutter/material.dart';

class DatabaseProvider extends ChangeNotifier{
  final _db = FirestoreDatabase();
  
  
  Future<Miles?> userMiles(String uid) => _db.getUserMiles(uid);
  Future<Energy?> userEnergy(String uid) => _db.getUserEnergy(uid);
  Future<Carbon?> userCarbon(String uid) => _db.getUserCarbon(uid);
   
  Carbon _carbon = Carbon.defaultInputs();
  Miles _miles = Miles.defaultInputs();
  Energy _energy = Energy.defaultInputs();

  Carbon get carbon => _carbon;
  Miles get miles => _miles;
  Energy get energy => _energy;
  

  Future<void> loadData(String uid) async {
    _carbon = (await _db.getUserCarbon(uid))!;
    _miles = (await _db.getUserMiles(uid))!;
    _energy = (await _db.getUserEnergy(uid))!;
    notifyListeners();
  }

  Future<void> updateEnergyRate(String uid, num rate) async {
    energy.electricRate = rate;
    await _db.updateValue("Energy", uid, energy.toMap());
    notifyListeners();
  }
}