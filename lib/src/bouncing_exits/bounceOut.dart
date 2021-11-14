import 'package:flutter/material.dart';

class BounceOut extends StatefulWidget {
  const BounceOut({
    Key? key,
    this.child = const Text(
      'BounceOut',
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
  BbounceOutState createState() => BbounceOutState();
}

class BbounceOutState extends State<BounceOut>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;
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

    scale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.9), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.1), weight: 30),
      TweenSequenceItem(tween: ConstantTween(1.1), weight: 5),
      TweenSequenceItem(tween: Tween(begin: 1.1, end: 0.3), weight: 45),
    ]).animate(
      CurvedAnimation(
        parent: controller,
        curve: widget.curve,
      ),
    );

    opacity = TweenSequence([
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 55),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 45),
    ]).animate(
      CurvedAnimation(
        parent: controller,
        curve: widget.curve,
      ),
    );

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
      scale: scale,
      opacity: opacity,
    );
  }
}

class _GrowTransition extends StatelessWidget {
  const _GrowTransition({
    Key? key,
    required this.child,
    required this.controller,
    required this.scale,
    required this.opacity,
  }) : super(key: key);

  final Widget child;
  final AnimationController controller;
  final Animation<double> scale;
  final Animation<double> opacity;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scale,
      builder: (context, child) {
        return Transform.scale(
          alignment: Alignment.center,
          scale: scale.value,
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
