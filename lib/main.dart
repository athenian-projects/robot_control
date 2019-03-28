import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Robot Control System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Robot Control System'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String _prefix = "http://10.16.104.100:8080/";

  //final String _prefix = "http://ros.local:8080/";

  var _linear = 0.0;
  var _angular = 0.0;

  void _makeRestRequest(String direction) async {
    var request = await HttpClient().getUrl(Uri.parse(_prefix + direction));
    var response = await request.close();
    await for (var contents in response.transform(Utf8Decoder())) {
      //print(contents);
      if (contents
          .trim()
          .length > 0) {
        var json = jsonDecode(contents);
        //print(json);
        setState(() {
          _linear = json['linear'];
          _angular = json['angular'];
        });
      }
    }
  }

  void _forward() {
    _makeRestRequest('forward');
    setState(() {
      if (_linear == 1.0) {
        _linear = 1.0;
      } else {
        _linear = _linear + 0.10;
      }
    });
  }

  void _backward() {
    _makeRestRequest('backward');
    setState(() {
      if (_linear == 0.0) {
        _linear = 0.0;
      } else {
        _linear = _linear - 0.10;
      }
    });
  }

  void _left() {
    _makeRestRequest('left');
    setState(() {
      if (_angular == 1.0) {
        _angular = 1.0;
      } else {
        _angular = _angular + 0.1;
      }
    });

  }

  void _right() {
    _makeRestRequest('right');
    setState(() {
      if (_angular == 0.0) {
        _angular = 0.0;
      } else {
        _angular = _angular + 0.1;
      }
    });
  }

  void _stop() {
    _makeRestRequest('stop');
    setState(() {
      _angular = 0.0;
      _linear = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new CircularPercentIndicator(
              radius: 150.0,
              lineWidth: 20.0,
              percent: (_linear + 0.5),
              animation: true,
              animateFromLastPercent: true,
              animationDuration: 300,
              center: new Text('Power: ${(_linear) * 10 }'),
              progressColor: Colors.orange,
            ),
            Text(
              'Linear',
              style: Theme
                  .of(context)
                  .textTheme
                  .display1,
            ),
            Text(
              'Backward                                                    Forward',
              style: Theme
                  .of(context)
                  .textTheme
                  .display1,
              textScaleFactor: 0.4,
            ),
            new LinearPercentIndicator(
              width: 240.0,
              alignment: MainAxisAlignment.center,
              animateFromLastPercent: true,
              animation: true,
              animationDuration: 300,
              lineHeight: 20.0,
              percent: _linear + 0.5,
              backgroundColor: Colors.grey,
              progressColor: Colors.teal,

            ),
            Text(
              'Angular',
              style: Theme
                  .of(context)
                  .textTheme
                  .display1,
            ),
            Text(
              'Right                                                              Left',
              style: Theme
                  .of(context)
                  .textTheme
                  .display1,
              textScaleFactor: 0.4,
            ),
            new LinearPercentIndicator(
              width: 240.0,
              alignment: MainAxisAlignment.center,
              animateFromLastPercent: true,
              animation: true,
              animationDuration: 300,
              lineHeight: 20.0,
              percent: _angular + 0.5,
              backgroundColor: Colors.grey,
              progressColor: Colors.purple,

            ),


            Container(
              margin: const EdgeInsets.only(bottom: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
//                  Text(
//                    'Linear: $_linear',
//                    style: Theme
//                        .of(context)
//                        .textTheme
//                        .display1,
//                  ),
//
//
//
//                  Text(
//                    '  Angular: $_angular',
//                    style: Theme
//                        .of(context)
//                        .textTheme
//                        .display1,
//                  ),
                ],

              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: _forward,
                  child: const Text('Forward'),
                  color: Colors.yellow,
                  elevation: 6.0,
                  highlightColor: Colors.teal,
                  highlightElevation: 1.0,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0)),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    onPressed: _left,
                    child: const Text('Left'),
                    color: Colors.blue,
                    elevation: 4.0,
                    highlightColor: Colors.teal,
                    highlightElevation: 1.0,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0)),
                  ),

                  Container(
                    margin: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: RaisedButton(
                      onPressed: _stop,
                      child: const Text('Stop'),
                      color: Colors.grey,
                      elevation: 8.0,
                      highlightColor: Colors.teal,
                      highlightElevation: 1.0,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0)),
                    ),
                  ),
                  RaisedButton(
                    onPressed: _right,
                    child: const Text('Right'),
                    color: Colors.red,
                    elevation: 4.0,
                    highlightColor: Colors.teal,
                    highlightElevation: 1.0,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0)),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: _backward,
                  child: const Text('Backward'),
                  color: Colors.green,
                  elevation: 6.0,
                  highlightColor: Colors.teal,
                  highlightElevation: 1.0,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
