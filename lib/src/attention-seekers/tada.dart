import 'dart:math';
import 'package:flutter/material.dart';

class Tada extends StatefulWidget {
  const Tada({
    Key? key,
    this.child = const Text(
      'Tada',
      style: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: Colors.lightBlue,
      ),
    ),
    this.duration = const Duration(milliseconds: 1000),
    this.delay = const Duration(milliseconds: 0),
    this.curve = Curves.ease,
    this.completed,
  }) : super(key: key);

  final Widget child;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final VoidCallback? completed;

  @override
  _ShakeXState createState() => _ShakeXState();
}

class _ShakeXState extends State<Tada> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> rotateZ;
  late Animation<double> scale;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: widget.duration)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed && widget.completed is Function) {
          widget.completed!();
        }
      });

    rotateZ = TweenSequence<double>([
      TweenSequenceItem<double>(tween: Tween(begin: 0.0, end: -3.0), weight: 10.0),
      TweenSequenceItem<double>(tween: ConstantTween(-3.0), weight: 10.0),
      TweenSequenceItem<double>(tween: Tween(begin: -3.0, end: 3.0), weight: 10.0),
      TweenSequenceItem<double>(tween: Tween(begin: 3.0, end: -3.0), weight: 10.0),
      TweenSequenceItem<double>(tween: Tween(begin: -3.0, end: 3.0), weight: 10.0),
      TweenSequenceItem<double>(tween: Tween(begin: 3.0, end: -3.0), weight: 10.0),
      TweenSequenceItem<double>(tween: Tween(begin: -3.0, end: 3.0), weight: 10.0),
      TweenSequenceItem<double>(tween: Tween(begin: 3.0, end: -3.0), weight: 10.0),
      TweenSequenceItem<double>(tween: Tween(begin: -3.0, end: 3.0), weight: 10.0),
      TweenSequenceItem<double>(tween: Tween(begin: 3.0, end: 0.0), weight: 10.0),
    ]).animate(CurvedAnimation(
      parent: controller,
      curve: widget.curve,
    ));

    scale = TweenSequence<double>([
      TweenSequenceItem<double>(tween: Tween(begin: 1.0, end: 0.9), weight: 10.0),
      TweenSequenceItem<double>(tween: ConstantTween(0.9), weight: 10.0),
      TweenSequenceItem<double>(tween: Tween(begin: 0.9, end: 1.1), weight: 10.0),
      TweenSequenceItem<double>(tween: ConstantTween(1.1), weight: 60.0),
      TweenSequenceItem<double>(tween: Tween(begin: 1.1, end: 1.0), weight: 10.0),
    ]).animate(CurvedAnimation(
      parent: controller,
      curve: widget.curve,
    ));

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
      rotateZ: rotateZ,
      scale: scale,
    );
  }
}

class _GrowTransition extends StatelessWidget {
  const _GrowTransition({
    Key? key,
    required this.child,
    required this.controller,
    required this.rotateZ,
    required this.scale,
  }) : super(key: key);

  final Widget child;
  final AnimationController controller;
  final Animation<double> rotateZ;
  final Animation<double> scale;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final _rotate = Matrix4.rotationZ(rotateZ.value * pi / 180);
        final _scale = Matrix4.diagonal3Values(scale.value, scale.value, scale.value);
        return Transform(
          alignment: Alignment.center,
          transform: _rotate..add(_scale),
          child: child,
        );
      },
      child: child,
    );
  }
}
