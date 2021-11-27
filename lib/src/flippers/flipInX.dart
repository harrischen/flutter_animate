import 'dart:math' show pi;
import 'package:flutter/material.dart';

class FlipInX extends StatefulWidget {
  const FlipInX({
    Key? key,
    this.child = const Text(
      'FlipInX',
      style: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: Colors.lightBlue,
      ),
    ),
    this.duration = const Duration(milliseconds: 1000),
    this.delay = const Duration(milliseconds: 1000),
    this.curve = Curves.easeIn,
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
  _FlipInXState createState() => _FlipInXState();
}

class _FlipInXState extends State<FlipInX> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> rotate;
  late Animation<double> opacity;

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

    rotate = TweenSequence([
      TweenSequenceItem(
        tween: Tween(begin: 90.0, end: -20.0).chain(
          CurveTween(curve: widget.curve),
        ),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -20.0, end: 10.0).chain(
          CurveTween(curve: widget.curve),
        ),
        weight: 20,
      ),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -5.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: -5.0, end: 0.0), weight: 20),
    ]).animate(controller);

    opacity = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: controller,
      curve: Interval(0, 0.60),
    ));

    if (!(widget.controller is AnimationController)) {
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
      rotate: rotate,
      opacity: opacity,
    );
  }
}

class _GrowTransition extends StatelessWidget {
  const _GrowTransition({
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
            ..rotateX(rotate.value * pi / 180),
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
