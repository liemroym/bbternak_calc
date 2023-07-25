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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    num schoorl(Map<String, TextEditingController> controllers) {
      num lingkarDada = num.parse(controllers["lingkarDadaCm"]!.text);
      return pow(lingkarDada + 22, 2) / 100;
    }

    num winter(Map<String, TextEditingController> controllers) {
      num lingkarDadaInch =
          num.parse(controllers["lingkarDadaCm"]!.text) / 2.54;
      num panjangBadanInch =
          num.parse(controllers["panjangBadanCm"]!.text) / 2.54;

      return pow(lingkarDadaInch, 2) * panjangBadanInch / 300;
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
        "sharedControllers": sharedControllers
      },
      {
        "title": "Winter",
        "inputs": {
          "lingkarDadaCm": "Lingkar Dada (cm)",
          "panjangBadanCm": "Panjang Badan (cm)",
        },
        "calcFunc": winter,
        "sharedControllers": sharedControllers
      },
      {
        "title": "Smith",
        "inputs": {"lingkarDadaCm": "Lingkar Dada (cm)"},
        "calcFunc": smith,
        "sharedControllers": sharedControllers
      }
    ];

    return CalculatorPage(title: "Sapi", calcData: calcData, ternakId: 3);
  }
}
