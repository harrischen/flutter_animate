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
    this.duration = const Duration(milliseconds: 1000),
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
  _BackInLeftState createState() => _BackInLeftState();
}

class _BackInLeftState extends State<BackInLeft>
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
      TweenSequenceItem(
        tween: Tween(begin: -1200.0, end: 0.0).chain(
          CurveTween(curve: widget.curve),
        ),
        weight: 85,
      ),
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 5),
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 10),
    ]).animate(controller);

    scale = TweenSequence([
      TweenSequenceItem(
        tween: ConstantTween(0.7).chain(
          CurveTween(curve: widget.curve),
        ),
        weight: 85,
      ),
      TweenSequenceItem(tween: ConstantTween(0.7), weight: 5),
      TweenSequenceItem(tween: Tween(begin: 0.7, end: 1.0), weight: 10),
    ]).animate(controller);

    opacity = TweenSequence([
      TweenSequenceItem(
        tween: ConstantTween(0.7).chain(
          CurveTween(curve: widget.curve),
        ),
        weight: 85,
      ),
      TweenSequenceItem(tween: ConstantTween(0.7), weight: 5),
      TweenSequenceItem(tween: Tween(begin: 0.7, end: 1.0), weight: 10),
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
      child: child,
      animation: controller,
      builder: (context, child) => Transform.translate(
        offset: Offset(translateX.value, 0.0),
        child: Transform.scale(
          alignment: FractionalOffset.center,
          scale: scale.value,
          child: Opacity(
            opacity: opacity.value,
            child: child,
          ),
        ),
      ),
    );
  }
}
