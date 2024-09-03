import 'package:flutter/material.dart';

class LoadingCircle extends StatelessWidget{
  const LoadingCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const CircularProgressIndicator(),
      const SizedBox(
        height: 10,
      ),
      Text("Loading...", style: Theme.of(context).textTheme.displayMedium),
    ]));
  }
  
}