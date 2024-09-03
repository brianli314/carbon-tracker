import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  Widget? trailingWidget;
  late CrossAxisAlignment crossAxisAlignment;
  late TextStyle titleStyle;
  late TextStyle subtitleStyle;
  String title;
  String? subtitle;
  Widget? leadingWidget;
  CustomListTile(
      {super.key,
      this.trailingWidget,
      this.crossAxisAlignment = CrossAxisAlignment.center,
      this.titleStyle =
          const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      this.subtitleStyle =
          const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
      required this.title,
      this.subtitle,
      this.leadingWidget});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        leadingWidget ?? Container(),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                title,
                style: titleStyle,
              ),
              Text(subtitle ?? "", style: subtitleStyle),
            ],
          ),
        ),
        const SizedBox(width: 16),
        trailingWidget ?? Container()
      ],
    );
  }
}