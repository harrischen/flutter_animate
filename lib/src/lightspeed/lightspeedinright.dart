import 'dart:math';
import 'package:flutter/material.dart';

class LightSpeedInRight extends StatefulWidget {
  const LightSpeedInRight({
    Key? key,
    this.child = const Text(
      'LightSpeedInRight',
      style: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: Colors.lightBlue,
      ),
    ),
    this.duration = const Duration(milliseconds: 1000),
    this.delay = const Duration(milliseconds: 1000),
    this.curve = Curves.easeOut,
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
  _LightSpeedInRightState createState() => _LightSpeedInRightState();
}

class _LightSpeedInRightState extends State<LightSpeedInRight>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> translate;
  late Animation<double> skew;
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

    translate = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
      parent: controller,
      curve: Interval(0.0, 0.6, curve: widget.curve),
    ));

    skew = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: -30.0, end: 20.0), weight: 60.0),
      TweenSequenceItem(tween: Tween(begin: 20.0, end: -5.0), weight: 20.0),
      TweenSequenceItem(tween: Tween(begin: -5.0, end: 0.0), weight: 20.0),
    ]).animate(CurvedAnimation(
      parent: controller,
      curve: widget.curve,
    ));

    opacity = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: controller,
      curve: Interval(0.0, 0.6, curve: widget.curve),
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
      translate: translate,
      skew: skew,
      opacity: opacity,
    );
  }
}

class _GrowTransition extends StatelessWidget {
  const _GrowTransition({
    Key? key,
    required this.child,
    required this.controller,
    required this.translate,
    required this.skew,
    required this.opacity,
  }) : super(key: key);

  final Widget child;
  final AnimationController controller;
  final Animation<double> translate;
  final Animation<double> skew;
  final Animation<double> opacity;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform(
          alignment: FractionalOffset.center,
          transform: Matrix4.skewX(skew.value * pi / 180),
          child: FractionalTranslation(
            translation: Offset(translate.value, 0.0),
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
