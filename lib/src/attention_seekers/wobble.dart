import 'dart:math';
import 'package:flutter/material.dart';

class Wobble extends StatefulWidget {
  const Wobble({
    Key? key,
    this.child = const Text(
      'Wobble',
      style: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: Colors.lightBlue,
      ),
    ),
    this.duration = const Duration(milliseconds: 1000),
    this.delay = const Duration(milliseconds: 1000),
    this.curve = Curves.linear,
    this.completed,
  }) : super(key: key);

  final Widget child;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final VoidCallback? completed;

  @override
  _ShakeXState createState() => _ShakeXState();
}

class _ShakeXState extends State<Wobble> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> rotateZ;
  late Animation<double> offset;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: widget.duration)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed &&
            widget.completed is Function) {
          widget.completed!();
        }
      });

    rotateZ = TweenSequence<double>([
      TweenSequenceItem<double>(
          tween: Tween(begin: 0.0, end: -5.0), weight: 15.0),
      TweenSequenceItem<double>(
          tween: Tween(begin: -5.0, end: 3.0), weight: 15.0),
      TweenSequenceItem<double>(
          tween: Tween(begin: 3.0, end: -3.0), weight: 10.0),
      TweenSequenceItem<double>(
          tween: Tween(begin: -3.0, end: 2.0), weight: 15.0),
      TweenSequenceItem<double>(
          tween: Tween(begin: 2.0, end: -1.0), weight: 15.0),
      TweenSequenceItem<double>(
          tween: Tween(begin: -1.0, end: 0.0), weight: 25.0),
    ]).animate(CurvedAnimation(
      parent: controller,
      curve: widget.curve,
    ));

    offset = TweenSequence<double>([
      TweenSequenceItem<double>(
          tween: Tween(begin: 0.0, end: -25.0), weight: 15.0),
      TweenSequenceItem<double>(
          tween: Tween(begin: -25, end: 20.0), weight: 15.0),
      TweenSequenceItem<double>(
          tween: Tween(begin: 20.0, end: -15.0), weight: 10.0),
      TweenSequenceItem<double>(
          tween: Tween(begin: -15.0, end: 10.0), weight: 15.0),
      TweenSequenceItem<double>(
          tween: Tween(begin: 10.0, end: -5.0), weight: 15.0),
      TweenSequenceItem<double>(
          tween: Tween(begin: -5.0, end: 0.0), weight: 25.0),
    ]).animate(CurvedAnimation(
      parent: controller,
      curve: widget.curve,
    ));

    Future.delayed(widget.delay, () {
      controller.forward();
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _GrowTransition(
      child: widget.child,
      controller: controller,
      rotateZ: rotateZ,
      offset: offset,
    );
  }
}

class _GrowTransition extends StatelessWidget {
  const _GrowTransition({
    Key? key,
    required this.child,
    required this.controller,
    required this.rotateZ,
    required this.offset,
  }) : super(key: key);

  final Widget child;
  final AnimationController controller;
  final Animation<double> rotateZ;
  final Animation<double> offset;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        // final _rotate = Matrix4.rotationZ(rotateZ.value * pi / 180);
        // final _offset = Matrix4.translationValues(offset.value, 0.0, 0.0);
        // return Transform(
        //   alignment: Alignment.center,
        //   transform: _rotate..add(_offset),
        //   child: child,
        // );
        return Transform.rotate(
          angle: rotateZ.value * pi / 180,
          child: FractionalTranslation(
            translation: Offset(offset.value / 100, 0),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}