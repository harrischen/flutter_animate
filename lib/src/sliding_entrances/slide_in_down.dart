import 'package:flutter/material.dart';

class SlideInDown extends StatefulWidget {
  const SlideInDown({
    Key? key,
    this.child = const Text(
      'SlideInDown',
      style: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: Colors.lightBlue,
      ),
    ),
    this.duration = const Duration(milliseconds: 1000),
    this.delay = const Duration(milliseconds: 0),
    this.curve = Curves.ease,
    this.begin = 1.0,
    this.end = 0.0,
    this.completed,
    this.controller,
  })  : assert(duration >= const Duration(milliseconds: 100)),
        assert(delay >= const Duration(milliseconds: 0)),
        assert(begin >= 0.0, 'Must be greater than or equal to 0.0'),
        assert(end <= 0.0, 'Must be less than or equal to 0.0'),
        super(key: key);

  final Widget child;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final double begin;
  final double end;
  final VoidCallback? completed;
  final AnimationController? controller;

  @override
  _SlideInDownState createState() => _SlideInDownState();
}

class _SlideInDownState extends State<SlideInDown>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> offset;
  bool visible = false;

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

    offset = Tween<double>(
      begin: widget.begin,
      end: widget.end,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: widget.curve,
    ));

    if (widget.controller is! AnimationController) {
      Future.delayed(widget.delay, () {
        setState(() => visible = true);
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
          translation: Offset(0.0, -offset.value),
          child: child,
        ),
      ),
    );
  }
}
