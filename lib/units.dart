import 'package:flutter/material.dart';

enum UnitType {
  imperial(
    weight: 'lbs',
    length: 'miles',
    power: "kWh",
    volume: "Cubic ft"
  ),

  metric(
    weight: 'kg',
    length: 'km',
    power: "kWh",
    volume: "Cubic meters"
  );

  const UnitType({
    required this.weight,
    required this.length,
    required this.power,
    required this.volume,
  });

  final String weight;
  final String length;
  final String power;
  final String volume;
  
}
class UnitsProvider extends ChangeNotifier{
  UnitType _unitType = UnitType.imperial;

  UnitType get unitType => _unitType;

  set unitType(UnitType unitType){
    _unitType = unitType;
    
    notifyListeners();
  }

  bool get isMetric => unitType == UnitType.metric;

  void toggle(){
    if (_unitType == UnitType.imperial){
      unitType = UnitType.metric;
    } else {
      unitType = UnitType.imperial;
    }
  }
}