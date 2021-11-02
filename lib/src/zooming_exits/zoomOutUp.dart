import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// How to achieve zoomIn in animate.css
/// @keyframes zoomOutUp {
///   40% {
///     opacity: 1;
///     transform: scale3d(0.475, 0.475, 0.475) translate3d(0, 60px, 0);
///     animation-timing-function: cubic-bezier(0.55, 0.055, 0.675, 0.19);
///   }
///
///   to {
///     opacity: 0;
///     transform: scale3d(0.1, 0.1, 0.1) translate3d(0, -2000px, 0);
///     animation-timing-function: cubic-bezier(0.175, 0.885, 0.32, 1);
///   }
/// }

class ZoomOutUp extends StatefulWidget {
  const ZoomOutUp({
    Key? key,
    this.child = const Text(
      'ZoomOutUp',
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
  _ZoomOutUpState createState() => _ZoomOutUpState();
}

class _ZoomOutUpState extends State<ZoomOutUp>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;
  late Animation<double> opacity;
  late Animation<double> offset;

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
        tween: Tween<double>(begin: 0.475, end: 0.0).chain(CurveTween(
          curve: Cubic(0.175, 0.885, 0.32, 1),
        )),
        weight: 60.0,
      ),
    ]).animate(controller);

    offset = TweenSequence<double>(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0, end: 60).chain(CurveTween(
          curve: Cubic(0.55, 0.055, 0.675, 0.19),
        )),
        weight: 40.0,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 60, end: -1000).chain(CurveTween(
          curve: Cubic(0.175, 0.885, 0.32, 1),
        )),
        weight: 60.0,
      ),
    ]).animate(controller);

    Future.delayed(widget.delay, () {
      controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ZoomOutUpGrowTransition(
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

class ZoomOutUpGrowTransition extends StatelessWidget {
  const ZoomOutUpGrowTransition({
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
        final _offset = Matrix4.translationValues(0.0, offset.value, 0.0);
        final _scale =
            Matrix4.diagonal3Values(scale.value, scale.value, scale.value);
        return Transform(
          alignment: Alignment.bottomCenter,
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
