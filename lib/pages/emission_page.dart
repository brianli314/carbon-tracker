import 'package:flutter/material.dart';

class EmissionPage extends StatelessWidget{
  const EmissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("E M M I S S I O N S", style: Theme.of(context).textTheme.headlineLarge),
        centerTitle: true,
      ),
    );
  }
}