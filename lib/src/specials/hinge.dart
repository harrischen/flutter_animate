import 'dart:math';
import 'package:flutter/material.dart';

class Hinge extends StatefulWidget {
  const Hinge({
    Key? key,
    this.child = const Text(
      'Hinge',
      style: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: Colors.lightBlue,
      ),
    ),
    this.duration = const Duration(milliseconds: 2000),
    this.delay = const Duration(milliseconds: 1000),
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
  _HingeState createState() => _HingeState();
}

class _HingeState extends State<Hinge> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> translate;
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

    translate = Tween(begin: 0.0, end: 700.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.8, 1.0, curve: widget.curve),
      ),
    );

    rotate = TweenSequence([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 80.0).chain(
          CurveTween(curve: widget.curve),
        ),
        weight: 20.0,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 80.0, end: 60.0).chain(
          CurveTween(curve: widget.curve),
        ),
        weight: 20.0,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 60.0, end: 80.0).chain(
          CurveTween(curve: widget.curve),
        ),
        weight: 20.0,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 80.0, end: 60.0).chain(
          CurveTween(curve: widget.curve),
        ),
        weight: 20.0,
      ),
      TweenSequenceItem(tween: ConstantTween(60.0), weight: 20.0),
    ]).animate(controller);

    opacity = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.8, 1.0, curve: widget.curve),
      ),
    );

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
      translate: translate,
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
    required this.translate,
    required this.opacity,
  }) : super(key: key);

  final Widget child;
  final AnimationController controller;
  final Animation<double> translate;
  final Animation<double> rotate;
  final Animation<double> opacity;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0.0, translate.value),
          child: Transform.rotate(
            alignment: FractionalOffset.topLeft,
            angle: rotate.value * pi / 180,
            child: Opacity(
              opacity: opacity.value,
              child: child,
            ),
          ),
        );
      },
      child: child,
    );
  }
}
