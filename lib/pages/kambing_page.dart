import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kalkulator_bbternak/components/calculator.dart';
import 'package:kalkulator_bbternak/components/calculator_page.dart';

class KambingPage extends StatefulWidget {
  const KambingPage({super.key});

  @override
  State<KambingPage> createState() => _KambingPageState();
}

class _KambingPageState extends State<KambingPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    num ardjodarmoko(Map<String, TextEditingController> controllers) {
      num lingkarDada = num.parse(controllers["lingkarDadaCm"]!.text);
      num panjangBadan = num.parse(controllers["panjangBadanCm"]!.text);
      return pow(lingkarDada, 2) * panjangBadan / 10000;
    }

    num scheifferLambourne(Map<String, TextEditingController> controllers) {
      num lingkarDadaInch =
          num.parse(controllers["lingkarDadaCm"]!.text) / 2.54;
      num panjangBadanInch =
          num.parse(controllers["panjangBadanCm"]!.text) / 2.54;

      num bbPounds = pow(lingkarDadaInch, 2) * panjangBadanInch / 300;
      return bbPounds * 0.453592;
    }

    Map<String, TextEditingController> sharedControllers = {
      "lingkarDadaCm": TextEditingController(),
      "panjangBadanCm": TextEditingController()
    };

    List<Map<String, dynamic>> calcData = [
      {
        "title": "Ardjodarmoko",
        "inputs": {
          "lingkarDadaCm": "Lingkar Dada (cm)",
          "panjangBadanCm": "Panjang Badan (cm)"
        },
        "calcFunc": ardjodarmoko,
        "sharedControllers": sharedControllers,
        "details": "Test detail"
      },
      {
        "title": "Scheiffer-Lambourne",
        "inputs": {
          "lingkarDadaCm": "Lingkar Dada (cm)",
          "panjangBadanCm": "Panjang Badan (cm)"
        },
        "calcFunc": scheifferLambourne,
        "sharedControllers": sharedControllers,
        "details": "Test detail"
      },
    ];

    return CalculatorPage(title: "Kambing", calcData: calcData, ternakId: 5);
  }
}
