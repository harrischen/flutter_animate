import 'package:flutter/material.dart';

class RubberBand extends StatefulWidget {
  const RubberBand({
    Key? key,
    this.child = const Text(
      'RubberBand',
      style: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: Colors.lightBlue,
      ),
    ),
    this.duration = const Duration(milliseconds: 1700),
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
  _ShakeXState createState() => _ShakeXState();
}

class _ShakeXState extends State<RubberBand>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleX;
  late Animation<double> scaleY;

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

    scaleX = TweenSequence<double>([
      TweenSequenceItem<double>(
          tween: Tween(begin: 1.0, end: 1.25), weight: 30.0),
      TweenSequenceItem<double>(
          tween: Tween(begin: 1.25, end: 0.75), weight: 10.0),
      TweenSequenceItem<double>(
          tween: Tween(begin: 0.75, end: 1.15), weight: 10.0),
      TweenSequenceItem<double>(
          tween: Tween(begin: 1.15, end: 0.95), weight: 15.0),
      TweenSequenceItem<double>(
          tween: Tween(begin: 0.95, end: 1.05), weight: 10.0),
      TweenSequenceItem<double>(
          tween: Tween(begin: 1.05, end: 1.0), weight: 25.0),
    ]).animate(CurvedAnimation(
      parent: controller,
      curve: widget.curve,
    ));

    scaleY = TweenSequence<double>([
      TweenSequenceItem<double>(
          tween: Tween(begin: 1.0, end: 0.75), weight: 30.0),
      TweenSequenceItem<double>(
          tween: Tween(begin: 0.75, end: 1.25), weight: 10.0),
      TweenSequenceItem<double>(
          tween: Tween(begin: 1.25, end: 0.85), weight: 10.0),
      TweenSequenceItem<double>(
          tween: Tween(begin: 0.85, end: 1.05), weight: 15.0),
      TweenSequenceItem<double>(
          tween: Tween(begin: 1.05, end: 0.95), weight: 10.0),
      TweenSequenceItem<double>(
          tween: Tween(begin: 0.95, end: 1.0), weight: 25.0),
    ]).animate(CurvedAnimation(
      parent: controller,
      curve: widget.curve,
    ));

    if (!(widget.controller is AnimationController)) {
      Future.delayed(widget.delay, () {
        controller.forward();
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
      scaleX: scaleX,
      scaleY: scaleY,
    );
  }
}

class _GrowTransition extends StatelessWidget {
  const _GrowTransition({
    Key? key,
    required this.child,
    required this.controller,
    required this.scaleX,
    required this.scaleY,
  }) : super(key: key);

  final Widget child;
  final AnimationController controller;
  final Animation<double> scaleX;
  final Animation<double> scaleY;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.diagonal3Values(scaleX.value, scaleY.value, 1.0),
          child: child,
        );
      },
      child: child,
    );
  }
}
