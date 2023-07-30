import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kalkulator_bbternak/components/custom_text_box.dart';

class Calculator extends StatefulWidget {
  const Calculator({
    super.key,
    required this.title,
    required this.inputs,
    required this.calcFunc,
    required this.details,
    this.prices,
    this.sharedControllers,
  });

  final String title, details;
  final Map<String, String> inputs; // {id: label}
  final Function calcFunc;
  final Map<String, int?>? prices;
  final Map<String, TextEditingController>? sharedControllers;

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String weight = "0 kg",
      priceJateng = "Rp. 0",
      priceKlaten = "Rp. 0",
      priceYogya = "Rp. 0";
  bool showDetail = true;

  Map<String, TextEditingController> controllers = {};

  @override
  void initState() {
    super.initState();
    controllers = {
      for (var input in widget.inputs.entries)
        input.key: TextEditingController()
    };

    if (widget.sharedControllers != null) {
      for (var controller in widget.sharedControllers!.entries) {
        controller.value.addListener(onTextChanged);
        controllers[controller.key] = controller.value;
      }
    }
  }

  void onTextChanged() {
    num weightCalc = widget.calcFunc(controllers);
    num? priceJatengCalc, priceKlatenCalc, priceYogyaCalc;

    if (widget.prices != null) {
      priceJatengCalc = widget.prices!["priceJateng"]! * weightCalc;
      priceKlatenCalc = widget.prices!["priceKlaten"]! * weightCalc;
      priceYogyaCalc = widget.prices!["priceYogya"]! * weightCalc;
    }

    setState(() {
      weight = "${NumberFormat('#,##0.00').format(weightCalc)} kg";
      priceJateng = "Rp. ${NumberFormat('#,##0.00').format(priceJatengCalc)}";
      priceKlaten = "Rp. ${NumberFormat('#,##0.00').format(priceKlatenCalc)}";
      priceYogya = "Rp. ${NumberFormat('#,##0.00').format(priceYogyaCalc)}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 18),
        ),
        initiallyExpanded: true,
        children: [
          Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: InkWell(
                        onTap: () => setState(() {
                              showDetail = !showDetail;
                            }),
                        child: Text(
                          "Lihat detail rumus",
                          style: TextStyle(color: Colors.blue, fontSize: 14),
                        )),
                  ),
                  Visibility(
                      visible: showDetail,
                      child: Text(
                        widget.details,
                        style: TextStyle(fontSize: 12),
                      )),
                ],
              )),
          Row(
              children: widget.inputs.entries
                  .map((input) => Expanded(
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 0.0),
                          child: TextField(
                            decoration:
                                InputDecoration(label: Text(input.value)),
                            maxLines: 1,
                            style: TextStyle(fontSize: 14),
                            controller: controllers[input.key],
                            onChanged: (value) {
                              onTextChanged();
                            },
                            keyboardType: TextInputType.number,
                          ))))
                  .toList()),
          Container(
              margin: EdgeInsets.only(
                  left: 8.0, right: 8.0, top: 20.0, bottom: 20.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
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
                    CustomTextBox(
                        color: Colors.blue,
                        title: "Harga Yogya:",
                        value: priceYogya),
                  ],
                ),
              )),
        ]);
  }
}
