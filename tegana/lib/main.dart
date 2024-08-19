import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class Player {
  String name;
  int score;

  Player({
    required this.name,
    this.score = 0
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Center(
        child: Text(
          'メインです',
          textDirection: TextDirection.ltr,
          style: TextStyle(
            fontSize: 32,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}