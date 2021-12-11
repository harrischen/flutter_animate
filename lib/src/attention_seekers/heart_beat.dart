import 'package:flutter/material.dart';

class HeartBeat extends StatefulWidget {
  const HeartBeat({
    Key? key,
    this.child = const Text(
      'HeartBeat',
      style: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: Colors.lightBlue,
      ),
    ),
    this.duration = const Duration(milliseconds: 1300),
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
  _HeartBeatState createState() => _HeartBeatState();
}

class _HeartBeatState extends State<HeartBeat>
    with SingleTickerProviderStateMixin {
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
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 14.0),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 14.0),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 14.0),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 28.0),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 30.0),
    ]).animate(CurvedAnimation(parent: controller, curve: widget.curve));

    if (widget.controller is! AnimationController) {
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
      controller: controller,
      scale: scale,
      child: widget.child,
    );
  }
}

class _GrowTransition extends StatelessWidget {
  const _GrowTransition({
    Key? key,
    required this.child,
    required this.controller,
    required this.scale,
  }) : super(key: key);

  final Widget child;
  final AnimationController controller;
  final Animation<double> scale;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      child: child,
      animation: controller,
      builder: (context, child) => Transform.scale(
        child: child,
        scale: scale.value,
      ),
    );
  }
}
