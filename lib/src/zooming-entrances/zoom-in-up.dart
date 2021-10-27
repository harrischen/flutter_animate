import 'package:flutter/material.dart';

/// How to achieve zoomIn in animate.css
/// @keyframes zoomInUp {
///   from {
///     opacity: 0;
///     transform: scale3d(0.1, 0.1, 0.1) translate3d(0, 1000px, 0);
///     animation-timing-function: cubic-bezier(0.55, 0.055, 0.675, 0.19);
///   }
///
///   60% {
///     opacity: 1;
///     transform: scale3d(0.475, 0.475, 0.475) translate3d(0, -60px, 0);
///     animation-timing-function: cubic-bezier(0.175, 0.885, 0.32, 1);
///   }
/// }
class ZoomInUp extends StatefulWidget {
  const ZoomInUp({
    Key? key,
    this.child = const Text(
      'ZoomInUp',
      style: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: Colors.lightBlue,
      ),
    ),
    this.duration = const Duration(milliseconds: 1000),
    this.delay = const Duration(milliseconds: 0),
    this.completed,
  }) : super(key: key);

  final Widget child;
  final Duration duration;
  final Duration delay;
  final VoidCallback? completed;

  @override
  _ZoomInUpState createState() => _ZoomInUpState();
}

class _ZoomInUpState extends State<ZoomInUp> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;
  late Animation<double> opacity;
  late Animation<double> offset;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: widget.duration, vsync: this);
    opacity = TweenSequence<double>(<TweenSequenceItem<double>>[
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(
          curve: Cubic(0.55, 0.055, 0.675, 0.19),
        )),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.0).chain(CurveTween(
          curve: Cubic(0.175, 0.885, 0.32, 1),
        )),
        weight: 40,
      ),
    ]).animate(controller);

    scale = TweenSequence<double>(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.1, end: 0.475).chain(CurveTween(
          curve: Cubic(0.55, 0.055, 0.675, 0.19),
        )),
        weight: 60,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.475, end: 1.0).chain(CurveTween(
          curve: Cubic(0.175, 0.885, 0.32, 1),
        )),
        weight: 40,
      ),
    ]).animate(controller);

    offset = TweenSequence<double>(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 1000, end: -60).chain(CurveTween(
          curve: Cubic(0.55, 0.055, 0.675, 0.19),
        )),
        weight: 60,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: -60, end: 0).chain(CurveTween(
          curve: Cubic(0.175, 0.885, 0.32, 1),
        )),
        weight: 40,
      ),
    ]).animate(controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed && widget.completed is Function) {
          widget.completed!();
        }
      });

    Future.delayed(widget.delay, () {
      controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ZoomInUpGrowTransition(
      child: widget.child,
      controller: controller,
      scale: scale,
      opacity: opacity,
      offset: offset,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class ZoomInUpGrowTransition extends StatelessWidget {
  const ZoomInUpGrowTransition({
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
        return Transform.scale(
          scale: scale.value,
          child: Transform.translate(
            offset: Offset(0, offset.value),
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
