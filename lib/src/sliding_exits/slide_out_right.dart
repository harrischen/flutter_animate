import 'package:flutter/material.dart';

class SlideOutRight extends StatefulWidget {
  const SlideOutRight({
    Key? key,
    this.child = const Text(
      'SlideOutRight',
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
    this.controller,
  }) : super(key: key);

  final Widget child;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final VoidCallback? completed;
  final AnimationController? controller;

  @override
  _SlideOutRightState createState() => _SlideOutRightState();
}

class _SlideOutRightState extends State<SlideOutRight>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> offset;
  bool visible = true;

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
      if (status == AnimationStatus.completed) {
        setState(() => visible = false);
      }
      if (status == AnimationStatus.forward) {
        setState(() => visible = true);
      }
    });

    offset = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: controller,
      curve: widget.curve,
    ));

    if (widget.controller is! AnimationController) {
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
      offset: offset,
      visible: visible,
    );
  }
}

class _GrowTransition extends StatelessWidget {
  const _GrowTransition({
    Key? key,
    required this.controller,
    required this.child,
    required this.offset,
    required this.visible,
  }) : super(key: key);

  final Widget child;
  final AnimationController controller;
  final Animation<double> offset;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      child: child,
      animation: controller,
      builder: (context, child) => Visibility(
        visible: visible,
        child: FractionalTranslation(
          translation: Offset(offset.value, 0.0),
          child: child,
        ),
      ),
    );
  }
}
