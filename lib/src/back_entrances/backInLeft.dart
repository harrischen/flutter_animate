import 'package:flutter/material.dart';

class BackInLeft extends StatefulWidget {
  const BackInLeft({
    Key? key,
    this.child = const Text(
      'BackInLeft',
      style: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: Colors.lightBlue,
      ),
    ),
    this.curve = Curves.easeInOut,
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
  _BackInLeftState createState() => _BackInLeftState();
}

class _BackInLeftState extends State<BackInLeft> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> translateX;
  late Animation<double> scale;
  late Animation<double> opacity;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(duration: widget.duration, vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed && widget.completed is Function) {
          widget.completed!();
        }
      });

    translateX = TweenSequence([
      TweenSequenceItem(
        tween: Tween(begin: -1200.0, end: 0.0).chain(
          CurveTween(curve: widget.curve),
        ),
        weight: 85,
      ),
      // pause for a while
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 5),
      // continue to run to the end
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 10),
    ]).animate(controller);

    scale = TweenSequence([
      TweenSequenceItem(
        tween: ConstantTween(0.7).chain(
          CurveTween(curve: widget.curve),
        ),
        weight: 85,
      ),
      // pause for a while
      TweenSequenceItem(tween: ConstantTween(0.7), weight: 5),
      // continue to run to the end
      TweenSequenceItem(tween: Tween(begin: 0.7, end: 1.0), weight: 10),
    ]).animate(controller);

    opacity = TweenSequence([
      TweenSequenceItem(
        tween: ConstantTween(0.7).chain(
          CurveTween(curve: widget.curve),
        ),
        weight: 85,
      ),
      // pause for a while
      TweenSequenceItem(tween: ConstantTween(0.7), weight: 5),
      // continue to run to the end
      TweenSequenceItem(tween: Tween(begin: 0.7, end: 1.0), weight: 10),
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
    return BackInLeftGrowTransition(
      child: widget.child,
      controller: controller,
      translateX: translateX,
      scale: scale,
      opacity: opacity,
    );
  }
}

class BackInLeftGrowTransition extends StatelessWidget {
  const BackInLeftGrowTransition({
    Key? key,
    required this.child,
    required this.controller,
    required this.translateX,
    required this.scale,
    required this.opacity,
  }) : super(key: key);

  final Widget child;
  final AnimationController controller;
  final Animation<double> translateX;
  final Animation<double> scale;
  final Animation<double> opacity;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scale,
      builder: (context, child) {
        final _scale = Matrix4.diagonal3Values(scale.value, scale.value, scale.value);
        final _offset = Matrix4.translationValues(translateX.value, 0.0, 0.0);
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
