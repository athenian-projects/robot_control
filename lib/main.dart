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
  final String _prefix = "http://localhost:8080/";

  void _forward() async {
    var request = await HttpClient().getUrl(Uri.parse(_prefix + 'forward'));
    await request.close();
  }

  void _backward() async {
    var request = await HttpClient().getUrl(Uri.parse(_prefix + 'backward'));
    await request.close();
  }

  void _left() async {
    var request = await HttpClient().getUrl(Uri.parse(_prefix + 'left'));
    await request.close();
  }

  void _right() async {
    var request = await HttpClient().getUrl(Uri.parse(_prefix + 'right'));
    await request.close();
  }

  void _stop() async {
    var request = await HttpClient().getUrl(Uri.parse(_prefix + 'stop'));
    await request.close();
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: _forward,
                  child: const Text('Forward'),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    onPressed: _left,
                    child: const Text('Left'),
                  ),
                  RaisedButton(
                    onPressed: _stop,
                    child: const Text('Stop'),
                  ),
                  RaisedButton(
                    onPressed: _right,
                    child: const Text('Right'),
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
