import 'dart:math';

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

  double convertFromMetric(String type, double value){
      if (isMetric) {
        return roundDouble(value, 2);
      }
      switch (type){
        case 'miles':
          return roundDouble(value * 0.621371, 2);
        case 'lbs':
          return roundDouble(value * 2.20462, 2);
        case 'Cubic ft':
          return roundDouble(value * 35.3147,2);
        default:
          throw ArgumentError("Invalid unit");
      }
  }

  double convertToMetric(String type, double value){
    if (isMetric){
      return value;
    }
    switch (type){
        case 'miles':
          return value * 1.60934;
        case 'lbs':
          return value * 0.453592;
        case 'Cubic ft':
          return value * 0.0283168;
        default:
          throw ArgumentError("Invalid unit");
      }
  }

  double roundDouble(double value, int places){ 
    num mod = pow(10.0, places); 
    return ((value * mod).round().toDouble() / mod); 
  }
  void toggle(){
    if (_unitType == UnitType.imperial){
      unitType = UnitType.metric;
    } else {
      unitType = UnitType.imperial;
    }
  }
}