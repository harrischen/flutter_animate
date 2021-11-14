import 'package:flutter/material.dart';
import 'package:motion/motion.dart';

List<Map> getNavigation() {
  return [
    {
      "title": "Attention seekers",
      "children": [
        "bounce",
        "flash",
        "pulse",
        "rubberBand",
        "shakeX",
        "shakeY",
        "headShake",
        "swing",
        "tada",
        "wobble",
        "jello",
        "heartBeat",
      ],
    },
    {
      "title": "Back entrances",
      "children": [
        "backInDown",
        "backInLeft",
        "backInRight",
        "backInUp",
      ],
    },
    {
      "title": "Back exits",
      "children": [
        "backOutDown",
        "backOutLeft",
        "backOutRight",
        "backOutUp",
      ],
    },
    {
      "title": "Bouncing entrances",
      "children": [
        "bounceIn",
        "bounceInDown",
        "bounceInLeft",
        "bounceInRight",
        "bounceInUp",
      ],
    },
    {
      "title": "Bouncing exits",
      "children": [
        "bounceOut",
        "bounceOutDown",
        "bounceOutLeft",
        "bounceOutRight",
        "bounceOutUp",
      ],
    },
    {
      "title": "Fading entrances",
      "children": [
        "fadeIn",
        "fadeInDown",
        "fadeInLeft",
        "fadeInRight",
        "fadeInUp",
        "fadeInTopLeft",
        "fadeInTopRight",
        "fadeInBottomLeft",
        "fadeInBottomRight",
      ],
    },
    {
      "title": "Fading exits",
      "children": [
        "fadeOut",
        "fadeOutDown",
        "fadeOutLeft",
        "fadeOutRight",
        "fadeOutUp",
        "fadeOutTopLeft",
        "fadeOutTopRight",
        "fadeOutBottomRight",
        "fadeOutBottomLeft",
      ],
    },
    {
      "title": "Flippers",
      "children": [
        "flip",
        "flipInX",
        "flipInY",
        "flipOutX",
        "flipOutY",
      ],
    },
    {
      "title": "Lightspeed",
      "children": [
        "lightSpeedInRight",
        "lightSpeedInLeft",
        "lightSpeedOutRight",
        "lightSpeedOutLeft",
      ],
    },
    {
      "title": "Rotating entrances",
      "children": [
        "rotateIn",
        "rotateInDownLeft",
        "rotateInDownRight",
        "rotateInUpLeft",
        "rotateInUpRight",
      ],
    },
    {
      "title": "Rotating exits",
      "children": [
        "rotateOut",
        "rotateOutDownLeft",
        "rotateOutDownRight",
        "rotateOutUpLeft",
        "rotateOutUpRight",
      ],
    },
    {
      "title": "Specials",
      "children": [
        "hinge",
        "jackInTheBox",
        "rollInLeft",
        "rollInRight",
        "rollOutLeft",
        "rollOutRight",
      ],
    },
    {
      "title": "Zooming entrances",
      "children": [
        "zoomIn",
        "zoomInDown",
        "zoomInLeft",
        "zoomInRight",
        "zoomInUp",
      ],
    },
    {
      "title": "Zooming exits",
      "children": [
        "zoomOut",
        "zoomOutDown",
        "zoomOutLeft",
        "zoomOutRight",
        "zoomOutUp",
      ],
    },
    {
      "title": "Sliding entrances",
      "children": [
        "slideInDown",
        "slideInLeft",
        "slideInRight",
        "slideInUp",
      ],
    },
    {
      "title": "Sliding exits",
      "children": [
        "slideOutDown",
        "slideOutLeft",
        "slideOutRight",
        "slideOutUp",
      ],
    },
  ];
}

