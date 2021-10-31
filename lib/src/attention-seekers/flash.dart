import 'package:flutter/material.dart';

class Flash extends StatefulWidget {
  const Flash({
    Key? key,
    this.child = const Text(
      'Flash',
      style: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: Colors.lightBlue,
      ),
    ),
    this.duration = const Duration(milliseconds: 1000),
    this.delay = const Duration(milliseconds: 0),
    this.completed,
  }) : super(key: key);

  final Widget child;
  final Duration duration;
  final Duration delay;
  final VoidCallback? completed;

  @override
  _FlashState createState() => _FlashState();
}

class _FlashState extends State<Flash> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> opacity;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: widget.duration)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed &&
            widget.completed is Function) {
          widget.completed!();
        }
      });

    opacity = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 0.25),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 0.25),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 0.25),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 0.25),
    ]).animate(controller);

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
    return FlashGrowTransition(
      child: widget.child,
      controller: controller,
      opacity: opacity,
    );
  }
}

class FlashGrowTransition extends StatelessWidget {
  const FlashGrowTransition({
    Key? key,
    required this.controller,
    required this.child,
    required this.opacity,
  }) : super(key: key);

  final Widget child;
  final AnimationController controller;
  final Animation<double> opacity;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Opacity(
          opacity: opacity.value,
          child: child,
        );
      },
      child: child,
    );
  }
}
