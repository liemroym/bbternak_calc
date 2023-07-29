import 'package:flutter/material.dart';
import 'package:kalkulator_bbternak/components/coachmark_desc.dart';
import 'package:localstorage/localstorage.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TutorialCoachMark? tutorialCoachMark;
  List<TargetFocus> targets = [];
  GlobalKey ternakButtonKey = GlobalKey();
  LocalStorage localStorage = LocalStorage("storage");

  @override
  void initState() {
    super.initState();
    Future(() async {
      await localStorage.ready;
      if (await localStorage.getItem("showTutorial") == null) {
        _showTutorialCoachmark();
      } else {
        if (await localStorage.getItem("showTutorial")) {
          _showTutorialCoachmark();
        }
      }
    });
  }

  void _showTutorialCoachmark() {
    targets = [
      TargetFocus(
          identify: "ternak-button-key",
          keyTarget: ternakButtonKey,
          shape: ShapeLightFocus.RRect,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (context, controller) {
                return CoachmarkDesc(
                  text:
                      "Klik tombol ternak sesuai kebutuhan untuk menuju ke kalkulator",
                  onNext: () {
                    controller.next();
                  },
                  onSkip: () {
                    controller.skip();
                  },
                );
              },
            )
          ])
    ];
    tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      pulseEnable: false,
      colorShadow: Colors.green.withAlpha(64),
      onClickTarget: (target) {
        // print("${target.identify}");
      },
      hideSkip: true,
      onFinish: () {
        // print("Finish");
      },
    )..show(context: context);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the HomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Kalkulator BB Ternak"),
          actions: [
            IconButton(
              icon: const Icon(Icons.question_mark),
              tooltip: 'Membuka ulang tutorial',
              onPressed: () {
                _showTutorialCoachmark();
              },
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child: Padding(
              padding: EdgeInsets.all(20.0),
              child: ElevatedButton(
                key: ternakButtonKey,
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                )),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FractionallySizedBox(
                        widthFactor: 0.5,
                        child: Image.asset("assets/images/sapi.png",
                            fit: BoxFit.cover),
                      ),
                      Text(
                        "Kalkulator Sapi",
                        style: TextStyle(fontSize: 18),
                      )
                    ]),
                onPressed: () {
                  Navigator.pushNamed(context, '/sapi');
                },
              ),
            )),
            Expanded(
                child: Padding(
              padding: EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 20.0, bottom: 5.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                )),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FractionallySizedBox(
                        widthFactor: 0.5,
                        child: Image.asset("assets/images/kambing.png",
                            fit: BoxFit.cover),
                      ),
                      Text(
                        "Kalkulator Kambing",
                        style: TextStyle(fontSize: 18),
                      )
                    ]),
                onPressed: () {
                  Navigator.pushNamed(context, '/kambing');
                },
              ),
            )),
            Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                "© Dikembangkan oleh tim IT KKN Tim II Desa Troketon 2022/2023 Universitas Diponegoro",
                style: TextStyle(fontSize: 8),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ));
  }
}
