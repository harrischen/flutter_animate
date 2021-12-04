import 'package:flutter/material.dart';

class ShakeY extends StatefulWidget {
  const ShakeY({
    Key? key,
    this.child = const Text(
      'ShakeY',
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

class _ShakeXState extends State<ShakeY> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> translateY;

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

    translateY = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -10.0), weight: 10.0),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 10.0),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 10.0),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 10.0),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 10.0),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 10.0),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 10.0),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 10.0),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 10.0),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 0.0), weight: 10.0),
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
      translateY: translateY,
    );
  }
}

class _GrowTransition extends StatelessWidget {
  const _GrowTransition({
    Key? key,
    required this.child,
    required this.controller,
    required this.translateY,
  }) : super(key: key);

  final Widget child;
  final AnimationController controller;
  final Animation<double> translateY;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      child: child,
      animation: controller,
      builder: (context, child) => Transform(
        transform: Matrix4.translationValues(0.0, translateY.value, 0.0),
        child: child,
      ),
    );
  }
}
