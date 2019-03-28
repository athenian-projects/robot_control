import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Robot Control',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Robot Control'),
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
  //final String _prefix = "http://10.16.104.100:8080/";

  final String _prefix = "http://ros.local:8080/";

  var _linear = 0.0;
  var _angular = 0.0;

  void _makeAbsoluteRequest(String type, double val) async {
    var request = await HttpClient().getUrl(Uri.parse(_prefix + type + "/" + val.toString()));
    var response = await request.close();
    await for (var contents in response.transform(Utf8Decoder())) {
      try {
        var json = jsonDecode(contents);
        print(json);
        setState(() {
          _linear = json['linear'];
          _angular = json['angular'];
        });
      }
      on FormatException {
        // Ignore
      }
    }
  }

  void _makeRelativeRequest(String direction) async {
    var request = await HttpClient().getUrl(Uri.parse(_prefix + direction));
    var response = await request.close();
    await for (var contents in response.transform(Utf8Decoder())) {
      try {
        var json = jsonDecode(contents);
        setState(() {
          _linear = json['linear'];
          _angular = json['angular'];
        });
      }
      on FormatException {
        // Ignore
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Linear: ',
                    style: Theme
                        .of(context)
                        .textTheme
                        .display1,
                  ),
                  Text(
                    '$_linear',
                    style: Theme
                        .of(context)
                        .textTheme
                        .display1,
                  ),
                  Text(
                    '  Angular: ',
                    style: Theme
                        .of(context)
                        .textTheme
                        .display1,
                  ),
                  Text(
                    '$_angular',
                    style: Theme
                        .of(context)
                        .textTheme
                        .display1,
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Slider(
                    activeColor: Colors.indigoAccent,
                    label: "Linear",
                    min: -0.5,
                    max: 0.5,
                    divisions: 10,
                    onChanged: (newVal) {
                      if (newVal != _linear) _makeAbsoluteRequest("linear", newVal);
                    },
                    value: _linear,
                  ),
                  Slider(
                    activeColor: Colors.indigoAccent,
                    label: "Angular",
                    min: -0.5,
                    max: 0.5,
                    divisions: 10,
                    onChanged: (newVal) {
                      if (newVal != _angular) _makeAbsoluteRequest("angular", newVal);
                    },
                    value: _angular,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: () => _makeRelativeRequest('forward'),
                  child: const Text('Forward'),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () => _makeRelativeRequest('left'),
                    child: const Text('Left'),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: RaisedButton(
                      onPressed: () => _makeRelativeRequest('stop'),
                      child: const Text('Stop'),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () => _makeRelativeRequest('right'),
                    child: const Text('Right'),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: () => _makeRelativeRequest('backward'),
                  child: const Text('Backward'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
