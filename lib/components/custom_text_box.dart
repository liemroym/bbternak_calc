import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextBox extends StatelessWidget {
  const CustomTextBox(
      {super.key,
      required this.color,
      required this.title,
      required this.value});

  final Color color;
  final String title, value;

  @override
  Widget build(BuildContext context) {
    final Color textColor =
        ThemeData.estimateBrightnessForColor(color) == Brightness.light
            ? Colors.black
            : Colors.white;

    return Container(
        color: color,
        child: Column(children: [
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.w100,
                color: textColor,
                fontSize: MediaQuery.of(context).textScaleFactor * 10),
            textAlign: TextAlign.center,
          ),
          Text(
            value,
            style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).textScaleFactor * 20),
            textAlign: TextAlign.center,
          )
        ]));
  }
}
