import 'package:flutter/material.dart';

import 'joystick.dart';
import 'main.dart';

class TouchTest extends StatelessWidget {

  final MyHomePageState pageState;

  TouchTest(this.pageState);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: const Text('Joystick'),
      ),
      body: new TestForm(this.pageState),
    );
  }
}