class GetMotionWidget extends StatelessWidget {
  const GetMotionWidget({
    Key? key,
    required this.title,
    required this.controller,
  }) : super(key: key);
  final String title;
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    Widget _widget = ZoomInDown();
    switch (this.title) {
      case "bounce":
        _widget = Bounce();
        break;
      case "flash":
        _widget = Flash();
        break;
      case "pulse":
        _widget = Pulse();
        break;
      case "rubberBand":
        _widget = RubberBand();
        break;
      case "shakeX":
        _widget = ShakeX();
        break;
      case "shakeY":
        _widget = ShakeY();
        break;
      case "headShake":
        _widget = HeadShake();
        break;
      case "swing":
        _widget = Swing();
        break;
      case "tada":
        _widget = Tada();
        break;
      case "wobble":
        _widget = Wobble();
        break;
      case "jello":
        _widget = Jello();
        break;
      case "heartBeat":
        _widget = HeartBeat();
        break;
      case "backInDown":
        _widget = BackInDown();
        break;
      case "backInLeft":
        _widget = BackInLeft();
        break;
      case "backInRight":
        _widget = BackInRight();
        break;
      case "backInUp":
        _widget = BackInUp();
        break;
      case "backOutDown":
        _widget = BackOutDown();
        break;
      case "backOutLeft":
        _widget = BackOutLeft();
        break;
      case "backOutRight":
        _widget = BackOutRight();
        break;
      case "backOutUp":
        _widget = BackOutUp();
        break;
      case "bounceIn":
        _widget = BounceIn();
        break;
      case "bounceInDown":
        _widget = BounceInDown();
        break;
      case "bounceInLeft":
        _widget = BounceInLeft();
        break;
      case "bounceInRight":
        _widget = BounceInRight();
        break;
      case "bounceInUp":
        _widget = BounceInUp();
        break;
      case "bounceOut":
        _widget = BounceOut();
        break;
      case "bounceOutDown":
        _widget = BounceOutDown();
        break;
      case "bounceOutLeft":
        _widget = BounceOutLeft();
        break;
      case "bounceOutRight":
        _widget = BounceOutRight();
        break;
      case "bounceOutUp":
        _widget = BounceOutUp();
        break;
      case "fadeIn":
        _widget = FadeIn();
        break;
      case "fadeInDown":
        _widget = FadeInDown();
        break;
      case "fadeInLeft":
        _widget = FadeInLeft();
        break;
      case "fadeInRight":
        _widget = FadeInRight();
        break;
      case "fadeInUp":
        _widget = FadeInUp();
        break;
      case "fadeInTopLeft":
        _widget = FadeInTopLeft();
        break;
      case "fadeInTopRight":
        _widget = FadeInTopRight();
        break;
      case "fadeInBottomLeft":
        _widget = FadeInBottomLeft();
        break;
      case "fadeInBottomRight":
        _widget = FadeInBottomRight();
        break;
      case "fadeOut":
        _widget = FadeOut();
        break;
      case "fadeOutDown":
        _widget = FadeOutDown();
        break;
      case "fadeOutLeft":
        _widget = FadeOutLeft();
        break;
      case "fadeOutRight":
        _widget = FadeOutRight();
        break;
      case "fadeOutUp":
        _widget = FadeOutUp();
        break;
      case "fadeOutTopLeft":
        _widget = FadeOutTopLeft();
        break;
      case "fadeOutTopRight":
        _widget = FadeOutTopRight();
        break;
      case "fadeOutBottomRight":
        _widget = FadeOutBottomRight();
        break;
      case "fadeOutBottomLeft":
        _widget = FadeOutBottomLeft();
        break;
      case "flip":
        _widget = Flip();
        break;
      case "flipInX":
        _widget = FlipInX();
        break;
      case "flipInY":
        _widget = FlipInY();
        break;
      case "flipOutX":
        _widget = FlipOutX();
        break;
      case "flipOutY":
        _widget = FlipOutY();
        break;
      case "lightSpeedInRight":
        _widget = LightSpeedInRight();
        break;
      case "lightSpeedInLeft":
        _widget = LightSpeedInLeft();
        break;
      case "lightSpeedOutRight":
        _widget = LightSpeedOutRight();
        break;
      case "lightSpeedOutLeft":
        _widget = LightSpeedOutLeft();
        break;
      case "rotateIn":
        _widget = RotateIn();
        break;
      case "rotateInDownLeft":
        _widget = RotateInDownLeft();
        break;
      case "rotateInDownRight":
        _widget = RotateInDownRight();
        break;
      case "rotateInUpLeft":
        _widget = RotateInUpLeft();
        break;
      case "rotateInUpRight":
        _widget = RotateInUpRight();
        break;
      case "rotateOut":
        _widget = RotateOut();
        break;
      case "rotateOutDownLeft":
        _widget = RotateOutDownLeft();
        break;
      case "rotateOutDownRight":
        _widget = RotateOutDownRight();
        break;
      case "rotateOutUpLeft":
        _widget = RotateOutUpLeft();
        break;
      case "rotateOutUpRight":
        _widget = RotateOutUpRight();
        break;
      case "hinge":
        _widget = Hinge();
        break;
      case "jackInTheBox":
        _widget = JackInTheBox();
        break;
      case "rollInLeft":
        _widget = RollInLeft();
        break;
      case "rollInRight":
        _widget = RollInRight();
        break;
      case "rollOutLeft":
        _widget = RollOutLeft();
        break;
      case "rollOutRight":
        _widget = RollOutRight();
        break;
      case "zoomIn":
        _widget = ZoomIn();
        break;
      case "zoomInDown":
        _widget = ZoomInDown();
        break;
      case "zoomInLeft":
        _widget = ZoomInLeft();
        break;
      case "zoomInRight":
        _widget = ZoomInRight();
        break;
      case "zoomInUp":
        _widget = ZoomInUp();
        break;
      case "zoomOut":
        _widget = ZoomOut();
        break;
      case "zoomOutDown":
        _widget = ZoomOutDown();
        break;
      case "zoomOutLeft":
        _widget = ZoomOutLeft();
        break;
      case "zoomOutRight":
        _widget = ZoomOutRight();
        break;
      case "zoomOutUp":
        _widget = ZoomOutUp();
        break;
      case "slideInDown":
        _widget = SlideInDown();
        break;
      case "slideInLeft":
        _widget = SlideInLeft();
        break;
      case "slideInRight":
        _widget = SlideInRight();
        break;
      case "slideInUp":
        _widget = SlideInUp();
        break;
      case "slideOutDown":
        _widget = SlideOutDown();
        break;
      case "slideOutLeft":
        _widget = SlideOutLeft();
        break;
      case "slideOutRight":
        _widget = SlideOutRight();
        break;
      case "slideOutUp":
        _widget = SlideOutUp();
        break;
    }
    return _widget;
  }
}
