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
    var imagesImage = new AssetImage('Imags/Logo1.png');
    var image = new Image(image: imagesImage); // width: 72.0, height: 48.0)
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
