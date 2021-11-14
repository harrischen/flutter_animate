import 'package:flutter/material.dart';
import 'config.dart';

class Menus extends StatelessWidget {
  const Menus({Key? key, required this.callback}) : super(key: key);
  final Function(String title) callback;

  @override
  Widget build(BuildContext context) {
    final nav = getNavigation();
    return ListView.builder(
      itemCount: nav.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Container(
          width: 180,
          color: Colors.blue[(index % 4) * 100],
          child: MenuItem(
            title: nav[index]['title'],
            children: nav[index]['children'],
            callback: (title) => this.callback(title),
          ),
        );
      },
    );
  }
}

class MenuItem extends StatelessWidget {
  MenuItem({
    Key? key,
    required this.title,
    required this.children,
    required this.callback,
  }) : super(key: key);

  final String title;
  final List<String> children;
  final Function(String title) callback;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MenuTitle(title: this.title),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: this
                  .children
                  .map((title) => MenuSubtitle(
                        title: title,
                        callback: (title) => this.callback(title),
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class MenuTitle extends StatelessWidget {
  const MenuTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 18.0,
        right: 10.0,
        bottom: 10.0,
        left: 10.0,
      ),
      child: Text(
        this.title,
        style: TextStyle(
          fontSize: 14.0,
          color: Colors.black,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class MenuSubtitle extends StatelessWidget {
  const MenuSubtitle({
    Key? key,
    required this.title,
    required this.callback,
  }) : super(key: key);

  final String title;
  final Function(String title) callback;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      child: GestureDetector(
        onTap: () => this.callback(this.title),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.check_circle_outline_outlined, size: 12.0),
            ),
            Text(
              this.title,
              style: TextStyle(fontSize: 12.0, color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
