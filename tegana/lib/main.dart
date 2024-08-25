import 'package:flutter/material.dart';
import 'package:tegana/ImageEditPage.dart';
import 'dart:typed_data'; // Uint8Listに必要
import 'MainPage.dart';
import 'Photo.dart';
import 'Yomifuda.dart';
import 'crop_your_image.dart';

void main() => runApp(MyApp());

// Playerクラス
class Player {
  String name;
  int score;

  Player({required this.name, this.score = 0});
}

// Cardsクラス
class Cards {
  String Y_Reading;
  Uint8List? Y_Image;
  Uint8List? E_Org;
  Uint8List? E_Image;

  Cards({
    required this.Y_Reading,
    required this.Y_Image,
    required this.E_Org,
    required this.E_Image,
  });
}

// リストの宣言
List<Player> playerList = [];
List<Cards> cardList = [];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => MainPage(),
        '/testPhoto': (BuildContext context) => Photo(),
        '/testYomifuda': (BuildContext context) => Yomifuda(),
      },
    );
  }
}
