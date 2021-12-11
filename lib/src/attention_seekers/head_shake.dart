import 'dart:math' show pi;
import 'package:flutter/material.dart';

class HeadShake extends StatefulWidget {
  const HeadShake({
    Key? key,
    this.child = const Text(
      'HeadShake',
      style: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: Colors.lightBlue,
      ),
    ),
    this.duration = const Duration(milliseconds: 1000),
    this.delay = const Duration(milliseconds: 0),
    this.curve = Curves.easeInOut,
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
  _HeadShakeState createState() => _HeadShakeState();
}

class _HeadShakeState extends State<HeadShake>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> translateX;
  late Animation<double> rotateY;

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

    translateX = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -6.0), weight: 6.5),
      TweenSequenceItem(tween: Tween(begin: -6.0, end: 5.0), weight: 12.0),
      TweenSequenceItem(tween: Tween(begin: 5.0, end: -3.0), weight: 13.0),
      TweenSequenceItem(tween: Tween(begin: -3.0, end: 2.0), weight: 12.0),
      TweenSequenceItem(tween: Tween(begin: 2.0, end: 0.0), weight: 6.5),
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 50.0),
    ]).animate(CurvedAnimation(parent: controller, curve: widget.curve));

    rotateY = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -9.0), weight: 6.5),
      TweenSequenceItem(tween: Tween(begin: -9.0, end: 7.0), weight: 12.0),
      TweenSequenceItem(tween: Tween(begin: 7.0, end: -5.0), weight: 13.0),
      TweenSequenceItem(tween: Tween(begin: -5.0, end: 3.0), weight: 12.0),
      TweenSequenceItem(tween: Tween(begin: 3.0, end: 0.0), weight: 6.5),
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 50.0),
    ]).animate(CurvedAnimation(parent: controller, curve: widget.curve));

    if (widget.controller is! AnimationController) {
      Future.delayed(widget.delay, () => controller.forward());
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
      translateX: translateX,
      rotateY: rotateY,
    );
  }
}

class _GrowTransition extends StatelessWidget {
  const _GrowTransition({
    Key? key,
    required this.child,
    required this.controller,
    required this.translateX,
    required this.rotateY,
  }) : super(key: key);

  final Widget child;
  final AnimationController controller;
  final Animation<double> translateX;
  final Animation<double> rotateY;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      child: child,
      animation: controller,
      builder: (context, child) => Transform.translate(
        offset: Offset(translateX.value, 0.0),
        child: Transform(
          child: child,
          alignment: FractionalOffset.center,
          transform: Matrix4.rotationY(rotateY.value * pi / 180),
        ),
      ),
    );
  }
}
