import 'package:flutter/material.dart';

class BounceInUp extends StatefulWidget {
  const BounceInUp({
    Key? key,
    this.child = const Text(
      'BounceInUp',
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
  BbounceInUpState createState() => BbounceInUpState();
}

class BbounceInUpState extends State<BounceInUp>
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
      TweenSequenceItem(tween: Tween(begin: 1000.0, end: -20.0), weight: 60),
      TweenSequenceItem(tween: Tween(begin: -20.0, end: 10.0), weight: 15),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -5.0), weight: 15),
      TweenSequenceItem(tween: Tween(begin: -5.0, end: 0.0), weight: 10),
    ]).animate(
      CurvedAnimation(
        parent: controller,
        curve: widget.curve,
      ),
    );

    scale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 5.0, end: 0.9), weight: 60),
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 0.95), weight: 15),
      TweenSequenceItem(tween: Tween(begin: 0.95, end: 0.985), weight: 15),
      TweenSequenceItem(tween: Tween(begin: 0.985, end: 1.0), weight: 10),
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
    return BounceInUpGrowTransition(
      child: widget.child,
      controller: controller,
      scale: scale,
      opacity: opacity,
      translate: translate,
    );
  }
}

class BounceInUpGrowTransition extends StatelessWidget {
  const BounceInUpGrowTransition({
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
        final _scale = Matrix4.diagonal3Values(1.0, scale.value, 1.0);
        final _offset = Matrix4.translationValues(0.0, translate.value, 0.0);
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
