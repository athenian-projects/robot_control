import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'main.dart';

/**
 * Steteful widget
 */
class TouchPad extends StatefulWidget {

  final ValueChanged<Offset> onChanged;
  final MyHomePageState pageState;

  const TouchPad(this.pageState, {Key key, this.onChanged}) : super(key: key);

  @override
  TouchPadState createState() => new TouchPadState(this.pageState);
}

/**
 * Draws a circle at supplied position.
 *
 */
class TouchPadState extends State<TouchPad> {
  double xPos = 0.0;
  double yPos = 0.0;

  final MyHomePageState pageState;

  TouchPadState(this.pageState);
  void onChanged(Offset offset) {
    final RenderBox referenceBox = context.findRenderObject();
    Offset position = referenceBox.globalToLocal(offset);
    if (widget.onChanged != null)
      widget.onChanged(position);

    double width = referenceBox.size.width;
    double height = referenceBox.size.height;

    double x = position.dx;
    double y = position.dy;

    var xFinal = (x/(width/9)).round();
    var yFinal = (y/(height/9)).round();

    if (xFinal > 9) {
      xFinal = 10;
    } else {
    }

    if (xFinal < 1) {
      xFinal = 0;
    } else {
    }

    if (yFinal > 9) {
      yFinal = 10;
    } else  {
    }
    if (yFinal < 1) {
      yFinal = 0;
    } else  {
    }

    print('x:$xFinal:$width, y:$yFinal:$height');
    this.pageState.makeDualRequest(xFinal / 10.0, yFinal / 10.0);

    // Update state.
    setState(() {
      xPos = x - (width / 2);
      yPos = y - (height / 2);
    });
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    if (event is PointerDownEvent ) {
      //
    }
  }

  void _handlePanStart(DragStartDetails details) {
    onChanged(details.globalPosition);
  }

  void _handlePanEnd(DragEndDetails details) {
    print('end');
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    onChanged(details.globalPosition);
  }

  @override
  Widget build(BuildContext context) {
    return new ConstrainedBox(
      constraints: new BoxConstraints.expand(),
      child: new GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanStart:_handlePanStart,
        onPanEnd: _handlePanEnd,
        onPanUpdate: _handlePanUpdate,
        child: new CustomPaint(
          painter: new TouchPadGridPainter(),
          child: new Center(
            child:new CustomPaint(
              painter: new TouchPadPainter(xPos, yPos),
            ),
          ),
        ),
      ),
    );
  }
}

/**
 * Painter.
 *
 */
class TouchPadPainter extends CustomPainter {
  static const markerRadius = 10.0;

  Offset position;

  TouchPadPainter(final double x, final double y) {
    this.position = new Offset(x, y);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = new Paint()
      ..color = Colors.blue[400]
      ..style = PaintingStyle.fill;


    canvas.drawCircle(new Offset(position.dx, position.dy), markerRadius, paint);
  }


  @override
  bool shouldRepaint(TouchPadPainter old) => position.dx != old.position.dx && position.dy !=old.position.dy;
}

/**
 * Grid Painter.
 *
 */
class TouchPadGridPainter extends CustomPainter {

  Offset position;

  TouchPadGridPainter() {
    this.position = new Offset(0.0, 0.0);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = new Paint()
      ..color = Colors.blue[400]
      ..style = PaintingStyle.fill;

    Offset centreLeft = size.centerLeft(position);
    Offset centreRight = size.centerRight(position);

    canvas.drawLine(centreLeft, centreRight, paint);

    Offset topCentre = size.topCenter(position);
    Offset bottomCentre = size.bottomCenter(position);

    canvas.drawLine(topCentre, bottomCentre, paint);
  }


  @override
  bool shouldRepaint(TouchPadGridPainter old) => position.dx != old.position.dx && position.dy !=old.position.dy;
}