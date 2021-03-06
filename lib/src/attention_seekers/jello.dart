import 'dart:math' show pi;
import 'package:flutter/material.dart';

class Jello extends StatefulWidget {
  const Jello({
    Key? key,
    this.child = const Text(
      'Jello',
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
    this.controller,
  }) : super(key: key);

  final Widget child;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final VoidCallback? completed;
  final AnimationController? controller;

  @override
  _JelloState createState() => _JelloState();
}

class _JelloState extends State<Jello> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> skew;

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

    skew = TweenSequence([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: -12.5),
        weight: 22.2,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -12.5, end: 6.25),
        weight: 11.1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 6.25, end: -3.125),
        weight: 11.1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -3.125, end: 1.5625),
        weight: 11.1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.5625, end: -0.78125),
        weight: 11.1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -0.78125, end: 0.390625),
        weight: 11.1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.390625, end: -0.1953125),
        weight: 11.1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -0.1953125, end: 0.0),
        weight: 11.2,
      ),
    ]).animate(CurvedAnimation(parent: controller, curve: widget.curve));

    if (widget.controller is! AnimationController) {
      Future.delayed(widget.delay, () => controller.forward());
    }
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
      skew: skew,
    );
  }
}

class _GrowTransition extends StatelessWidget {
  const _GrowTransition({
    Key? key,
    required this.controller,
    required this.child,
    required this.skew,
  }) : super(key: key);

  final Widget child;
  final AnimationController controller;
  final Animation<double> skew;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      child: child,
      animation: controller,
      builder: (context, child) => Transform(
        child: child,
        alignment: FractionalOffset.center,
        transform: Matrix4.skew(skew.value * pi / 180, skew.value * pi / 180),
      ),
    );
  }
}
