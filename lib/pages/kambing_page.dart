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

    num pedagingKejobongJantan(Map<String, TextEditingController> controllers) {
      num lingkarDada = num.parse(controllers["lingkarDadaCm"]!.text);
      return pow(lingkarDada - 15, 2) / 100;
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
      },
      {
        "title": "Winter",
        "inputs": {
          "lingkarDadaCm": "Lingkar Dada (cm)",
          "panjangBadanCm": "Panjang Badan (cm)"
        },
        "calcFunc": winter,
        "sharedControllers": sharedControllers,
      },
      {
        "title": "Smith",
        "inputs": {"lingkarDadaCm": "Lingkar Dada (cm)"},
        "calcFunc": smith,
        "sharedControllers": sharedControllers,
      },
      {
        "title": "Pedaging Kejobong Jantan",
        "inputs": {"lingkarDadaCm": "Lingkar Dada (cm)"},
        "calcFunc": pedagingKejobongJantan,
        "sharedControllers": sharedControllers,
      },
    ];

    return CalculatorPage(title: "Kambing", calcData: calcData, ternakId: 5);
  }
}
