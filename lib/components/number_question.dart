import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tracker_app/components/fitted_text.dart';
import 'package:tracker_app/components/text_field.dart';

class NumberQuestion extends StatelessWidget {
  TextEditingController controller;
  String title;
  String trailing;
  bool? error;
  NumberQuestion(
      {super.key,
      required this.controller,
      required this.title,
      required this.trailing,
      this.error});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Center(
          child: FittedText(
              text: title, style: Theme.of(context).textTheme.headlineMedium)),
      const SizedBox(height: 30),
      FittedBox(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
              children: [
                //SizedBox(height: 14,),
                MyNumberField(
                  width: max(MediaQuery.sizeOf(context).width - 210, 100),
                  controller: controller,
                  error: error ?? false,
                  errorMsg: "Invalid input",
                ),
                //SizedBox(height: 14,)
              ],
            ),
            SizedBox(
              width: 100,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: FittedText(text: trailing),
                ),
              ),
            )
          ]),
      ),
    ]);
  }
}
