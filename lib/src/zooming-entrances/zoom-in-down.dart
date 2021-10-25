import 'package:flutter/material.dart';

/// How to achieve zoomIn in animate.css
/// @keyframes zoomInDown {
///   from {
///     opacity: 0;
///     transform: scale3d(0.1, 0.1, 0.1) translate3d(0, -1000px, 0);
///     animation-timing-function: cubic-bezier(0.55, 0.055, 0.675, 0.19);
///   }
///
///   60% {
///     opacity: 1;
///     transform: scale3d(0.475, 0.475, 0.475) translate3d(0, 60px, 0);
///     animation-timing-function: cubic-bezier(0.175, 0.885, 0.32, 1);
///   }
/// }
///
/// .zoomInDown {
///   animation-name: zoomInDown;
/// }

class ZoomInDown extends StatefulWidget {
  const ZoomInDown({
    Key? key,
    this.child = const FlutterLogo(),
    this.curve = Curves.linear,
    this.duration = const Duration(milliseconds: 5000),
    this.delay = const Duration(milliseconds: 0),
    this.completed,
  }) : super(key: key);

  final Widget child;
  final Curve curve;
  final Duration duration;
  final Duration delay;
  final VoidCallback? completed;

  @override
  _ZoomInDownState createState() => _ZoomInDownState();
}

class _ZoomInDownState extends State<ZoomInDown>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;
  late Animation<double> opacity;
  late Animation<double> offset;
  late CurvedAnimation curve;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(duration: widget.duration, vsync: this);
    curve = CurvedAnimation(parent: controller, curve: widget.curve)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (widget.completed != null && widget.completed is Function) {
            widget.completed!();
          }
        }
      });

    scale = Tween<double>(begin: 0.1, end: 1.0).animate(curve);
    opacity = Tween<double>(begin: 0.0, end: 1.0).animate(curve);
    offset = Tween<double>(begin: -100, end: 0.0).animate(curve);

    Future.delayed(widget.delay, () {
      controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ZoomInDownGrowTransition(
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

class ZoomInDownGrowTransition extends StatelessWidget {
  const ZoomInDownGrowTransition({
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
