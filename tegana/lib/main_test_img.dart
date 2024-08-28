import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("img"),
      ),
      body: Center(
        child: Image.asset('images/sample.jpg'),
      ),
    );
  }
}
