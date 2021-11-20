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
  _FlashState createState() => _FlashState();
}

class _FlashState extends State<Flash> with SingleTickerProviderStateMixin {
  late AnimationController controller;
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

    opacity = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 25.0),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 25.0),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 25.0),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 25.0),
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
      opacity: opacity,
    );
  }
}

class _GrowTransition extends StatelessWidget {
  const _GrowTransition({
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
      child: child,
      animation: controller,
      builder: (context, child) => Opacity(
        opacity: opacity.value,
        child: child,
      ),
    );
  }
}
