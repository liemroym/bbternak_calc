import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextBox extends StatelessWidget {
  const CustomTextBox(
      {super.key,
      required this.color,
      required this.title,
      required this.value,
      this.remark});

  final Color color;
  final String title, value;
  final String? remark;

  @override
  Widget build(BuildContext context) {
    final Color textColor =
        ThemeData.estimateBrightnessForColor(color) == Brightness.light
            ? Colors.black
            : Colors.white;

    return Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: color,
        ),
        child: Column(children: [
          if (remark != null)
            Text(
              remark!,
              style: TextStyle(
                  fontWeight: FontWeight.w100, color: textColor, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.w100, color: textColor, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          Text(
            value,
            style: TextStyle(
                color: textColor, fontWeight: FontWeight.bold, fontSize: 18),
            textAlign: TextAlign.center,
          )
        ]));
  }
}
