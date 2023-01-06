import 'dart:async';

import 'package:flutter/material.dart';

class CircularProgressIndicatorApp extends StatefulWidget {
  const CircularProgressIndicatorApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return CircularProgressIndicatorAppState();
  }
}

class CircularProgressIndicatorAppState
    extends State<CircularProgressIndicatorApp> {
  late double _progressValue;
  int counter = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _progressValue = 0.0;
    _updateProgress();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(
                strokeWidth: 10,
                backgroundColor: Colors.yellow,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                value: _progressValue,
              ),
              Text('${(_progressValue * 100).round()}%'),
            ],
          )),
    );
  }

  // this function updates the progress value
  void _updateProgress() {
    const oneSec = Duration(milliseconds: 300);
    Timer.periodic(oneSec, (Timer t) {
      setState(() {
        _progressValue += 0.2;
        // we "finish" downloading here
        if (_progressValue.toStringAsFixed(1) == '1.0') {
          t.cancel();
          return;
        }
      });
    });
  }
}
