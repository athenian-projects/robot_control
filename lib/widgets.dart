import 'package:flutter/material.dart';

//class Texty extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Container(child: new Text('This works'));
//  }
//}

class myLogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var imagesImage = new AssetImage('assets/Logo2.png');
    var image = new Image(image: imagesImage,
        width: 108.0,
        height: 72.0); // width: 72.0, height: 48.0)
    return Container(child: image); //
  }
}

class myFancy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned.fill(
          child: Opacity(
              opacity: 0.4,
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  // begin: Alignment.bottomRight ,
                  Colors.blue,
                  Colors.green
                ])),
                //    child: FlutterLogo()
              ))),
    ]);
  }
}

class BackGradient extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Column(children: <Widget>[
      new GradientAppBar("Custom Gradient App Bar"), new Container()
    ],);
  }
}


class GradientAppBar extends StatelessWidget {

  final String title;
  final double barHeight = 50.0;

  GradientAppBar(this.title);

  @override
  Widget build(BuildContext context) {
    final double statusbarHeight = MediaQuery
        .of(context)
        .padding
        .top;

    return new Container(
      padding: new EdgeInsets.only(top: statusbarHeight),
      height: statusbarHeight + barHeight,
      child: new Center(
        child: new Text(
          title,
          style: new TextStyle(
              fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
            colors: [Colors.red, Colors.blue],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(0.5, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp
        ),
      ),
    );
  }
}
