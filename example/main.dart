import 'package:flutter/material.dart';
import 'components.dart';
import 'config.dart';

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
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(title: Text('Animate Demo')),
          body: Layout(),
        ),
      ),
    );
  }
}

class Layout extends StatefulWidget {
  const Layout({Key? key}) : super(key: key);

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> with TickerProviderStateMixin {
  late AnimationController _controller;
  String animateName = '';

  @override
  void initState() {
    super.initState();
    final _duration = const Duration(milliseconds: 1000);
    _controller = AnimationController(duration: _duration, vsync: this);
    animateName = '';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Center(
            child: GetMotionWidget(
              title: animateName,
              controller: _controller,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Menus(
            callback: (title) {
              setState(() => animateName = title);

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
          ),
        ),
      ],
    );
  }
}
