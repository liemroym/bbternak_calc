import 'package:flutter/material.dart';
import 'package:kalkulator_bbternak/pages/homePage.dart';
import 'package:kalkulator_bbternak/pages/kambingPage.dart';
import 'package:kalkulator_bbternak/pages/sapiPage.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BBTernak Calculator',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
      ),
      home: const HomePage(title: 'Kalkulator BB Ternak'),
      routes: {
        '/sapi': (context) => SapiPage(),
        '/kambing': (context) => KambingPage(),
      },
    );
  }
}
