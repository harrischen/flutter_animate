import 'package:flutter/material.dart';

class AnimatedLogo extends AnimatedWidget {
  const AnimatedLogo({
    Key? key,
    required Animation<double> animation,
  }) : super(key: key, listenable: animation);

  static final _opacityTween = Tween<double>(begin: 0.1, end: 1);
  static final _sizeTween = Tween<double>(begin: 0, end: 300);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Center(
      child: Opacity(
        opacity: _opacityTween.evaluate(animation),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          width: _sizeTween.evaluate(animation),
          height: _sizeTween.evaluate(animation),
          child: const FlutterLogo(),
        ),
      ),
    );
  }
}

/// excellent solution
/// step 1: Render the logo
class LogoWidget extends StatelessWidget {
  const LogoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const FlutterLogo(),
    );
  }
}

/// excelent solution
/// step 2: Define the Animation object
class GrowTransition extends StatelessWidget {
  const GrowTransition({
    Key? key,
    required this.child,
    required this.animation,
  }) : super(key: key);

  final Widget child;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return SizedBox(
            width: animation.value,
            height: animation.value,
            child: child,
          );
        },
        child: child,
      ),
    );
  }
}

/// excelent solution
/// step 3: Render the transition
class LogoApp extends StatefulWidget {
  const LogoApp({Key? key}) : super(key: key);

  @override
  _LogoAppState createState() => _LogoAppState();
}

class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    final duration = const Duration(seconds: 2);
    controller = AnimationController(duration: duration, vsync: this);
    // animation = Tween<double>(begin: 0, end: 300).animate(controller)
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn)
      // ..addStatusListener((status) {
      //   if (status == AnimationStatus.completed) {
      //     controller.reverse();
      //   } else if (status == AnimationStatus.dismissed) {
      //     controller.forward();
      //   }
      // });
      ..addStatusListener((status) => print('$status'));
    // ..addListener(() {
    //   setState(() {});
    // });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedLogo(animation: animation);
    // return GrowTransition(
    //   child: const LogoWidget(),
    //   animation: animation,
    // );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
