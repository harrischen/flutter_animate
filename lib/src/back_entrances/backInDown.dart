import 'package:flutter/material.dart';

class BackInDown extends StatefulWidget {
  const BackInDown({
    Key? key,
    this.child = const Text(
      'BackInDown',
      style: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: Colors.lightBlue,
      ),
    ),
    this.curve = Curves.ease,
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
  _BackInDownState createState() => _BackInDownState();
}

class _BackInDownState extends State<BackInDown>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> translateY;
  late Animation<double> scale;
  late Animation<double> opacity;

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

    final curve = CurvedAnimation(parent: controller, curve: widget.curve);
    translateY = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: -1200.0, end: 0.0), weight: 80),
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 20),
    ]).animate(curve);

    scale = TweenSequence([
      TweenSequenceItem(tween: ConstantTween(0.7), weight: 80),
      TweenSequenceItem(tween: Tween(begin: 0.7, end: 1.0), weight: 20),
    ]).animate(curve);

    opacity = TweenSequence([
      TweenSequenceItem(tween: ConstantTween(0.7), weight: 80),
      TweenSequenceItem(tween: Tween(begin: 0.7, end: 1.0), weight: 20),
    ]).animate(curve);

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
    return BackInDownGrowTransition(
      child: widget.child,
      controller: controller,
      translateY: translateY,
      scale: scale,
      opacity: opacity,
    );
  }
}

class BackInDownGrowTransition extends StatelessWidget {
  const BackInDownGrowTransition({
    Key? key,
    required this.child,
    required this.controller,
    required this.translateY,
    required this.scale,
    required this.opacity,
  }) : super(key: key);

  final Widget child;
  final AnimationController controller;
  final Animation<double> translateY;
  final Animation<double> scale;
  final Animation<double> opacity;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scale,
      builder: (context, child) {
        final _scale =
            Matrix4.diagonal3Values(scale.value, scale.value, scale.value);
        final _offset = Matrix4.translationValues(0.0, translateY.value, 0.0);
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
