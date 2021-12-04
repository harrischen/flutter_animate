import 'dart:math' show pi;
import 'package:flutter/material.dart';

class Flip extends StatefulWidget {
  const Flip({
    Key? key,
    this.child = const Text(
      'Flip',
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
  _FlipState createState() => _FlipState();
}

class _FlipState extends State<Flip> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;
  late Animation<double> translate;
  late Animation<double> rotate;

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

    scale = TweenSequence([
      TweenSequenceItem(
        tween: ConstantTween(1.0).chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.95).chain(
          CurveTween(curve: Curves.easeIn),
        ),
        weight: 30.0,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.95, end: 1.0).chain(
          CurveTween(curve: Curves.easeIn),
        ),
        weight: 20.0,
      ),
    ]).animate(controller);

    translate = TweenSequence([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 150.0).chain(
          CurveTween(curve: Curves.easeOut),
        ),
        weight: 40.0,
      ),
      TweenSequenceItem(
        tween: ConstantTween(150.0).chain(
          CurveTween(curve: Curves.easeIn),
        ),
        weight: 10.0,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 150.0, end: 0.0).chain(
          CurveTween(curve: Curves.easeIn),
        ),
        weight: 30.0,
      ),
      TweenSequenceItem(
        tween: ConstantTween(0.0).chain(CurveTween(curve: Curves.easeIn)),
        weight: 20.0,
      ),
    ]).animate(controller);

    rotate = TweenSequence([
      TweenSequenceItem(
        tween: Tween(begin: -360.0, end: -190.0).chain(
          CurveTween(curve: Curves.easeOut),
        ),
        weight: 40.0,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -190.0, end: -170.0).chain(
          CurveTween(curve: Curves.easeIn),
        ),
        weight: 10.0,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -170.0, end: 0.0).chain(
          CurveTween(curve: Curves.easeIn),
        ),
        weight: 30.0,
      ),
      TweenSequenceItem(
        tween: ConstantTween(0.0).chain(CurveTween(curve: Curves.easeIn)),
        weight: 20.0,
      ),
    ]).animate(controller);

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
      scale: scale,
      translate: translate,
      rotate: rotate,
    );
  }
}

class _GrowTransition extends StatelessWidget {
  const _GrowTransition({
    Key? key,
    required this.child,
    required this.controller,
    required this.scale,
    required this.translate,
    required this.rotate,
  }) : super(key: key);

  final Widget child;
  final AnimationController controller;
  final Animation<double> scale;
  final Animation<double> translate;
  final Animation<double> rotate;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform(
          alignment: FractionalOffset.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, -0.004)
            ..scale(scale.value)
            ..translate(0.0, 0.0, translate.value)
            ..rotateY(rotate.value * pi / 180),
          child: child,
        );
      },
      child: child,
    );
  }
}
