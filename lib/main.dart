import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:robot_control/widgets.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Center(child: myFancy());
    return MaterialApp(

      title: 'Robot Control',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Robot Control'),
    );
  }
} //Center(child: MyFancy());

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
  }

  void _backward() {
    _makeRestRequest('backward');
  }

  void _left() {
    _makeRestRequest('left');
  }

  void _right() {
    _makeRestRequest('right');
  }

  void _stop() {
    _makeRestRequest('stop');
  }

  @override
  Widget build(BuildContext context) {
    // Center(child: myFancy());
    return Scaffold(

      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.orangeAccent,
      ),
//       body: Center(
//        child: myLogoWidget(),
//      )

      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    stops: [0.1, 0.5, 0.7, 0.9],
                    colors: [

                      Colors.deepPurple[800],
                      Colors.purple[700],
                      Colors.blue[600],
                      Colors.indigo[400],
                    ],
                  )
              ),

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

//              decoration: BoxDecoration(
//                  gradient: LinearGradient(
//                    begin: Alignment.topRight,
//                    end: Alignment.bottomLeft,
//                    stops: [0.1, 0.5, 0.7, 0.9],
//                    colors: [
//                      // Colors are easy thanks to Flutter's Colors class.
//                      Colors.red[800],
//                      Colors.indigo[700],
//                      Colors.blue[600],
//                      Colors.blue[400],
//                    ],
//                  )
//              ),

            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/Logo2.png', width: 144.0, height: 96.0),
                myLogoWidget()
              ],
            ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/Logo1.png', width: 144.0, height: 96.0),

              ],
            ),

          ],

        ),
      ),
      backgroundColor: Colors.white70,


    );
  }
}
