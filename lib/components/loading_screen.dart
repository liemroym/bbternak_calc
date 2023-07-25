import 'package:flutter/cupertino.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.5,
        child: Image.asset("assets/images/loading.gif", fit: BoxFit.cover),
      ),
    );
  }
}
