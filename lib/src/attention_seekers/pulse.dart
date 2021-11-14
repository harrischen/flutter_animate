import 'package:flutter/material.dart';

class Pulse extends StatefulWidget {
  const Pulse({
    Key? key,
    this.child = const Text(
      'Pulse',
      style: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: Colors.lightBlue,
      ),
    ),
    this.duration = const Duration(milliseconds: 1000),
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
  _PulseState createState() => _PulseState();
}

class _PulseState extends State<Pulse> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;

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
        tween: Tween(begin: 1.0, end: 1.05).chain(
          CurveTween(curve: Curves.easeInOut),
        ),
        weight: 0.5,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.05, end: 1.0).chain(
          CurveTween(curve: Curves.easeInOut),
        ),
        weight: 0.5,
      ),
    ]).animate(controller);

    if (!(widget.controller is AnimationController)) {
      Future.delayed(widget.delay, () {
        controller.forward();
      });
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
    );
  }
}

class _GrowTransition extends StatelessWidget {
  const _GrowTransition({
    Key? key,
    required this.controller,
    required this.child,
    required this.scale,
  }) : super(key: key);

  final Widget child;
  final AnimationController controller;
  final Animation<double> scale;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.scale(
          scale: scale.value,
          child: child,
        );
      },
      child: child,
    );
  }
}
