import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/services.dart';
import 'package:sufler/textchangepage.dart';

class StartAndPauseUse extends Intent {}

void main() {
  runApp(const MyApp());

  doWhenWindowReady(() {
    appWindow.minSize = const Size(600, 450);
    appWindow.size = const Size(1280, 720);
    appWindow.title = "Atom Prompter";
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          scaffoldBackgroundColor: const Color.fromARGB(255, 30, 30, 30)),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ScrollController _scrollController = ScrollController();
  String _maintext =
      "Добро пожаловать в приложение телесуфлера! Чтобы ввести свой собственный текст нажмите на первую кнопку на нижней панеле инструментов";
  double textsize = 120;
  Timer? timer;
  late double timeToReachEnd = 60;
  double speedmultiplayer = 10;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
      body: SafeArea(
          child: Column(children: [
        Expanded(
            child: ListView(controller: _scrollController, children: [
          Container(
            color: const Color.fromARGB(255, 15, 15, 15),
            alignment: Alignment.center,
            height: 200,
            width: double.infinity,
            child: Text(
              "Начало",
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: textsize,
                  color: const Color.fromARGB(255, 238, 238, 238)),
              textAlign: TextAlign.center,
            ),
          ),
          Text(_maintext,
              style: TextStyle(
                  fontSize: textsize,
                  color: const Color.fromARGB(255, 238, 238, 238))),
          Container(
            color: const Color.fromARGB(255, 15, 15, 15),
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(top: 200),
            height: appWindow.size.height - 85,
            width: double.infinity,
            child: Text(
              "Конец",
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: textsize,
                  color: const Color.fromARGB(255, 238, 238, 238)),
            ),
          ),
        ]))
      ])),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(255, 23, 23, 23),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                onPressed: () async {
                  stopTimer();
                  _scrollController.position.hold(() {});
                  final newmaintext = await Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                    return TextFieldPage(oldmaintext: _maintext);
                  }));
                  setState(() {
                    if (newmaintext != null) {
                      _maintext = newmaintext;
                    }
                  });
                },
                icon: const Icon(Icons.border_color, size: 25),
                tooltip: "Текст",
                color: const Color.fromARGB(255, 204, 204, 204)),
            Shortcuts(
                shortcuts: {
                  LogicalKeySet(LogicalKeyboardKey.space): StartAndPauseUse(),
                },
                child: Actions(actions: {
                  StartAndPauseUse: CallbackAction<StartAndPauseUse>(
                    onInvoke: (intent) =>
                        (timer == null ? false : timer!.isActive)
                            ? stopButtonPress()
                            : startButtonPress(),
                  )
                }, child: startAndPause())),
            IconButton(
                onPressed: () {
                  _scrollController
                      .jumpTo(_scrollController.position.minScrollExtent);
                  stopTimer();
                },
                icon: const Icon(Icons.restore, size: 25),
                tooltip: "Заново",
                color: const Color.fromARGB(255, 204, 204, 204)),
            const SizedBox(
              height: 50,
              width: 50,
            ),
            Row(children: [
              Text(
                speedmultiplayer.round().toString(),
                style: const TextStyle(
                  color: Color.fromARGB(255, 204, 204, 204),
                  fontSize: 20,
                ),
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Slider(
                        value: speedmultiplayer,
                        min: 1,
                        max: 40,
                        divisions: 39,
                        onChanged: (value) => setState(() {
                              speedmultiplayer = value;
                              timeToReachEnd =
                                  (_scrollController.position.maxScrollExtent -
                                          _scrollController.position.pixels) /
                                      (7 * speedmultiplayer);
                              (timer == null ? false : timer!.isActive)
                                  ? animateToMaxMin(
                                      _scrollController
                                          .position.maxScrollExtent,
                                      timeToReachEnd.round() == 0
                                          ? 1
                                          : timeToReachEnd.round(),
                                      _scrollController)
                                  : null;
                            })),
                  ]),
              const Icon(Icons.speed,
                  size: 25, color: Color.fromARGB(255, 204, 204, 204)),
            ]),
            Row(
              children: [
                Text(
                  textsize.round().toString(),
                  style: const TextStyle(
                    color: Color.fromARGB(255, 204, 204, 204),
                    fontSize: 20,
                  ),
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Slider(
                          value: textsize,
                          min: 14,
                          max: 180,
                          divisions: 166,
                          onChanged: (value) => setState(() {
                                textsize = value;
                                timeToReachEnd = (_scrollController
                                            .position.maxScrollExtent -
                                        _scrollController.position.pixels) /
                                    (7 * speedmultiplayer);
                                (timer == null ? false : timer!.isActive)
                                    ? animateToMaxMin(
                                        _scrollController
                                            .position.maxScrollExtent,
                                        timeToReachEnd.round() == 0
                                            ? 1
                                            : timeToReachEnd.round(),
                                        _scrollController)
                                    : null;
                              })),
                    ]),
                const Icon(Icons.text_format,
                    size: 25, color: Color.fromARGB(255, 204, 204, 204))
              ],
            ),
            const SizedBox(
              height: 50,
              width: 50,
            ),
            Text(timerText(),
                style: const TextStyle(
                    color: Color.fromARGB(255, 238, 238, 238), fontSize: 30))
          ],
        ),
      ),
    );
  }

  animateToMaxMin(
      double direction, int seconds, ScrollController scrollController) {
    scrollController.animateTo(direction,
        duration: Duration(seconds: seconds), curve: Curves.linear);
  }

  startTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 10), (_) {
      if (timeToReachEnd.round() > 0) {
        setState(() => timeToReachEnd = timeToReachEnd - 0.01);
      } else {
        stopTimer();
      }
    });
  }

  stopTimer() {
    setState(() {
      timer?.cancel();
    });
  }

  Widget startAndPause() {
    final isRunning = timer == null ? false : timer!.isActive;
    return isRunning
        ? IconButton(
            onPressed: () {
              stopButtonPress();
            },
            icon: const Icon(Icons.pause),
            tooltip: ("Пауза"),
            color: const Color.fromARGB(255, 204, 204, 204))
        : IconButton(
            onPressed: () {
              startButtonPress();
            },
            icon: const Icon(Icons.play_arrow),
            tooltip: ("Старт"),
            color: const Color.fromARGB(255, 204, 204, 204));
  }

  String timerText() {
    var tTextMinutes = timeToReachEnd.round() ~/ 60;
    var tTextSeconds = timeToReachEnd.round() % 60 >= 10
        ? timeToReachEnd.round() % 60
        : '0${timeToReachEnd.round() % 60}';
    return '$tTextMinutes:$tTextSeconds';
  }

  startButtonPress() {
    timeToReachEnd = (_scrollController.position.maxScrollExtent -
            _scrollController.position.pixels) /
        (7 * speedmultiplayer);
    animateToMaxMin(
        _scrollController.position.maxScrollExtent,
        timeToReachEnd.round() == 0 ? 1 : timeToReachEnd.round(),
        _scrollController);
    startTimer();
  }

  stopButtonPress() {
    stopTimer();
    _scrollController.position.hold(() {});
  }
}
