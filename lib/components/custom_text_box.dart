import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextBox extends StatelessWidget {
  const CustomTextBox({super.key, required this.color, required this.text});

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(12.0, 4.0, 12.0, 4.0),
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        child: Text(
          text,
          style: TextStyle(
            color:
                ThemeData.estimateBrightnessForColor(color) == Brightness.light
                    ? Colors.black
                    : Colors.white,
          ),
          textAlign: TextAlign.center,
        ));
  }
}
