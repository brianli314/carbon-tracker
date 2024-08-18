import 'dart:ui';
import 'package:flutter/material.dart';

class SizeGetter{
  // First get the FlutterView.
  static FlutterView get view => WidgetsBinding.instance.platformDispatcher.views.first;

  static Size size = view.physicalSize / view.devicePixelRatio;
  
  static double get screenWidth => size.width;
  static double get screenHeight => size.height;

  static double goodHeight = 890.2857142857143;
  static double goodWidth = 411.42857142857144;

  static double get ten => convertHeight(10);
  static double get twenty => convertHeight(20);
  static double get twentyFive => convertHeight(25);
  static double get sixty => convertHeight(60);

  static double convertHeight(double height){
    return (height * screenHeight)/goodHeight;
  }

  static double convertWidth(double width){
    return (width * screenWidth)/goodWidth;
  }
}

