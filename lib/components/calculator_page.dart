import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:kalkulator_bbternak/components/calculator.dart';
import 'package:kalkulator_bbternak/components/custom_text_box.dart';
import 'package:kalkulator_bbternak/components/error_screen.dart';
import 'package:kalkulator_bbternak/components/loading_screen.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'coachmark_desc.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage(
      {super.key,
      required this.title,
      required this.calcData,
      required this.ternakId});

  final List<Map<String, dynamic>> calcData;
  final String title;
  final int ternakId;

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  static const int priceDuration = 30;
  List<int?> priceJateng = [], priceYogya = [], priceKlaten = [];
  List<String?> priceDates = [];
  int lastPriceJateng = 0, lastPriceYogya = 0, lastPriceKlaten = 0;
  TutorialCoachMark? tutorialCoachMark;
  List<TargetFocus> targets = [];
  GlobalKey chartKey = GlobalKey();
  GlobalKey priceKey = GlobalKey();
  GlobalKey calcKey = GlobalKey();

  Widget priceChart = LoadingScreen();

  Future<Map<String, List<dynamic>?>> fetchPriceData(
      DateTime dateStart, DateTime dateEnd) async {
    List<String?> getDataFromRow(
        Sheet? sheet, int row, int rangeStart, int rangeEnd) {
      return sheet?.rows[row]
              .getRange(rangeStart, rangeEnd)
              .map((e) => e?.value.toString())
              .toList() ??
          [];
    }

    List<int?> convertDateTimeStringToInt(List<String?> listOfDateTimeString) {
      return listOfDateTimeString
          .map((e) => (e == null
              ? null
              : (DateTime.parse(e).difference(DateTime(1900, 1, 1)).inDays + 2)
                  .toString()))
          .map((e) => e == null ? null : int.tryParse(e))
          .toList();
    }

    try {
      int dateDiff = dateEnd.difference(dateStart).inDays;
      final String apiUrl =
          'https://simponiternak.pertanian.go.id/download-harga-komoditas.php?i_laporan=1&data_tanggal_1=${DateFormat("dd-MM-yyyy").format(dateStart)}&data_tanggal_2=${DateFormat("dd-MM-yyyy").format(dateEnd)}&data_bulan_1=2012-01&data_bulan_2=${DateFormat("yyyy-MM").format(dateEnd)}&data_tahun_1=2012&data_tahun_2=${DateFormat("yyyy").format(dateEnd)}&i_komoditas=${widget.ternakId}&i_type=1&i_showcity=provkab&i_kabupaten[]=3310&i_kabupaten[]=3471&i_provinsi[]=33&i_provinsi[]=34&';

      // Response is in excel
      final http.Response response;
      response = await http.post(
        Uri.parse(apiUrl),
      );

      final bytes = response.bodyBytes;
      final Excel excel;
      try {
        excel = Excel.decodeBytes(bytes);
      } catch (_) {
        return fetchPriceData(
            DateTime.now().subtract(Duration(days: priceDuration + 1)),
            DateTime.now().subtract(Duration(days: 1)));
      }
      Sheet? sheet = excel.tables[excel.tables.keys.first];

      // Get price from excel
      List<String?> dates = getDataFromRow(sheet, 7, 4, 4 + dateDiff);
      List<String?> pricesJatengDateTime =
          getDataFromRow(sheet, 9, 4, 4 + dateDiff);
      List<String?> pricesKlatenDateTime =
          getDataFromRow(sheet, 10, 4, 4 + dateDiff);
      List<String?> pricesYogyaDateTime =
          getDataFromRow(sheet, 11, 4, 4 + dateDiff);

      // Excel converted price is in ISO DateTime and needs to be converted to integer
      List<int?> pricesJatengConverted =
          convertDateTimeStringToInt(pricesJatengDateTime);
      List<int?> pricesKlatenConverted =
          convertDateTimeStringToInt(pricesKlatenDateTime);
      List<int?> pricesYogyaConverted =
          convertDateTimeStringToInt(pricesYogyaDateTime);

      if (response.statusCode == 200) {
        return {
          "priceJateng": pricesJatengConverted,
          "priceKlaten": pricesKlatenConverted,
          "priceYogya": pricesYogyaConverted,
          "priceDates": dates
        };
      } else {
        throw Exception(
            "Tidak dapat mengambil data harga, pastikan anda terhubung dengan koneksi internet");
      }
    } catch (_) {
      print(_);
      throw Exception(
          "Tidak dapat mengambil data harga, pastikan anda terhubung dengan koneksi internet");
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      _showTutorialCoachmark();
    });

    initPrice();
  }

  void _showTutorialCoachmark() {
    targets = [
      TargetFocus(
          identify: "chart-key",
          keyTarget: chartKey,
          shape: ShapeLightFocus.RRect,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (context, controller) {
                return CoachmarkDesc(
                  text:
                      "Grafik garis berisikan perkembangan harga ternak. Data harga diperoleh dari website pemerintah: simponiternak.pertanian.go.id",
                  onNext: () {
                    controller.next();
                  },
                  onSkip: () {
                    controller.skip();
                  },
                );
              },
            )
          ]),
      TargetFocus(
          identify: "price-key",
          keyTarget: priceKey,
          shape: ShapeLightFocus.RRect,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (context, controller) {
                return CoachmarkDesc(
                  text:
                      "Harga ternak terbaru (Rp per kg/BH (Berat Hidup)) serta tanggal harga terakhir diambil (digunakan dalam penghitungan harga sapi)",
                  onNext: () {
                    controller.next();
                  },
                  onSkip: () {
                    controller.skip();
                  },
                );
              },
            )
          ]),
      TargetFocus(
          identify: "calc-key",
          keyTarget: calcKey,
          shape: ShapeLightFocus.RRect,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (context, controller) {
                return CoachmarkDesc(
                  text: "Bagian kalkulator dengan berbagai macam rumus",
                  image: "assets/images/calc_description.png",
                  onNext: () {
                    controller.next();
                  },
                  onSkip: () {
                    controller.skip();
                  },
                );
              },
            )
          ]),
    ];
    tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      pulseEnable: false,
      colorShadow: Colors.green.withAlpha(64),
      onClickTarget: (target) {
        print("${target.identify}");
      },
      hideSkip: true,
      onFinish: () {
        Navigator.pushNamed(context, '/sapi');
        print("Finish");
      },
    )..show(context: context);
  }

  void initPrice() async {
    try {
      // Fetch past  days data from government website
      Map<String, List<dynamic>?> value = await fetchPriceData(
              DateTime.now().subtract(const Duration(days: priceDuration)),
              DateTime.now())
          // Add timeout for 10 seconds
          .timeout(Duration(seconds: 10));

      LineChartBarData getChartSpotsFromList(Color color, List<int?> data) {
        return LineChartBarData(
          isCurved: true,
          barWidth: 2,
          isStrokeCapRound: true,
          color: color,
          spots: data
              .asMap()
              .entries
              .map((price) {
                if (price.value != null) {
                  return FlSpot(price.key.toDouble(), price.value!.toDouble());
                }
              })
              .whereType<FlSpot>()
              .toList(),
        );
      }

      setState(() {
        priceDates = value["priceDates"]!.cast<String?>();
        priceJateng = value["priceJateng"]!.cast<int?>();
        priceKlaten = value["priceKlaten"]!.cast<int?>();
        // priceYogya = value["priceYogya"]!.cast<int?>();

        List<int>? priceJatengFiltered = priceJateng.whereType<int>().toList();
        List<int>? priceKlatenFiltered = priceKlaten.whereType<int>().toList();
        // List<int>? priceYogyaFiltered = priceYogya.whereType<int>().toList();

        lastPriceJateng =
            priceJatengFiltered.isNotEmpty ? priceJatengFiltered.last : 0;
        lastPriceKlaten =
            priceKlatenFiltered.isNotEmpty ? priceKlatenFiltered.last : 0;
        // lastPriceYogya =
        //     priceYogyaFiltered.isNotEmpty ? priceYogyaFiltered.last : 0;

        priceChart = LineChart(LineChartData(
            minX: 0,
            maxX: priceDuration.toDouble(),
            minY: 0,
            maxY: 100000,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              horizontalInterval: 1,
              verticalInterval: 1,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.white,
                  strokeWidth: 1,
                );
              },
              getDrawingVerticalLine: (value) {
                return FlLine(
                  color: Colors.white,
                  strokeWidth: 1,
                );
              },
            ),
            titlesData: FlTitlesData(
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                      showTitles: true,
                      interval: priceDuration / 6,
                      getTitlesWidget: (value, meta) {
                        if (priceDates != null) {
                          var date = value.toInt() < priceDates.length
                              ? priceDates[value.toInt()]
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
              getChartSpotsFromList(Colors.red, priceJateng),
              getChartSpotsFromList(Colors.yellow, priceKlaten),
              // getChartSpotsFromList(Colors.blue, priceYogya)
            ]));
      });
    } on TimeoutException catch (_) {
      setState(() {
        priceChart = const ErrorScreen(
            message:
                "Tidak dapat mengambil data harga, pastikan anda terhubung dengan koneksi internet");
      });
    } catch (err) {
      // Handle error
      setState(() {
        priceChart = ErrorScreen(message: err.toString().substring(11));
      });
    }
  }

  String? getLastDate(List<int?> price, List<String?> dates) {
    int lastIndexFiltered = price.whereType<int>().length;
    if (lastIndexFiltered > 0) {
      return dates[lastIndexFiltered - 1];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, TextEditingController> sharedControllers = {
      "lingkarDadaCm": TextEditingController()
    };

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the KambingPage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: ListView(children: [
        Container(
            key: chartKey,
            width: 50,
            height: MediaQuery.of(context).textScaleFactor * 200,
            margin: EdgeInsets.all(20),
            child: priceChart),
        Container(
          key: priceKey,
          alignment: Alignment.center,
          margin: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Row(
              children: [
                // Spacer(),
                CustomTextBox(
                    color: Colors.red,
                    title: "Harga Jawa Tengah:",
                    value:
                        "Rp. ${NumberFormat('#,##0.00').format(lastPriceJateng)} / kgBH",
                    remark: getLastDate(priceJateng, priceDates)),
                // Spacer(),
                CustomTextBox(
                    color: Colors.yellow,
                    title: "Harga Klaten:",
                    value:
                        "Rp. ${NumberFormat('#,##0.00').format(lastPriceKlaten)} / kgBH",
                    remark: getLastDate(priceKlaten, priceDates)),
                // CustomTextBox(
                //   color: Colors.blue,
                //   title:
                //       "Harga Yogyakarta:\nRp. ${NumberFormat('#,##0.00').format(lastPriceYogya)}"                  value: )
                // ),,
                // Spacer(),
              ],
            ),
            scrollDirection: Axis.horizontal,
          ),
        ),
        Container(
          key: calcKey,
          child: Column(
            children: [
              ...widget.calcData
                  .map((e) => Calculator(
                        title: e["title"],
                        inputs: e["inputs"],
                        calcFunc: e["calcFunc"],
                        sharedControllers: e["sharedControllers"],
                        details: e["details"],
                        prices: {
                          "priceJateng": lastPriceJateng,
                          "priceKlaten": lastPriceKlaten
                          // "priceYogya": lastPriceYogya,
                        },
                      ))
                  .toList()
            ],
          ),
        ),
      ]),
    );
  }
}
