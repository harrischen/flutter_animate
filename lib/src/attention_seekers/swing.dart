import 'dart:math' show pi;
import 'package:flutter/material.dart';

class Swing extends StatefulWidget {
  const Swing({
    Key? key,
    this.child = const Text(
      'Swing',
      style: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: Colors.lightBlue,
      ),
    ),
    this.duration = const Duration(milliseconds: 1000),
    this.delay = const Duration(milliseconds: 0),
    this.curve = Curves.linear,
    this.repeat = false,
    this.completed,
    this.controller,
  }) : super(key: key);

  final Widget child;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final bool repeat;
  final VoidCallback? completed;
  final AnimationController? controller;

  @override
  _ShakeXState createState() => _ShakeXState();
}

class _ShakeXState extends State<Swing> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> rotateZ;

  @override
  void initState() {
    super.initState();
    controller = (widget.controller is AnimationController
        ? widget.controller
        : AnimationController(vsync: this, duration: widget.duration))!;
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && widget.completed is Function) {
        widget.completed!();
      }
    });

    rotateZ = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 15.0), weight: 20.0),
      TweenSequenceItem(tween: Tween(begin: 15.0, end: -10.0), weight: 20.0),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 5.0), weight: 20.0),
      TweenSequenceItem(tween: Tween(begin: 5.0, end: -5.0), weight: 20.0),
      TweenSequenceItem(tween: Tween(begin: -5.0, end: 0.0), weight: 20.0),
    ]).animate(CurvedAnimation(parent: controller, curve: widget.curve));

    if (widget.controller is! AnimationController) {
      Future.delayed(widget.delay, () {
        controller.forward();
        if (widget.repeat) {
          controller.repeat();
        }
      });
    }
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
    );
  }
}

class _GrowTransition extends StatelessWidget {
  const _GrowTransition({
    Key? key,
    required this.child,
    required this.controller,
    required this.rotateZ,
  }) : super(key: key);

  final Widget child;
  final AnimationController controller;
  final Animation<double> rotateZ;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      child: child,
      animation: controller,
      builder: (context, child) => Transform(
        child: child,
        alignment: FractionalOffset.topCenter,
        transform: Matrix4.rotationZ(rotateZ.value * pi / 180),
      ),
    );
  }
}
