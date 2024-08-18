import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatefulWidget{
  final String hintText;
  final bool hideText;
  final TextEditingController controller;
  final bool error;
  final String? errorMsg;

  

  const MyTextField({
    super.key,
    required this.hintText,
    required this.hideText,
    required this.controller,
    this.error = false,
    this.errorMsg,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
      return TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: const BorderSide(width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
          hintText: widget.hintText,
          hintStyle: Theme.of(context).textTheme.labelSmall,
          errorText: widget.error ? widget.errorMsg : null
        ),
        obscureText: widget.hideText,
        
      );
    }
}

class MyNumberField extends StatefulWidget{
  final String hintText;
  final TextEditingController controller;
  final bool error;
  final String? errorMsg;
  final double? width;
  final double? height;
  const MyNumberField({
    super.key,
    required this.hintText,
    required this.controller,
    this.error = false,
    this.errorMsg,
    this.width,
    this.height
  });

  @override
  State<MyNumberField> createState() => _MyNumberFieldState();
}

class _MyNumberFieldState extends State<MyNumberField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      padding: const EdgeInsets.all(0),
      child: TextField(
          controller: widget.controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: const BorderSide(width: 1.5),
              borderRadius: BorderRadius.circular(12),
            ),
            hintText: widget.hintText,
            hintStyle: Theme.of(context).textTheme.labelSmall,
            errorText: widget.error ? widget.errorMsg : null
          ),
        ),
    );
  }
}