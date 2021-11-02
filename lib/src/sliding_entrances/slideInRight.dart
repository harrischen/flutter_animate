import 'package:flutter/material.dart';

class SlideInRight extends StatefulWidget {
  const SlideInRight({
    Key? key,
    this.child = const Text(
      'SlideInRight',
      style: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: Colors.lightBlue,
      ),
    ),
    this.duration = const Duration(milliseconds: 1000),
    this.delay = const Duration(milliseconds: 0),
    this.curve = Curves.ease,
    this.completed,
  }) : super(key: key);

  final Widget child;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final VoidCallback? completed;

  @override
  _SlideInRightState createState() => _SlideInRightState();
}

class _SlideInRightState extends State<SlideInRight>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
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

    offset = Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
      parent: controller,
      curve: widget.curve,
    ));

    Future.delayed(widget.delay, () {
      controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _GrowTransition(
      child: widget.child,
      controller: controller,
      offset: offset,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class _GrowTransition extends StatelessWidget {
  const _GrowTransition({
    Key? key,
    required this.controller,
    required this.child,
    required this.offset,
  }) : super(key: key);

  final Widget child;
  final AnimationController controller;
  final Animation<double> offset;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return FractionalTranslation(
          translation: Offset(0.0, offset.value),
          child: child,
        );
      },
      child: child,
    );
  }
}
