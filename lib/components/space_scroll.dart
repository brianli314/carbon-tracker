import 'package:flutter/material.dart';

class SpaceBetweenScrollView extends StatefulWidget {
  const SpaceBetweenScrollView({
    super.key,
    required this.child,
    required this.footer,
    this.padding = const EdgeInsets.all(16.0),
  });

  final Widget child;
  final Widget footer;
  final EdgeInsets padding;

  @override
  State<SpaceBetweenScrollView> createState() => _SpaceBetweenScrollViewState();
}

class _SpaceBetweenScrollViewState extends State<SpaceBetweenScrollView> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        padding: widget.padding,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Container(
          width: double.infinity,
          constraints: constraints.copyWith(
            minHeight: constraints.maxHeight - (widget.padding.top + widget.padding.bottom),
            maxHeight: double.infinity,
          ),
          child: IntrinsicHeight(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [widget.child, widget.footer],
            ),
          ),
        ),
      );
    });
  }
}