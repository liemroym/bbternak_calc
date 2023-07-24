import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:kalkulator_bbternak/components/calculator.dart';

class SapiPage extends StatefulWidget {
  const SapiPage({super.key});

  @override
  State<SapiPage> createState() => _SapiPageState();
}

class _SapiPageState extends State<SapiPage> {
  static const int PRICE_DATA = 30;
  List<int?>? priceJateng = [], priceKlaten = [];
  List<String?>? priceDates = [];
  int? lastPriceJateng = 0, lastPriceKlaten = 0;

  Future<Map<String, List<dynamic?>?>> fetchPriceData(
      DateTime dateStart, DateTime dateEnd) async {
    int dateDiff = dateEnd.difference(dateStart).inDays;

    // Response is in excel
    final response = await http.post(
      Uri.parse(
          'https://simponiternak.pertanian.go.id/download-harga-komoditas.php?i_laporan=1&data_tanggal_1=${DateFormat("dd-MM-yyyy").format(dateStart)}&data_tanggal_2=${DateFormat("dd-MM-yyyy").format(dateEnd)}&data_bulan_1={2012-01}&data_bulan_2=${DateFormat("yyyy-MM").format(dateEnd)}&data_tahun_1=2012&data_tahun_2=${DateFormat("yyyy").format(dateEnd)}&i_komoditas=3&i_type=1&i_showcity=provkab&i_kabupaten[]=3310&i_provinsi[]=33&'),
    );

    final bytes = response.bodyBytes;
    var excel = Excel.decodeBytes(bytes);
    var sheet = excel.tables[excel.tables.keys.first];

    // Get price from excel
    List<String?>? dates = sheet?.rows[7]
        .getRange(4, 4 + dateDiff)
        .map((e) => e?.value.toString())
        .toList();
    List<String?>? pricesJateng = sheet?.rows[9]
        .getRange(4, 4 + dateDiff)
        .map((e) => e?.value.toString())
        .toList();
    List<String?>? pricesKlaten = sheet?.rows[10]
        .getRange(4, 4 + dateDiff)
        .map((e) => e?.value.toString())
        .toList();

    // Excel converted price is in ISO DateTime and needs to be converted to integer
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
        "priceJateng": pricesJatengConverted,
        "priceKlaten": pricesKlatenConverted,
        "priceDates": dates
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
      // Fetch past 7 days data from government website
      fetchPriceData(DateTime.now().subtract(const Duration(days: PRICE_DATA)),
              DateTime.now())
          // Add timeout for 5 second
          .timeout(Duration(seconds: 5))
          .then((value) => {
                setState(() {
                  priceJateng = value["priceJateng"]?.cast<int?>();
                  priceKlaten = value["priceKlaten"]?.cast<int?>();
                  priceDates = value["priceDates"]?.cast<String?>();
                })
              })
          .then(((value) => setState((() {
                lastPriceJateng = priceJateng?.whereType<int>().toList().last;
                lastPriceKlaten = priceKlaten?.whereType<int>().toList().last;
              }))));
    } on TimeoutException catch (_) {
      // Handle timeout
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
        Container(
          width: 50,
          height: 200,
          margin: EdgeInsets.all(20),
          child: LineChart(LineChartData(
              minX: 0,
              maxX: PRICE_DATA.toDouble(),
              minY: 0,
              maxY: 100000,
              titlesData: FlTitlesData(
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        interval: PRICE_DATA / 6,
                        getTitlesWidget: (value, meta) {
                          if (priceDates != null) {
                            var date = value.toInt() < priceDates!.length
                                ? priceDates![value.toInt()]
                                : "";

                            return Transform.rotate(
                                angle: -0.2,
                                child: SideTitleWidget(
                                    axisSide: meta.axisSide,
                                    child: Text(
                                      "$date",
                                      style: TextStyle(fontSize: 10),
                                    )));
                          } else {
                            return SideTitleWidget(
                                child: Text(""), axisSide: meta.axisSide);
                          }
                        })),
              ),
              lineBarsData: [
                LineChartBarData(
                    spots: priceJateng!.asMap().entries.map((price) {
                  return FlSpot(price.key.toDouble(), price.value!.toDouble());
                }).toList())
              ])),
        ),
        Container(
          margin: EdgeInsets.all(20),
          child: Row(
            children: [
              Spacer(),
              Text("Harga Jateng: ${lastPriceJateng.toString()}"),
              Spacer(),
              Text("Harga Klaten: ${lastPriceKlaten.toString()}"),
              Spacer(),
            ],
          ),
        ),
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
      ]),
    );
  }
}
