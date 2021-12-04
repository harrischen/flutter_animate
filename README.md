<h1 align="center">Flutter Animate</h1>


Thanks to the [`animate_do`](https://github.com/Klerith/animate_do_package) project for giving me development inspiration. 

Thanks to the [`animate.css`](https://github.com/animate-css/animate.css) project for giving me the visual experience.

This project is my personal learning project (if successful, it will be integrated into the project of my company).

1. Learn the basic layout effects of Flutter;
2. Learn the Flutter Animate effect and create the corresponding animation component library;

## How To Use

https://user-images.githubusercontent.com/8149304/144707098-bcb0f8d4-c9cd-4d3e-b2d0-a16d9ef17571.mov


### install package
```yaml
flutter_animate:
  git:
    url: https://github.com/harrischen/flutter_animate.git
    ref: main
```

### use package
```dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isAnimate = false;

  void _changeToEnd() => setState(() => isAnimate = true);
  void _changeToStart() => setState(() => isAnimate = false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 160.0,
              child: Row(
                children: [
                  Expanded(
                    child: isAnimate
                        ? Flip(
                            child: const DemoIcon(),
                            completed: _changeToStart,
                          )
                        : const DemoIcon(),
                  ),
                  Expanded(
                    child: isAnimate
                        ? FlipInX(
                            child: const DemoIcon(),
                            completed: _changeToStart,
                          )
                        : const DemoIcon(),
                  ),
                  Expanded(
                    child: isAnimate
                        ? FlipInY(
                            child: const DemoIcon(),
                            completed: _changeToStart,
                          )
                        : const DemoIcon(),
                  )
                ],
              ),
            ),
            ElevatedButton(
              child: Text(isAnimate ? 'In Animation' : 'Play'),
              onPressed: _changeToEnd,
            ),
          ],
        ),
      ),
    );
  }
}

class DemoIcon extends StatelessWidget {
  const DemoIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.adb_rounded,
      size: 56.0,
    );
  }
}
```


## ✨ Features

### Attention seekers
* [x] bounce
* [x] flash
* [x] pulse
* [x] rubberBand
* [x] shakeX
* [x] shakeY
* [x] headShake
* [x] swing
* [x] tada
* [x] wobble
* [x] jello
* [x] heartBeat

### Back entrances
* [x] backInDown
* [x] backInLeft
* [x] backInRight
* [x] backInUp

### Back exits
* [x] backOutDown
* [x] backOutLeft
* [x] backOutRight
* [x] backOutUp

### Bouncing entrances
* [x] bounceIn
* [x] bounceInDown
* [x] bounceInLeft
* [x] bounceInRight
* [x] bounceInUp

### Bouncing exits
* [x] bounceOut
* [x] bounceOutDown
* [x] bounceOutLeft
* [x] bounceOutRight
* [x] bounceOutUp

### Fading entrances
* [x] fadeIn
* [x] fadeInDown
* [x] fadeInLeft
* [x] fadeInRight
* [x] fadeInUp
* [x] fadeInTopLeft
* [x] fadeInTopRight
* [x] fadeInBottomLeft
* [x] fadeInBottomRight

### Fading exits
* [x] fadeOut
* [x] fadeOutDown
* [x] fadeOutLeft
* [x] fadeOutRight
* [x] fadeOutUp
* [x] fadeOutTopLeft
* [x] fadeOutTopRight
* [x] fadeOutBottomRight
* [x] fadeOutBottomLeft

### Flippers
* [x] flip
* [x] flipInX
* [x] flipInY
* [x] flipOutX
* [x] flipOutY

### Lightspeed
* [x] lightSpeedInRight
* [x] lightSpeedInLeft
* [x] lightSpeedOutRight
* [x] lightSpeedOutLeft

### Rotating entrances
* [x] rotateIn
* [x] rotateInDownLeft
* [x] rotateInDownRight
* [x] rotateInUpLeft
* [x] rotateInUpRight

### Rotating exits
* [x] rotateOut
* [x] rotateOutDownLeft
* [x] rotateOutDownRight
* [x] rotateOutUpLeft
* [x] rotateOutUpRight

### Specials
* [x] hinge
* [x] jackInTheBox
* [x] rollInLeft
* [x] rollInRight
* [x] rollOutLeft
* [x] rollOutRight

### Zooming entrances
* [x] zoomIn
* [x] zoomInDown
* [x] zoomInLeft
* [x] zoomInRight
* [x] zoomInUp

### Zooming exits
* [x] zoomOut
* [x] zoomOutDown
* [x] zoomOutLeft
* [x] zoomOutRight
* [x] zoomOutUp

### Sliding entrances
* [x] slideInDown
* [x] slideInLeft
* [x] slideInRight
* [x] slideInUp

### Sliding exits
* [x] slideOutDown
* [x] slideOutLeft
* [x] slideOutRight
* [x] slideOutUp


## Flutter Doctor

```
[✓] Flutter (Channel stable, 2.5.1, on macOS 11.6 20G165 darwin-x64, locale zh-Hans-CN)
    • Flutter version 2.5.1 at /usr/local/Caskroom/flutter/2.5.1/flutter
    • Upstream repository https://github.com/flutter/flutter.git
    • Framework revision ffb2ecea52 (9 weeks ago), 2021-09-17 15:26:33 -0400
    • Engine revision b3af521a05
    • Dart version 2.14.2
```
