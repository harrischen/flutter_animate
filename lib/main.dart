import 'package:flutter/material.dart';
import 'package:myapp/demo/LayoutExample.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: LayoutExampleApp(),
    );
  }
}
