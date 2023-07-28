import 'package:flutter/cupertino.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FractionallySizedBox(
          widthFactor: 0.4,
          child: Image.asset("assets/images/error.png", fit: BoxFit.cover),
        ),
        Spacer(),
        Text(message,
            textAlign: TextAlign.center, style: TextStyle(fontSize: 10))
      ],
    ));
  }
}
