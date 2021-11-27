import 'dart:math' show pi;
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

class _ShakeXState extends State<Tada> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> rotateZ;
  late Animation<double> scale;

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
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -3.0), weight: 10.0),
      TweenSequenceItem(tween: ConstantTween(-3.0), weight: 10.0),
      TweenSequenceItem(tween: Tween(begin: -3.0, end: 3.0), weight: 10.0),
      TweenSequenceItem(tween: Tween(begin: 3.0, end: -3.0), weight: 10.0),
      TweenSequenceItem(tween: Tween(begin: -3.0, end: 3.0), weight: 10.0),
      TweenSequenceItem(tween: Tween(begin: 3.0, end: -3.0), weight: 10.0),
      TweenSequenceItem(tween: Tween(begin: -3.0, end: 3.0), weight: 10.0),
      TweenSequenceItem(tween: Tween(begin: 3.0, end: -3.0), weight: 10.0),
      TweenSequenceItem(tween: Tween(begin: -3.0, end: 3.0), weight: 10.0),
      TweenSequenceItem(tween: Tween(begin: 3.0, end: 0.0), weight: 10.0),
    ]).animate(CurvedAnimation(parent: controller, curve: widget.curve));

    scale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.9), weight: 10.0),
      TweenSequenceItem(tween: ConstantTween(0.9), weight: 10.0),
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.1), weight: 10.0),
      TweenSequenceItem(tween: ConstantTween(1.1), weight: 60.0),
      TweenSequenceItem(tween: Tween(begin: 1.1, end: 1.0), weight: 10.0),
    ]).animate(CurvedAnimation(parent: controller, curve: widget.curve));

    if (!(widget.controller is AnimationController)) {
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
      child: child,
      animation: controller,
      builder: (context, child) => Transform.rotate(
        angle: rotateZ.value * pi / 180,
        child: Transform.scale(
          scale: scale.value,
          child: child,
        ),
      ),
    );
  }
}
