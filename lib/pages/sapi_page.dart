import 'dart:async';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:kalkulator_bbternak/components/calculator.dart';

class SapiPage extends StatefulWidget {
  const SapiPage({super.key});

  @override
  State<SapiPage> createState() => _SapiPageState();
}

class _SapiPageState extends State<SapiPage> {
  List<int?>? priceJateng, priceKlaten;
  int? lastPriceJateng, lastPriceKlaten;

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

  Future<Map<String, List<int?>?>> fetchPriceData(
      DateTime dateStart, DateTime dateEnd) async {
    int dateDiff = dateEnd.difference(dateStart).inDays;

    final response = await http.post(
      Uri.parse(
          'https://simponiternak.pertanian.go.id/download-harga-komoditas.php?i_laporan=1&data_tanggal_1=${formatDate(dateStart, reversed: false)}&data_tanggal_2=${formatDate(dateEnd, reversed: false)}&data_bulan_1={2012-01}&data_bulan_2=${formatDate(dateEnd).substring(0, 7)}&data_tahun_1=2012&data_tahun_2=${formatDate(dateEnd).substring(0, 4)}&i_komoditas=3&i_type=1&i_showcity=provkab&i_kabupaten[]=3310&i_provinsi[]=33&'),
    );

    final bytes = response.bodyBytes;
    var excel = Excel.decodeBytes(bytes);
    var sheet = excel.tables[excel.tables.keys.first];

    List<String?>? pricesJateng = sheet?.rows[9]
        .getRange(4, 4 + dateDiff)
        .map((e) => e?.value.toString())
        .toList();
    List<String?>? pricesKlaten = sheet?.rows[10]
        .getRange(4, 4 + dateDiff)
        .map((e) => e?.value.toString())
        .toList();

    List<int?>? pricesJatengConverted = pricesJateng
        ?.map((e) => (e == null
            ? null
            : (DateTime.parse(e).difference(DateTime(1900, 1, 1)).inDays + 2)
                .toString()))
        .map((e) => e == null ? null : int.tryParse(e))
        .toList();

    List<int?>? pricesKlatenConverted = pricesKlaten
        ?.map((e) => (e == null
            ? null
            : (DateTime.parse(e).difference(DateTime(1900, 1, 1)).inDays + 2)
                .toString()))
        .map((e) => e == null ? null : int.tryParse(e))
        .toList();

    if (response.statusCode == 200) {
      return {
        "hargaJateng": pricesJatengConverted,
        "hargaKlaten": pricesKlatenConverted
      };
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  void initState() {
    super.initState();
    initPrice();
  }

  void initPrice() async {
    try {
      fetchPriceData(
              DateTime.now().subtract(const Duration(days: 7)), DateTime.now())
          .timeout(Duration(seconds: 5))
          .then((value) => {
                setState(() {
                  priceJateng = value["hargaJateng"];
                  priceKlaten = value["hargaKlaten"];
                })
              })
          .then(((value) => setState((() {
                lastPriceJateng = priceJateng?.whereType<int>().toList().last;
                lastPriceKlaten = priceKlaten?.whereType<int>().toList().last;
              }))));
    } on TimeoutException catch (_) {
      print("Timeout bang");
    }
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
          prices: {
            "priceJateng": lastPriceJateng,
            "priceKlaten": lastPriceKlaten
          },
          sharedControllers: sharedControllers,
        ),
        Calculator(
          title: "Winter",
          inputs: {
            "lingkarDadaCm": "Lingkar Dada (cm)",
            "panjangBadanCm": "Panjang Badan (cm)",
          },
          calcFunc: winter,
          prices: {
            "priceJateng": lastPriceJateng,
            "priceKlaten": lastPriceKlaten
          },
          sharedControllers: sharedControllers,
        ),
        Calculator(
          title: "Smith",
          inputs: {"lingkarDadaCm": "Lingkar Dada (cm)"},
          calcFunc: smith,
          prices: {
            "priceJateng": lastPriceJateng,
            "priceKlaten": lastPriceKlaten
          },
          sharedControllers: sharedControllers,
        ),
        Text(lastPriceJateng.toString()),
        Text(lastPriceKlaten.toString()),
      ]),
    );
  }
}
