import 'package:flutter/material.dart';
import 'package:motion/src/zooming-entrances/zoom-in.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Animate Demo'),
        ),
        body: ZoomIn(),
      ),
    );
  }
}
