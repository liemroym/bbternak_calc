import 'dart:html';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kalkulator_bbternak/components/calculator.dart';

class SapiPage extends StatefulWidget {
  const SapiPage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  @override
  State<SapiPage> createState() => _SapiPageState();
}

class _SapiPageState extends State<SapiPage> {
  TextEditingController input1 = TextEditingController();
  TextEditingController input2 = TextEditingController();
  String output = "Result";

  @override
  void initState() {
    super.initState();
    output = "Result";
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
      int? lingkarDada = int.tryParse(controllers["lingkarDada"]!.text);
      return pow(lingkarDada! + 22, 2) / 100;
    }

    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the SapiPage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("What is this"),
        ),
        body: ListView(children: [
          Calculator(
              title: "penjumlahan",
              inputs: ["input1", "input2"],
              calcFunc: schoorl)
          // Text("Testing aja"),
          // TextFormField(
          //   decoration: InputDecoration(label: Text("test1")),
          //   controller: input1,
          //   onChanged: (value) {
          //     int result =
          //         penjumlahan(int.parse(input1.text), int.parse(input2.text));
          //     setState(() {
          //       output = result.toString();
          //     });
          //   },
          //   keyboardType: TextInputType.number,
          // ),
          // TextFormField(
          //     decoration: InputDecoration(label: Text("test2")),
          //     controller: input2,
          //     onChanged: (value) {
          //       int result =
          //           penjumlahan(int.parse(input1.text), int.parse(input2.text));
          //       setState(() {
          //         output = result.toString();
          //       });
          //     },
          //     keyboardType: TextInputType.number),
          // Text(output)
        ]));
  }
}
