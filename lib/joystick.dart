import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'touchpad.dart';

class TestForm extends StatefulWidget {
  static const String routeName = '/material/slider';

  @override
  _TestForm createState() => new _TestForm();
}

class _TestForm extends State<TestForm> {

  double _valueSlider1 = 0.0;
  double _valueSlider2 = 0.0;

  /**
   * Touch change handler
   */
  void onChanged(Offset offset) {
    double x = offset.dx;
    double y = offset.dy;

  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        padding: new EdgeInsets.only(
            left: 20.0, right: 20.0, top: 30.0, bottom: 80.0),
        child: new Column(
            children: <Widget>[
              new Expanded(

                flex: 1,
                child: new Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      gauge1()
                    ]
                ),
              ),
              new Expanded(
                flex: 1,
                child: new Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      gauge2()
                    ]
                ),
              ),
              new Expanded(
                  flex: 2,
                  child: touchControl()
              ),
            ]
        )
    );
  }

  Widget touchControl() {
    return new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Text ("hello"
          ),
          new TouchPad(onChanged: onChanged),
        ]
    );

  }

  Widget gauge1() {
    return new Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new CircularPercentIndicator(
            radius: 150.0,
            lineWidth: 20.0,
            percent: (0 + 0.5),
            animation: true,
            animateFromLastPercent: true,
            animationDuration: 300,
            center: new Text('Power: ${(1) * 10 }'),
            progressColor: Colors.orangeAccent,
          ),
          new Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
          ),
          new CircularPercentIndicator(
            radius: 150.0,
            lineWidth: 20.0,
            percent: (0 + 0.5),
            animation: true,
            animateFromLastPercent: true,
            animationDuration: 300,
            center: new Text('Power: ${(1) * 10 }'),
            progressColor: Colors.redAccent,
          ),
        ]
    );
  }

  Widget gauge2() {
    return new Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new LinearPercentIndicator(
            width: 300.0,
            lineHeight: 20,
            percent: (0.5),
            animation: true,
            animateFromLastPercent: true,
            animationDuration: 300,
            center: Text(
              "50.0%",
              style: new TextStyle(color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            linearStrokeCap: LinearStrokeCap.butt,
            backgroundColor: Colors.indigo,
            progressColor: Colors.blueAccent,
          ),
        ]
    );
  }

}