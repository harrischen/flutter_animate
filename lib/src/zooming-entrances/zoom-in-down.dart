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
  const ZoomInDown({Key? key}) : super(key: key);

  @override
  _ZoomInDownState createState() => _ZoomInDownState();
}

class _ZoomInDownState extends State<ZoomInDown> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class GrowTransition extends StatelessWidget {
  const GrowTransition({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
