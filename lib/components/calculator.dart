import 'package:flutter/material.dart';
// import 'package:kalkulator_bbternak/components/calcInput.dart';

class Calculator extends StatefulWidget {
  const Calculator({
    super.key,
    required this.title,
    required this.inputs,
    required this.calcFunc,
  });
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final String title;
  final List<String> inputs;
  final Function calcFunc;

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String output = "";
  final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _controllers.addAll(
        List.generate(widget.inputs.length, (_) => TextEditingController()));
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Column(children: [
      Text(widget.title),
      Form(
        child: Row(
          children: [
            for (int i = 0; i < widget.inputs.length; i++)
              TextFormField(
                  // decoration: InputDecoration(label: Text(widget.inputs[i])),
                  controller: _controllers[i],
                  onChanged: (value) {
                    List<int> inputData = _controllers
                        .map((controller) => int.tryParse(controller.text) ?? 0)
                        .toList();
                    int result = widget.calcFunc(inputData);
                    output = result.toString();
                  }),
          ],
        ),
      ),
      Text(output)
    ]);
  }
}
