import 'package:flutter/material.dart';

class FittedText  extends StatelessWidget{
  final String text;
  final TextStyle? style;

  const FittedText({
    super.key,
    required this.text,
    this.style,
  });
  
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: SizedBox(
        child: Text(
          text,
          style: style ?? Theme.of(context).textTheme.displaySmall,
        ),
      ),
    );
  }
}