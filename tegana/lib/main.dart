import 'package:flutter/material.dart';

void main() => runApp(MyApp());

// Playerクラス
class Player {
  String name;
  int score;

  Player({
    required this.name,
    this.score = 0
  });
}

// Cardクラス
class Card {
  String Y_Reading;
  Uint8List? Y_Image; // Uint8Listの使い方が分かりません
  Uint8List? E_Org;
  Uint8List? E_Image;

  Card({
    required this.Y_Reading, 
    required this.Y_Image, 
    required this.E_Org, 
    required this.E_Image,
  });
}

List<Player> playerList = [];
List<Card> cardList = [];

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