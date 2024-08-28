import 'package:flutter/material.dart';
import 'Asano_image3.dart'; // 別ファイルに分けた画像保存機能をインポート

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Save Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Photo(),
    );
  }
}

class Photo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('絵札登録ページ'),
      ),
      body: MyHomePage(), // メインウィジェットを表示
    );
  }
}