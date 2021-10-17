import 'package:flutter/material.dart';

class LayoutExampleApp extends StatelessWidget {
  const LayoutExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Layout Demo'),
      ),
      body: Column(
        children: [
          ImageSection(),
          TitleSection(),
          ButtonSection(),
          TextSection(),
        ],
      ),
    );
  }
}

class TitleSection extends StatelessWidget {
  const TitleSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Oeschinen Lake Campground',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  'Kandersteg, Switzerland',
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          FavoriteWidget(),
        ],
      ),
    );
  }
}

class FavoriteWidget extends StatefulWidget {
  const FavoriteWidget({Key? key}) : super(key: key);

  @override
  _FavoriteWidgetState createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget> {
  bool _isFavorited = true;
  int _favoriteCount = 41;

  /// 点击切换选中状态
  void _toggleFavorite() {
    setState(() {
      if (_isFavorited) {
        _favoriteCount -= 1;
        _isFavorited = false;
      } else {
        _favoriteCount += 1;
        _isFavorited = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          padding: const EdgeInsets.all(0),
          onPressed: _toggleFavorite,
          color: _isFavorited ? Colors.red : Colors.green,
          icon: _isFavorited
              ? const Icon(Icons.star)
              : const Icon(Icons.star_border),
        ),
        SizedBox(
          width: 18,
          child: Text('$_favoriteCount'),
        )
      ],
    );
  }
}

Column _button(Color color, IconData icon, String label) {
  return Column(
    children: [
      Icon(icon, color: color),
      Text(label),
    ],
  );
}

class ButtonSection extends StatelessWidget {
  const ButtonSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _button(color, Icons.call, 'CALL'),
        _button(color, Icons.near_me, 'ROUTE'),
        _button(color, Icons.share, 'SHARE'),
      ],
    );
  }
}

class TextSection extends StatelessWidget {
  const TextSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'Lake Oeschinen lies at the foot of the Blüemlisalp in the Bernese Alps. Situated 1,578 meters above sea level, it is one of the larger Alpine Lakes. A gondola ride from Kandersteg, followed by a half-hour walk through pastures and pine forest, leads you to the lake, which warms to 20 degrees Celsius in the summer. Activities enjoyed here include rowing, and riding the summer toboggan run.',
      softWrap: true,
    );
  }
}

class ImageSection extends StatelessWidget {
  const ImageSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/lake.jpg',
      width: 600,
      height: 240,
      fit: BoxFit.cover,
    );
  }
}
