import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:kalkulator_bbternak/components/calcInput.dart';
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
  String output = "";

  @override
  void initState() {
    super.initState();
    output = "";
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    int penjumlahan(input1, input2) {
      return input1 + input2;
    }

    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the SapiPage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("What is this"),
        ),
        body: Column(children: [
          Text("Testing aja"),
          TextFormField(
            // decoration: InputDecoration(label: Text(widget.inputs[i])),
            controller: input1,
            onChanged: (value) {
              int result =
                  penjumlahan(int.parse(input1.text), int.parse(input2.text));
              output = result.toString();
            },
            keyboardType: TextInputType.number,
          ),
          TextFormField(
              // decoration: InputDecoration(label: Text(widget.inputs[i])),
              controller: input2,
              onChanged: (value) {
                int result =
                    penjumlahan(int.parse(input1.text), int.parse(input2.text));
                output = result.toString();
              },
              keyboardType: TextInputType.number),
          Text(output)
        ]));
  }
}
