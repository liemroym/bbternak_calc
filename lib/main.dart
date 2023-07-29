import 'package:flutter/material.dart';
import 'package:kalkulator_bbternak/pages/home_page.dart';
import 'package:kalkulator_bbternak/pages/kambing_page.dart';
import 'package:kalkulator_bbternak/pages/sapi_page.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BBTernak Kalkulator',
      theme: ThemeData(
        fontFamily: "Poppins",
        primarySwatch: Colors.green,
      ),
      home: const HomePage(),
      routes: {
        '/sapi': (context) => SapiPage(),
        '/kambing': (context) => KambingPage(),
      },
    );
  }
}
