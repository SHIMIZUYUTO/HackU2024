import 'package:flutter/material.dart';

void main() {
  runApp(const KarutaTsukoolApp());
}

class KarutaTsukoolApp extends StatelessWidget {
  const KarutaTsukoolApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'かるたツクール',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // タイトルボタン
              ElevatedButton(
                onPressed: () {
                  // タイトルボタンのアクション
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // 背景色
                  minimumSize: const Size(200, 50), // サイズ
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('かるたツクール', style: TextStyle(fontSize: 20)),
              ),
              const SizedBox(height: 80), // 余白
              // 「遊ぶ」ボタン
              ElevatedButton(
                onPressed: () {
                  // 画面遷移など
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[100], // 背景色
                  minimumSize: const Size(200, 50), // サイズ
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('遊ぶ（1）', style: TextStyle(fontSize: 20, color: Colors.black87)),
              ),
              const SizedBox(height: 20),
              // 「札を登録する」ボタン
              ElevatedButton(
                onPressed: () {
                  // 画面遷移など
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow[200], // 背景色
                  minimumSize: const Size(200, 50), // サイズ
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('札を登録する（4）', style: TextStyle(fontSize: 20, color: Colors.black87)),
              ),
              const SizedBox(height: 20),
              // 「札を見る」ボタン
              ElevatedButton(
                onPressed: () {
                  // 画面遷移など
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue[200], // 背景色
                  minimumSize: const Size(200, 50), // サイズ
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('札を見る（6）', style: TextStyle(fontSize: 20, color: Colors.black87)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}