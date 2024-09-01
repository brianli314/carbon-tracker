import 'package:flutter/material.dart';

class MyDropDownMenu<T> extends StatefulWidget{
  T? initialSelection;
  List<DropdownMenuEntry<T>> options;
  void Function(dynamic)? onChanged;
  double? width;
  double? height;

  MyDropDownMenu({
    super.key,
    required this.options,
    this.initialSelection,
    this.onChanged,
    this.width,
    this.height,
  });


  
  @override
  State<MyDropDownMenu> createState() => _MyDropDownMenuState();
}

class _MyDropDownMenuState extends State<MyDropDownMenu> {
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: SizedBox(
        height: widget.height,
        width: widget.width,
        child: DropdownMenu(
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
          ),
      ),
    );
  }
}