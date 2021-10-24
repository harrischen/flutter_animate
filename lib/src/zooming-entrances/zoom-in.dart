import 'package:flutter/material.dart';

/// How to achieve zoomIn in animate.css
/// @keyframes zoomIn {
///   from {
///     opacity: 0;
///     transform: scale3d(0.3, 0.3, 0.3);
///   }
///
///   50% {
///     opacity: 1;
///   }
/// }
///
/// .zoomIn {
///   animation-name: zoomIn;
/// }
class ZoomIn extends StatefulWidget {
  const ZoomIn({
    Key? key,
    this.child = const FlutterLogo(),
    this.curve = Curves.linear,
  }) : super(key: key);

  final Widget child;
  final Curve curve;

  @override
  _ZoomInState createState() => _ZoomInState();
}

class _ZoomInState extends State<ZoomIn> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;
  late Animation<double> opacity;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);

    scale = Tween<double>(begin: 0.3, end: 1.0)
        .animate(CurvedAnimation(parent: controller, curve: widget.curve));

    opacity = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: controller, curve: widget.curve));

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GrowTransition(
      child: widget.child,
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

class GrowTransition extends StatelessWidget {
  const GrowTransition({
    Key? key,
    required this.child,
    required this.scale,
    required this.opacity,
  }) : super(key: key);

  final Widget child;

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
