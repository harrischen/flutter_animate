import 'dart:math';
import 'package:flutter/material.dart';

class FlipOutY extends StatefulWidget {
  const FlipOutY({
    Key? key,
    this.child = const Text(
      'FlipOutY',
      style: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: Colors.lightBlue,
      ),
    ),
    this.curve = Curves.ease,
    this.duration = const Duration(milliseconds: 1000),
    this.delay = const Duration(milliseconds: 1000),
    this.completed,
  }) : super(key: key);

  final Widget child;
  final Curve curve;
  final Duration duration;
  final Duration delay;
  final VoidCallback? completed;

  @override
  _FlipOutYState createState() => _FlipOutYState();
}

class _FlipOutYState extends State<FlipOutY>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> rotate;
  late Animation<double> opacity;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(duration: widget.duration, vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed &&
            widget.completed is Function) {
          widget.completed!();
        }
      });

    rotate = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -20.0), weight: 30.0),
      TweenSequenceItem(tween: Tween(begin: -20.0, end: 90.0), weight: 70.0),
    ]).animate(CurvedAnimation(
      parent: controller,
      curve: widget.curve,
    ));

    opacity = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
      parent: controller,
      curve: Interval(0.3, 1.0, curve: widget.curve),
    ));

    Future.delayed(widget.delay, () {
      controller.forward();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlipOutYGrowTransition(
      child: widget.child,
      controller: controller,
      rotate: rotate,
      opacity: opacity,
    );
  }
}

class FlipOutYGrowTransition extends StatelessWidget {
  const FlipOutYGrowTransition({
    Key? key,
    required this.child,
    required this.controller,
    required this.rotate,
    required this.opacity,
  }) : super(key: key);

  final Widget child;
  final AnimationController controller;
  final Animation<double> rotate;
  final Animation<double> opacity;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform(
          alignment: FractionalOffset.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, -0.004)
            ..rotateY(rotate.value * pi / 180),
          child: Opacity(
            opacity: opacity.value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
