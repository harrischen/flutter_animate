import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as v;

/// How to achieve zoomIn in animate.css
/// @keyframes zoomOutDown {
///   40% {
///     opacity: 1;
///     transform: scale3d(0.475, 0.475, 0.475) translate3d(0, -60px, 0);
///     animation-timing-function: cubic-bezier(0.55, 0.055, 0.675, 0.19);
///   }
///
///   to {
///     opacity: 0;
///     transform: scale3d(0.1, 0.1, 0.1) translate3d(0, 2000px, 0);
///     animation-timing-function: cubic-bezier(0.175, 0.885, 0.32, 1);
///   }
/// }

class ZoomOutDown extends StatefulWidget {
  const ZoomOutDown({
    Key? key,
    this.child = const Text(
      'ZoomOutDown',
      style: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: Colors.lightBlue,
      ),
    ),
    this.duration = const Duration(milliseconds: 5000),
    this.delay = const Duration(milliseconds: 0),
    this.completed,
  }) : super(key: key);

  final Widget child;
  final Duration duration;
  final Duration delay;
  final VoidCallback? completed;

  @override
  _ZoomOutDownState createState() => _ZoomOutDownState();
}

class _ZoomOutDownState extends State<ZoomOutDown>
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
        tween: ConstantTween<double>(1.0).chain(CurveTween(
          curve: Cubic(0.55, 0.055, 0.675, 0.19),
        )),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0).chain(CurveTween(
          curve: Cubic(0.175, 0.885, 0.32, 1),
        )),
        weight: 60,
      ),
    ]).animate(controller);

    scale = TweenSequence<double>(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 1.0, end: 0.475).chain(CurveTween(
          curve: Cubic(0.55, 0.055, 0.675, 0.19),
        )),
        weight: 40,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.475, end: 0.1).chain(CurveTween(
          curve: Cubic(0.175, 0.885, 0.32, 1),
        )),
        weight: 60,
      ),
    ]).animate(controller);

    offset = TweenSequence<double>(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0, end: -60).chain(CurveTween(
          curve: Cubic(0.55, 0.055, 0.675, 0.19),
        )),
        weight: 40,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: -60, end: 2000).chain(CurveTween(
          curve: Cubic(0.175, 0.885, 0.32, 1),
        )),
        weight: 60,
      ),
    ]).animate(controller);

    Future.delayed(widget.delay, () {
      controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ZoomOutDownGrowTransition(
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

class ZoomOutDownGrowTransition extends StatelessWidget {
  const ZoomOutDownGrowTransition({
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
      // builder: (context, child) {
      //   return Opacity(
      //     opacity: opacity.value,
      //     child: Transform(
      //       alignment: Alignment.bottomCenter,
      //       transform: Matrix4.compose(
      //         v.Vector3(0, offset.value, 0),
      //         v.Quaternion(0, 0, 0, 0),
      //         v.Vector3(scale.value, scale.value, 1),
      //       ),
      //       child: child,
      //     ),
      //   );
      // },
      builder: (context, child) {
        return Transform.scale(
          alignment: Alignment.bottomCenter,
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
