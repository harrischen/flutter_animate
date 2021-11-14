import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ZoomOutRight extends StatefulWidget {
  const ZoomOutRight({
    Key? key,
    this.child = const Text(
      'ZoomOutRight',
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
  _ZoomOutRightState createState() => _ZoomOutRightState();
}

class _ZoomOutRightState extends State<ZoomOutRight>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;
  late Animation<double> opacity;
  late Animation<double> offset;

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

    opacity = TweenSequence<double>(<TweenSequenceItem<double>>[
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.0).chain(CurveTween(
          curve: Cubic(0.55, 0.055, 0.675, 0.19),
        )),
        weight: 40.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0).chain(CurveTween(
          curve: Cubic(0.175, 0.885, 0.32, 1),
        )),
        weight: 60.0,
      ),
    ]).animate(controller);

    scale = TweenSequence<double>(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 1.0, end: 0.475).chain(CurveTween(
          curve: Cubic(0.55, 0.055, 0.675, 0.19),
        )),
        weight: 40.0,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.475, end: 0.1).chain(CurveTween(
          curve: Cubic(0.175, 0.885, 0.32, 1),
        )),
        weight: 60.0,
      ),
    ]).animate(controller);

    offset = TweenSequence<double>(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0, end: -42).chain(CurveTween(
          curve: Cubic(0.55, 0.055, 0.675, 0.19),
        )),
        weight: 40.0,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: -42, end: 1000).chain(CurveTween(
          curve: Cubic(0.175, 0.885, 0.32, 1),
        )),
        weight: 60.0,
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
      scale: scale,
      opacity: opacity,
      offset: offset,
    );
  }
}

class _GrowTransition extends StatelessWidget {
  const _GrowTransition({
    Key? key,
    required this.controller,
    required this.child,
    required this.scale,
    required this.opacity,
    required this.offset,
  }) : super(key: key);

  final Widget child;
  final AnimationController controller;
  final Animation<double> scale;
  final Animation<double> opacity;
  final Animation<double> offset;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final _offset = Matrix4.translationValues(offset.value, 0.0, 0.0);
        final _scale =
            Matrix4.diagonal3Values(scale.value, scale.value, scale.value);
        return Transform(
          alignment: Alignment.centerRight,
          transform: _offset..add(_scale),
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
