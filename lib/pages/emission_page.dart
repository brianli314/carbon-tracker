import 'package:flutter/material.dart';
import 'package:tracker_app/components/fitted_text.dart';

class EmissionPage extends StatelessWidget{
  const EmissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FittedText(text: "E M M I S S I O N S", style: Theme.of(context).textTheme.headlineLarge),
        centerTitle: true,
      ),
    );
  }
}