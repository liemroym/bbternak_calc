import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kalkulator_bbternak/components/custom_text_box.dart';

class Calculator extends StatefulWidget {
  const Calculator({
    super.key,
    required this.title,
    required this.inputs,
    required this.calcFunc,
    this.prices,
    this.sharedControllers,
  });

  final String title;
  final Map<String, String> inputs; // {id: label}
  final Function calcFunc;
  final Map<String, int?>? prices;
  final Map<String, TextEditingController>? sharedControllers;

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String weight = "0 kg", priceJateng = "Rp. 0", priceKlaten = "Rp. 0";
  // priceYogya = "Rp. 0";

  Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _controllers = {
      for (var input in widget.inputs.entries)
        input.key: TextEditingController()
    };

    if (widget.sharedControllers != null) {
      for (var controller in widget.sharedControllers!.entries) {
        controller.value.addListener(_onTextChanged);
        _controllers[controller.key] = controller.value;
      }
    }
  }

  void _onTextChanged() {
    num weightCalc = widget.calcFunc(_controllers);
    num? priceJatengCalc, priceKlatenCalc, priceYogyaCalc;
    if (widget.prices != null) {
      priceJatengCalc = widget.prices!["priceJateng"]! * weightCalc;
      priceKlatenCalc = widget.prices!["priceKlaten"]! * weightCalc;
      // priceYogyaCalc = widget.prices!["priceYogya"]! * weightCalc;
    }

    setState(() {
      weight = "${NumberFormat('#,##0.00').format(weightCalc)} kg";
      priceJateng = "Rp. ${NumberFormat('#,##0.00').format(priceJatengCalc)}";
      priceKlaten = "Rp. ${NumberFormat('#,##0.00').format(priceKlatenCalc)}";
      // priceYogya = "Rp. ${NumberFormat('#,##0.00').format(priceYogyaCalc)}";
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return ExpansionTile(
        title: Text(widget.title),
        initiallyExpanded: true,
        children: [
          Row(
              children: widget.inputs.entries
                  .map((input) => Expanded(
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 0.0),
                          child: TextField(
                            decoration:
                                InputDecoration(label: Text(input.value)),
                            controller: _controllers[input.key],
                            onChanged: (value) {
                              _onTextChanged();
                            },
                            keyboardType: TextInputType.number,
                          ))))
                  .toList()),
          Container(
              margin: EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Row(
                  children: [
                    CustomTextBox(
                        color: Colors.green,
                        title: "Berat badan:",
                        value: weight),
                    CustomTextBox(
                        color: Colors.red,
                        title: "Harga Jawa Tengah:",
                        value: priceJateng),
                    CustomTextBox(
                        color: Colors.yellow,
                        title: "Harga Klaten:",
                        value: priceKlaten),
                    // CustomTextBox(
                    //   color: Colors.blue,
                    //   text: "Harga Yogya:\n$priceYogya",
                    // ),
                    // const Spacer(),
                  ],
                ),
                scrollDirection: Axis.horizontal,
              )),
        ]);
  }
}
