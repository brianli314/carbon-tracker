import 'package:flutter/material.dart';

class MyDropDownMenu<T> extends StatefulWidget{
  T? initialSelection;
  List<DropdownMenuEntry<T>> options;
  void Function(dynamic)? onChanged;

  MyDropDownMenu({
    super.key,
    required this.options,
    this.initialSelection,
    this.onChanged,
  });


  
  @override
  State<MyDropDownMenu> createState() => _MyDropDownMenuState();
}

class _MyDropDownMenuState extends State<MyDropDownMenu> {
  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
        textStyle: Theme.of(context).textTheme.displaySmall,
        initialSelection: widget.initialSelection,
        dropdownMenuEntries: widget.options,
        onSelected: widget.onChanged,
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.only(left: 7, right: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }
}