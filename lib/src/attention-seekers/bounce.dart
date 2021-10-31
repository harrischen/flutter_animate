import 'package:flutter/material.dart';

class Bounce extends StatefulWidget {
  const Bounce({
    Key? key,
    this.child = const Text(
      'Bounce',
      style: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: Colors.lightBlue,
      ),
    ),
    this.duration = const Duration(milliseconds: 1000),
    this.delay = const Duration(milliseconds: 0),
    this.completed,
  }) : super(key: key);

  final Widget child;
  final Duration duration;
  final Duration delay;
  final VoidCallback? completed;

  @override
  _BounceState createState() => _BounceState();
}

class _BounceState extends State<Bounce> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> translateY;
  late Animation<double> scaleY;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: widget.duration)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed &&
            widget.completed is Function) {
          widget.completed!();
        }
      });

    translateY = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 0.0).chain(
          CurveTween(curve: Curves.ease),
        ),
        weight: 20.0,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: -30.0).chain(
          CurveTween(curve: Curves.easeOut),
        ),
        weight: 20.0,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -30.0, end: -30.0).chain(
          CurveTween(curve: Curves.easeOut),
        ),
        weight: 3.0,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -30.0, end: 0.0).chain(
          CurveTween(curve: Cubic(0.215, 0.61, 0.355, 1)),
        ),
        weight: 10.0,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: -15.0).chain(
          CurveTween(curve: Cubic(0.755, 0.05, 0.855, 0.06)),
        ),
        weight: 17.0,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -15.0, end: 0.0).chain(
          CurveTween(curve: Cubic(0.215, 0.61, 0.355, 1)),
        ),
        weight: 10.0,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: -4.0),
        weight: 10.0,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -4.0, end: 0.0).chain(
          CurveTween(curve: Cubic(0.215, 0.61, 0.355, 1)),
        ),
        weight: 10.0,
      ),
    ]).animate(controller);

    scaleY = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.0).chain(
          CurveTween(curve: Cubic(0.215, 0.61, 0.355, 1)),
        ),
        weight: 20.0,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.1).chain(
          CurveTween(curve: Cubic(0.755, 0.05, 0.855, 0.06)),
        ),
        weight: 20.0,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.1, end: 1.1).chain(
          CurveTween(curve: Cubic(0.755, 0.05, 0.855, 0.06)),
        ),
        weight: 3.0,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.1, end: 1.0).chain(
          CurveTween(curve: Cubic(0.215, 0.61, 0.355, 1)),
        ),
        weight: 10.0,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.05).chain(
          CurveTween(curve: Cubic(0.755, 0.05, 0.855, 0.06)),
        ),
        weight: 17.0,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.05, end: 0.95).chain(
          CurveTween(curve: Cubic(0.215, 0.61, 0.355, 1)),
        ),
        weight: 10.0,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.95, end: 1.02),
        weight: 10.0,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.02, end: 1.0).chain(
          CurveTween(curve: Cubic(0.215, 0.61, 0.355, 1)),
        ),
        weight: 10.0,
      ),
    ]).animate(controller);

    Future.delayed(widget.delay, () {
      controller.forward();
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _GrowTransition(
      child: widget.child,
      controller: controller,
      translateY: translateY,
      scaleY: scaleY,
    );
  }
}

class _GrowTransition extends StatelessWidget {
  const _GrowTransition({
    Key? key,
    required this.child,
    required this.controller,
    required this.translateY,
    required this.scaleY,
  }) : super(key: key);

  final Widget child;
  final AnimationController controller;
  final Animation<double> translateY;
  final Animation<double> scaleY;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final _offset = Matrix4.translationValues(0.0, translateY.value, 0.0);
        final _scale = Matrix4.diagonal3Values(1.0, scaleY.value, 1.0);
        return Transform(
          alignment: Alignment.bottomCenter,
          transform: _offset..add(_scale),
          child: child,
        );
      },
      child: child,
    );
  }
}
