import 'dart:math';
import 'package:flutter/material.dart';

class RollOutRight extends StatefulWidget {
  const RollOutRight({
    Key? key,
    this.child = const Text(
      'RollOutRight',
      style: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: Colors.lightBlue,
      ),
    ),
    this.duration = const Duration(milliseconds: 1000),
    this.delay = const Duration(milliseconds: 1000),
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
  _RollOutRightState createState() => _RollOutRightState();
}

class _RollOutRightState extends State<RollOutRight>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> translate;
  late Animation<double> rotate;
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

    translate = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: widget.curve,
      ),
    );

    rotate = Tween(begin: 0.0, end: 120.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: widget.curve,
      ),
    );

    opacity = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: widget.curve,
      ),
    );

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
      translate: translate,
      rotate: rotate,
      opacity: opacity,
    );
  }
}

class _GrowTransition extends StatelessWidget {
  const _GrowTransition({
    Key? key,
    required this.controller,
    required this.child,
    required this.rotate,
    required this.translate,
    required this.opacity,
  }) : super(key: key);

  final Widget child;
  final AnimationController controller;
  final Animation<double> translate;
  final Animation<double> rotate;
  final Animation<double> opacity;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return FractionalTranslation(
          translation: Offset(translate.value, 0.0),
          child: Transform.rotate(
            alignment: FractionalOffset.center,
            angle: rotate.value * pi / 180,
            child: Opacity(
              opacity: opacity.value,
              child: child,
            ),
          ),
        );
      },
      child: child,
    );
  }
}
