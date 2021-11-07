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
      themeMode: ThemeMode.system,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Animate Demo'),
        ),
        body: Center(
          child: JackInTheBox(
            completed: () {
              print('=========completed=========');
            },
          ),
        ),
      ),
    );
  }
}
