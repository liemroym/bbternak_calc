import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
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
  @override
  void initState() {
    super.initState();
    data = "";
  }

  String data = "";

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

    String formatDate(DateTime dateTime, {bool reversed = true}) {
      String day = dateTime.day.toString().padLeft(2, '0');
      String month = dateTime.month.toString().padLeft(2, '0');
      String year = dateTime.year.toString();

      if (!reversed) {
        return '$day-$month-$year';
      } else {
        return '$year-$month-$day';
      }
    }

    Future<String> fetchPriceData(DateTime dateStart, DateTime dateEnd) async {
      setState((() => data = "Fetching value"));

      int dateDiff = dateEnd.difference(dateStart).inDays;

      final response = await http.post(
        Uri.parse(
            'https://simponiternak.pertanian.go.id/download-harga-komoditas.php?i_laporan=1&data_tanggal_1=${formatDate(dateStart, reversed: false)}&data_tanggal_2=${formatDate(dateEnd, reversed: false)}&data_bulan_1={2012-01}&data_bulan_2=${formatDate(dateEnd).substring(0, 7)}&data_tahun_1=2012&data_tahun_2=${formatDate(dateEnd).substring(0, 4)}&i_komoditas=3&i_type=1&i_showcity=provkab&i_kabupaten[]=3310&i_provinsi[]=33&'),
      );

      final bytes = response.bodyBytes;
      var excel = Excel.decodeBytes(bytes);
      var sheet = excel.tables[excel.tables.keys.first];

      print("${formatDate(dateStart)} ${formatDate(dateEnd)}");

      List<String?>? pricesJateng = sheet?.rows[9]
          .getRange(4, 4 + dateDiff)
          .map((e) => e?.value.toString())
          .toList();
      List<String?>? pricesKlaten = sheet?.rows[10]
          .getRange(4, 4 + dateDiff)
          .map((e) => e?.value.toString())
          .toList();

      pricesJateng = pricesJateng
          ?.map((e) => (e == null
              ? null
              : (DateTime.parse(e).difference(DateTime(1900, 1, 1)).inDays + 2)
                  .toString()))
          .toList();

      pricesKlaten = pricesKlaten
          ?.map((e) => e == null
              ? null
              : (DateTime.parse(e).difference(DateTime(1900, 1, 1)).inDays + 2)
                  .toString())
          .toList();

      // print(sheet?.rows[9].getRange(4, dateDiff));

      // for (var row in sheet!.rows) {
      //   // Get dates
      //   print("${row.first?.value} ${row.first?.value.runtimeType}");
      //   if (row.first?.value == "No") {
      //     dates = row.getRange(4, 4 + dateDiff).cast<String>().toList();
      //   }
      // }

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        // return prices.join("\n");
        return pricesKlaten!.join(" ");
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load album');
      }
    }

    void onPressed() async {
      fetchPriceData(
              DateTime.now().subtract(const Duration(days: 7)), DateTime.now())
          .then((value) => {setState((() => data = value))});
    }

    // fetchAlbum().then((value) => {setState((() => data = value))});

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the KambingPage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Sapi"),
      ),
      body: ListView(children: [
        Calculator(
          title: "Schoorl",
          inputs: {"lingkarDadaCm": "Lingkar Dada (cm)"},
          calcFunc: schoorl,
          sharedControllers: sharedControllers,
        ),
        Calculator(
          title: "Winter",
          inputs: {
            "lingkarDadaCm": "Lingkar Dada (cm)",
            "panjangBadanCm": "Panjang Badan (cm)",
          },
          calcFunc: winter,
          sharedControllers: sharedControllers,
        ),
        Calculator(
          title: "Smith",
          inputs: {"lingkarDadaCm": "Lingkar Dada (cm)"},
          calcFunc: smith,
          sharedControllers: sharedControllers,
        ),
        ElevatedButton(onPressed: onPressed, child: Text("Pressed")),
        Text(data),
      ]),
    );
  }
}
