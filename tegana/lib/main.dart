import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Center(
        child: Text(
          '秋山です。インディグネイション（テイルズシリーズ)\n\n浅野です。バーニングキャッチ\n\n小笠原です。爆熱ストーム\n\n河野です。ウルフレジェンド\n\n清水です。皇帝ペンギンX',
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
