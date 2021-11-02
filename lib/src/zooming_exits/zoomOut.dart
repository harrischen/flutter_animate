import 'package:flutter/material.dart';

/// How to achieve zoomOut in animate.css
/// @keyframes zoomOut {
///   from {
///     opacity: 0;
///     transform: scale3d(0.3, 0.3, 0.3);
///   }
///
///   50% {
///     opacity: 1;
///   }
/// }

class ZoomOut extends StatefulWidget {
  const ZoomOut({
    Key? key,
    this.child = const Text(
      'ZoomOut',
      style: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: Colors.lightBlue,
      ),
    ),
    this.curve = Curves.linear,
    this.duration = const Duration(milliseconds: 500),
    this.delay = const Duration(milliseconds: 0),
    this.completed,
  }) : super(key: key);

  final Widget child;
  final Curve curve;
  final Duration duration;
  final Duration delay;
  final VoidCallback? completed;

  @override
  _ZoomOutState createState() => _ZoomOutState();
}

class _ZoomOutState extends State<ZoomOut> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;
  late Animation<double> opacity;
  late CurvedAnimation curve;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(duration: widget.duration, vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed && widget.completed is Function) {
          widget.completed!();
        }
      });
    curve = CurvedAnimation(parent: controller, curve: widget.curve);

    scale = Tween<double>(begin: 1.0, end: 0.3).animate(curve);
    opacity = Tween<double>(begin: 1.0, end: 0.0).animate(curve);

    Future.delayed(widget.delay, () {
      controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ZoomOutGrowTransition(
      child: widget.child,
      controller: controller,
      scale: scale,
      opacity: opacity,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class ZoomOutGrowTransition extends StatelessWidget {
  const ZoomOutGrowTransition({
    Key? key,
    required this.child,
    required this.controller,
    required this.scale,
    required this.opacity,
  }) : super(key: key);

  final Widget child;
  final AnimationController controller;
  final Animation<double> scale;
  final Animation<double> opacity;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scale,
      builder: (context, child) {
        return Transform.scale(
          scale: scale.value,
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
