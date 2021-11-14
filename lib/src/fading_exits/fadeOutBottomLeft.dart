import 'package:flutter/material.dart';

class FadeOutBottomLeft extends StatefulWidget {
  const FadeOutBottomLeft({
    Key? key,
    this.child = const Text(
      'FadeOutBottomLeft',
      style: TextStyle(
        fontSize: 38,
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
  _FadeOutBottomLeftState createState() => _FadeOutBottomLeftState();
}

class _FadeOutBottomLeftState extends State<FadeOutBottomLeft>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> offset;
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

    offset = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(-1.0, 1.0),
    ).animate(CurvedAnimation(
      parent: controller,
      curve: widget.curve,
    ));

    opacity = Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
      parent: controller,
      curve: widget.curve,
    ));

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
      offset: offset,
      opacity: opacity,
    );
  }
}

class _GrowTransition extends StatelessWidget {
  const _GrowTransition({
    Key? key,
    required this.controller,
    required this.child,
    required this.offset,
    required this.opacity,
  }) : super(key: key);

  final Widget child;
  final AnimationController controller;
  final Animation<Offset> offset;
  final Animation<double> opacity;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Opacity(
          opacity: opacity.value,
          child: FractionalTranslation(
            translation: Offset(offset.value.dx, offset.value.dy),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
