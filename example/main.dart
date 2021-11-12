import 'package:flutter/material.dart';
import 'package:motion/motion.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowMaterialGrid: false,
      themeMode: ThemeMode.system,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Animate Demo'),
        ),
        body: Center(
          child: ParentWidget(),
        ),
      ),
    );
  }
}

class ParentWidget extends StatefulWidget {
  const ParentWidget({Key? key}) : super(key: key);

  @override
  _ParentWidgetState createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(seconds: 2), vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Hinge(
          controller: _controller,
        ),
        FloatingActionButton(
          child: Text('start'),
          onPressed: () {
            if (_controller.isAnimating) {
              _controller.stop(canceled: false);
            } else {
              _controller.forward();
            }

            if (_controller.isCompleted) {
              _controller.reset();
              _controller.forward();
            }
          },
        )
      ],
    );
  }
}
