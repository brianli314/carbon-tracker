import 'package:flutter/material.dart';

class MyButton extends StatelessWidget{
  final String text;
  VoidCallback onTap;
  final double roundEdges;
  
  MyButton({
    super.key,
    required this.text,
    required this.onTap,
    this.roundEdges = 12
  });
  
  @override
  Widget build(BuildContext context) {
    return 
    GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(roundEdges)
        ),
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Text(
            text, 
            style: Theme.of(context).textTheme.displayMedium
          ),
        ),
        
      )
    );
  }

}
