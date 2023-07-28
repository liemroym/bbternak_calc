import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kalkulator_bbternak/components/calculator_page.dart';

class SapiPage extends StatefulWidget {
  const SapiPage({super.key});

  @override
  State<SapiPage> createState() => _SapiPageState();
}

class _SapiPageState extends State<SapiPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    num schoorl(Map<String, TextEditingController> controllers) {
      num lingkarDada = num.parse(controllers["lingkarDadaCm"]!.text);
      return pow(lingkarDada + 22, 2) / 100;
    }

    num winter(Map<String, TextEditingController> controllers) {
      num lingkarDadaInch =
          num.parse(controllers["lingkarDadaCm"]!.text) / 2.54;
      num panjangBadanInch =
          num.parse(controllers["panjangBadanCm"]!.text) / 2.54;

      num bbPounds = pow(lingkarDadaInch, 2) * panjangBadanInch / 300;
      return bbPounds * 0.453592;
    }

    num smith(Map<String, TextEditingController> controllers) {
      num lingkarDada = num.parse(controllers["lingkarDadaCm"]!.text);
      return pow(lingkarDada + 18, 2) / 100;
    }

    Map<String, TextEditingController> sharedControllers = {
      "lingkarDadaCm": TextEditingController()
    };

    List<Map<String, dynamic>> calcData = [
      {
        "title": "Schoorl",
        "inputs": {"lingkarDadaCm": "Lingkar Dada (cm)"},
        "calcFunc": schoorl,
        "sharedControllers": sharedControllers,
        "details": "Test detail"
      },
      {
        "title": "Winter",
        "inputs": {
          "lingkarDadaCm": "Lingkar Dada (cm)",
          "panjangBadanCm": "Panjang Badan (cm)",
        },
        "calcFunc": winter,
        "sharedControllers": sharedControllers,
        "details": "Test detail"
      },
      {
        "title": "Smith",
        "inputs": {"lingkarDadaCm": "Lingkar Dada (cm)"},
        "calcFunc": smith,
        "sharedControllers": sharedControllers,
        "details": "Test detail"
      }
    ];

    return CalculatorPage(title: "Sapi", calcData: calcData, ternakId: 3);
  }
}
