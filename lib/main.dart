import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';

import 'Joystick_Main.dart';
import 'imu.dart';
import 'speech.dart';
import 'videoStream.dart';
//import 'package:robot_control/speech.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Robot Control',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen());
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(
        Duration(seconds: 5),
            () =>
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) => MyHomePage(title: 'Button Control'))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: Colors.blueAccent),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    flex: 2,
                    child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: Colors.deepOrange,
                              radius: 50.0,
                              child: Icon(
                                const IconData(0xe900, fontFamily: 'AthenianOwl'),
                                color: Colors.white,
                                size: 50.0,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                            ),
                            Text(
                              "Owl-CTRL",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24.0),
                            )
                          ],
                        ))),
                Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20.0),
                        ),
                        Text("Loading...",
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0)),
                      ],
                    ))
              ],
            )
          ],
        ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  //Navigation Bar
  int _selectedIndex = 0;

  var _linear = 0.0;
  var _angular = 0.0;
  var _lastLinear = 0.0;
  var _lastAngular = 0.0;

  String _prefix = "http://10.16.104.100:8080/";

  final HttpClient _httpClient = HttpClient();

  MyHomePageState() {
    this._httpClient.connectionTimeout = Duration(seconds: 1);
  }


  void _error(String msg) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text('Connection Failed'),
            content: new Text(msg),
            actions: <Widget>[
              new MaterialButton(
                  onPressed: () {
                    //setState(() {});
                    Navigator.of(context).pop();
                  },
                  child: new Text('OK')),
            ],
          );
        });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (_selectedIndex) {
      case 0:
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TouchTest(this)),
        );
        _selectedIndex = 0;
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => IMU()),
        );
        _selectedIndex = 0;
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Speech()),
        );
        _selectedIndex = 0;
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VideoStream()),
        );
        _selectedIndex = 0;
        break;
      default:
        throw StateError("You clicked a Button that doesn't exist!");
    }
  }

  void _makeRequest(String uri) async {
    try {
      var request = await _httpClient.getUrl(Uri.parse(uri));
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
    catch (e) {
      print(e);
      _error(e.toString());
    }
  }

  void makeDualRequest(double linear, double angular) {
    var uri = "${_prefix}dual?linear=${linear.toStringAsPrecision(1)}&angular=${angular.toStringAsPrecision(1)}";
    _makeRequest(uri);
  }

  void _makeAbsoluteRequest(String type, double val) {
    var uri = "$_prefix$type?val=${val.toStringAsPrecision(1)}";
    _makeRequest(uri);
  }

  void _makeRelativeRequest(String direction) async {
    var uri = "$_prefix$direction";
    _makeRequest(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        //  backgroundColor: Colors.orangeAccent,
      ),
      body: AnimatedBackground(
        behaviour: RandomParticleBehaviour(),
        vsync: this,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              //  Container(
              // Add box decoration
              decoration: BoxDecoration(
                // Box decoration takes a gradient
                gradient: LinearGradient(
                  // Where the linear gradient begins and ends
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  // Add one stop for each color. Stops should increase from 0 to 1
                  stops: [0.1, 0.5, 0.7, 0.9],
                  colors: [
                    // Colors are easy thanks to Flutter's Colors class.
                    Colors.blue[800],
                    Colors.blueAccent[700],
                    Colors.lightBlue[600],
                    Colors.lightBlueAccent[400],
                  ],
                ),
              ),
              //    ),
              margin: const EdgeInsets.only(bottom: 40.0),
              child: Row(

                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        'Linear           Angular',
                        style: Theme
                            .of(context)
                            .textTheme
                            .display1,
                      ),
                      Text(
                        '$_linear                  ${_angular != 0.0 ? -1 * _angular : _angular}',
                        style: Theme
                            .of(context)
                            .textTheme
                            .display1,
                      ),
                    ],
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
                    activeColor: Colors.purpleAccent,
                    label: "Linear",
                    min: -1,
                    max: 1,
                    divisions: 20,
                    onChangeStart: (newVal) => _lastLinear = _linear,
                    onChanged: (newVal) {
                      if (newVal != _lastLinear) {
                        _makeAbsoluteRequest("linear", newVal);
                        _lastLinear = newVal;
                      }
                    },
                    value: _linear,
                  ),
                  Slider(
                    activeColor: Colors.purpleAccent,
                    label: "Angular",
                    min: -1,
                    max: 1,
                    divisions: 20,
                    onChangeStart: (newVal) => _lastAngular = _angular,
                    onChanged: (newVal) {
                      if (newVal != _lastAngular) {
                        _makeAbsoluteRequest("angular", newVal != 0.0 ? -1 * newVal : newVal);
                        _lastAngular = newVal;
                      }
                    },
                    value: -1 * _angular,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 28.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    splashColor: Colors.deepOrangeAccent,
                    onPressed: () => _makeRelativeRequest('forward'),
                    child: const Text('Forward'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    splashColor: Colors.deepOrangeAccent,
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
                    splashColor: Colors.deepOrangeAccent,
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
                  splashColor: Colors.deepOrangeAccent,
                  onPressed: () => _makeRelativeRequest('backward'),
                  child: const Text('Backward'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Image.asset('assets/Logo2.png', width: 108.0, height: 72.0),
                //width: 72.0, height: 48.0
                // myLogoWidget()
              ],
            ),
          ],

        ),

      ),

      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the Drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Device Management',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40)),
              decoration: BoxDecoration(
                color: Colors.lightBlue,
              ),
            ),
            ListTile(
              title: Text('Magni',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              onTap: () {
                _prefix = "http://10.16.104.100:8080/";
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Turtlebot3',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              onTap: () {
                _prefix = "http://turtle1.athenian.org:8080/";
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Gazebo',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              onTap: () {
                _prefix = "http://10.16.103.133:8080/";
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Posotronics Robot',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              onTap: () {
                _prefix = "http://192.168.1.182:8080/";
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(

        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[

          BottomNavigationBarItem(
              icon: Icon(Icons.home), title: Text('Control')),
          BottomNavigationBarItem(icon: Icon(Icons.videogame_asset), title: Text('Joystick')),
          BottomNavigationBarItem(icon: Icon(Icons.launch), title: Text('IMU')),
          BottomNavigationBarItem(icon: Icon(Icons.phone), title: Text('Speech')),
          BottomNavigationBarItem(icon: Icon(Icons.voice_chat), title: Text('Video')),
        ],

        currentIndex: _selectedIndex,
        fixedColor: Colors.deepOrange,
        onTap: _onItemTapped,
      ),

      backgroundColor: Colors.blueGrey,

    );
  }
}
