import 'package:flutter/material.dart';

class Calculator extends StatefulWidget {
  const Calculator({
    super.key,
    required this.title,
    required this.inputs,
    required this.calcFunc,
    this.sharedControllers,
  });
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object x(defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final String title;
  final Map<String, String> inputs; // {id: label}
  final Function calcFunc;
  final Map<String, TextEditingController>? sharedControllers;

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String output = "";
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
    num result = widget.calcFunc(_controllers);
    setState(() {
      output = result.toString();
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
    return Column(children: [
      Text(widget.title),
      Form(
        child: Row(
            children: widget.inputs.entries
                .map((input) => Expanded(
                        child: TextFormField(
                      decoration: InputDecoration(label: Text(input.value)),
                      controller: _controllers[input.key],
                      onChanged: (value) {
                        _onTextChanged();
                      },
                      keyboardType: TextInputType.number,
                    )))
                .toList()),
      ),
      Text(output)
    ]);
  }
}
