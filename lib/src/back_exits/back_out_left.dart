import 'package:flutter/material.dart';

class BackOutLeft extends StatefulWidget {
  const BackOutLeft({
    Key? key,
    this.child = const Text(
      'BackOutLeft',
      style: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: Colors.lightBlue,
      ),
    ),
    this.duration = const Duration(milliseconds: 1000),
    this.delay = const Duration(milliseconds: 0),
    this.curve = Curves.easeOut,
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
  _BackOutLeftState createState() => _BackOutLeftState();
}

class _BackOutLeftState extends State<BackOutLeft>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> translateX;
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

    translateX = TweenSequence([
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 15),
      // pause for a while
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 10),
      // continue to run to the end
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: -1200.0).chain(
          CurveTween(curve: widget.curve),
        ),
        weight: 75,
      ),
    ]).animate(controller);

    scale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.7), weight: 15),
      // pause for a while
      TweenSequenceItem(tween: ConstantTween(0.7), weight: 10),
      // continue to run to the end
      TweenSequenceItem(
        tween: ConstantTween(0.7).chain(
          CurveTween(curve: widget.curve),
        ),
        weight: 75,
      ),
    ]).animate(controller);

    opacity = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.7), weight: 15),
      // pause for a while
      TweenSequenceItem(tween: ConstantTween(0.7), weight: 10),
      // continue to run to the end
      TweenSequenceItem(
        tween: ConstantTween(0.7).chain(
          CurveTween(curve: widget.curve),
        ),
        weight: 75,
      ),
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
      translateX: translateX,
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
        final _scale =
            Matrix4.diagonal3Values(scale.value, scale.value, scale.value);
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
