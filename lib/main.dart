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


void makeRestRequest(String direction) {
  final String _prefix = "http://10.16.104.100:8080/";
  HttpClient().getUrl(Uri.parse(_prefix + direction)).then((request) => request.close());
}


class _MyHomePageState extends State<MyHomePage> {

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final _widgetOptions = [
    Text('Index 0: Control'),
    Text('Index 1: Video Feed'),
    Text('Index 2: Settings'),
  ];

  void _forward() {
    makeRestRequest('forward');
  }

  void _backward() {
    makeRestRequest('backward');
  }

  void _left() {
    makeRestRequest('left');
  }

  void _right() {
    makeRestRequest('right');
  }

  void _stop() {
    makeRestRequest('stop');
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
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    onPressed: _left,
                    child: const Text('Left'),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: RaisedButton(
                      onPressed: _stop,
                      child: const Text('Stop'),
                    ),
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
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home), title: Text('Control')),
          BottomNavigationBarItem(
              icon: Icon(Icons.video_label), title: Text('Video Feed')),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), title: Text('Settings')),
        ],
        currentIndex: _selectedIndex,
        fixedColor: Colors.deepOrange,
        onTap: _onItemTapped,
      ),
    );
  }
}

