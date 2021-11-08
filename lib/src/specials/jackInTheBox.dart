import 'dart:math';
import 'package:flutter/material.dart';

class JackInTheBox extends StatefulWidget {
  const JackInTheBox({
    Key? key,
    this.child = const Text(
      'JackInTheBox',
      style: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: Colors.lightBlue,
      ),
    ),
    this.duration = const Duration(milliseconds: 1000),
    this.delay = const Duration(milliseconds: 1000),
    this.curve = Curves.easeInOut,
    this.completed,
  }) : super(key: key);

  final Widget child;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final VoidCallback? completed;

  @override
  _JackInTheBoxState createState() => _JackInTheBoxState();
}

class _JackInTheBoxState extends State<JackInTheBox> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;
  late Animation<double> rotate;
  late Animation<double> opacity;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: widget.duration)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed && widget.completed is Function) {
          widget.completed!();
        }
      });

    scale = Tween(begin: 0.1, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.0,
          0.5,
          curve: widget.curve,
        ),
      ),
    );

    rotate = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 30.0, end: -10.0), weight: 50.0),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 3.0), weight: 20.0),
      TweenSequenceItem(tween: Tween(begin: 3.0, end: 0.0), weight: 30.0),
    ]).animate(
      CurvedAnimation(parent: controller, curve: widget.curve),
    );

    opacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: widget.curve,
      ),
    );

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
    return _GrowTransition(
      child: widget.child,
      controller: controller,
      scale: scale,
      rotate: rotate,
      opacity: opacity,
    );
  }
}

class _GrowTransition extends StatelessWidget {
  const _GrowTransition({
    Key? key,
    required this.controller,
    required this.child,
    required this.rotate,
    required this.scale,
    required this.opacity,
  }) : super(key: key);

  final Widget child;
  final AnimationController controller;
  final Animation<double> scale;
  final Animation<double> rotate;
  final Animation<double> opacity;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final _roate = rotate.value * pi / 180;
        return Transform(
          alignment: FractionalOffset.bottomCenter,
          transform: Matrix4.rotationZ(_roate)..scale(scale.value),
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
