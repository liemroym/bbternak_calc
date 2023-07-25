import 'package:flutter/cupertino.dart';

class TextBox extends StatelessWidget {
  const TextBox({super.key, required this.color, required this.text});

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(backgroundColor: color),
      textAlign: TextAlign.center,
    );
  }
}
