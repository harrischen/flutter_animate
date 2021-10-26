import 'package:flutter/material.dart';
import 'package:motion/motion.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowMaterialGrid: true,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Animate Demo'),
        ),
        body: Center(
          child: ZoomInDown(
            completed: () {
              print('=========completed=========');
            },
          ),
        ),
      ),
    );
  }
}
