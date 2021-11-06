import 'package:flutter/material.dart';

class BounceInLeft extends StatefulWidget {
  const BounceInLeft({
    Key? key,
    this.child = const Text(
      'BounceInLeft',
      style: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: Colors.lightBlue,
      ),
    ),
    this.curve = const Cubic(0.215, 0.61, 0.355, 1),
    this.duration = const Duration(milliseconds: 1000),
    this.delay = const Duration(milliseconds: 1000),
    this.completed,
  }) : super(key: key);

  final Widget child;
  final Curve curve;
  final Duration duration;
  final Duration delay;
  final VoidCallback? completed;

  @override
  BbounceInLeftState createState() => BbounceInLeftState();
}

class BbounceInLeftState extends State<BounceInLeft>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;
  late Animation<double> opacity;
  late Animation<double> translate;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(duration: widget.duration, vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed &&
            widget.completed is Function) {
          widget.completed!();
        }
      });

    translate = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: -1000.0, end: 25.0), weight: 60),
      TweenSequenceItem(tween: Tween(begin: 25.0, end: -10.0), weight: 15),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 5.0), weight: 15),
      TweenSequenceItem(tween: Tween(begin: 5.0, end: 0.0), weight: 10),
    ]).animate(
      CurvedAnimation(
        parent: controller,
        curve: widget.curve,
      ),
    );

    scale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 3.0, end: 1.0), weight: 60),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.98), weight: 15),
      TweenSequenceItem(tween: Tween(begin: 0.98, end: 0.995), weight: 15),
      TweenSequenceItem(tween: Tween(begin: 0.995, end: 1.0), weight: 10),
    ]).animate(
      CurvedAnimation(
        parent: controller,
        curve: widget.curve,
      ),
    );

    opacity = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: controller,
      curve: Interval(0, 0.60),
    ));

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
    return BounceInLeftGrowTransition(
      child: widget.child,
      controller: controller,
      scale: scale,
      opacity: opacity,
      translate: translate,
    );
  }
}

class BounceInLeftGrowTransition extends StatelessWidget {
  const BounceInLeftGrowTransition({
    Key? key,
    required this.child,
    required this.controller,
    required this.scale,
    required this.opacity,
    required this.translate,
  }) : super(key: key);

  final Widget child;
  final AnimationController controller;
  final Animation<double> scale;
  final Animation<double> opacity;
  final Animation<double> translate;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final _scale = Matrix4.diagonal3Values(scale.value, 1.0, 1.0);
        final _offset = Matrix4.translationValues(translate.value, 0.0, 0.0);
        return Transform(
          alignment: Alignment.center,
          transform: _scale..add(_offset),
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
