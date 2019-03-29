import 'package:flutter/material.dart';

import 'joystick.dart';

class TouchTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: const Text('Joystick'),
      ),
      body: new TestForm(),
    );
  }
}
