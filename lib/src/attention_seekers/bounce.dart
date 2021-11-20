import 'package:flutter/material.dart';

class Bounce extends StatefulWidget {
  const Bounce({
    Key? key,
    this.child = const Text(
      'Bounce',
      style: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: Colors.lightBlue,
      ),
    ),
    this.duration = const Duration(milliseconds: 1000),
    this.delay = const Duration(milliseconds: 0),
    this.curve = Curves.easeIn,
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
  _BounceState createState() => _BounceState();
}

class _BounceState extends State<Bounce> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> translateY;
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

    translateY = TweenSequence([
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 20.0),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -30.0), weight: 20.0),
      TweenSequenceItem(tween: ConstantTween(-30.0), weight: 3.0),
      TweenSequenceItem(tween: Tween(begin: -30.0, end: 0.0), weight: 10.0),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -15.0), weight: 17.0),
      TweenSequenceItem(tween: Tween(begin: -15.0, end: 0.0), weight: 10.0),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -4.0), weight: 10.0),
      TweenSequenceItem(tween: Tween(begin: -4.0, end: 0.0), weight: 10.0),
    ]).animate(CurvedAnimation(parent: controller, curve: widget.curve));

    scaleY = TweenSequence([
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 20.0),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.1), weight: 20.0),
      TweenSequenceItem(tween: ConstantTween(1.1), weight: 3.0),
      TweenSequenceItem(tween: Tween(begin: 1.1, end: 1.0), weight: 10.0),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.05), weight: 17.0),
      TweenSequenceItem(tween: Tween(begin: 1.05, end: 0.95), weight: 10.0),
      TweenSequenceItem(tween: Tween(begin: 0.95, end: 1.02), weight: 10.0),
      TweenSequenceItem(tween: Tween(begin: 1.02, end: 1.0), weight: 10.0),
    ]).animate(CurvedAnimation(parent: controller, curve: widget.curve));

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
      translateY: translateY,
      scaleY: scaleY,
    );
  }
}

class _GrowTransition extends StatelessWidget {
  const _GrowTransition({
    Key? key,
    required this.child,
    required this.controller,
    required this.translateY,
    required this.scaleY,
  }) : super(key: key);

  final Widget child;
  final AnimationController controller;
  final Animation<double> translateY;
  final Animation<double> scaleY;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      child: child,
      animation: controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0.0, translateY.value),
          child: Transform(
            alignment: FractionalOffset.bottomCenter,
            transform: Matrix4.diagonal3Values(1.0, scaleY.value, 1.0),
            child: child,
          ),
        );
      },
    );
  }
}
