import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('テキスト入力と読み上げの例'),
        ),
        body: Center(
          child: TextInputWidget(),
        ),
      ),
    );
  }
}

class TextInputWidget extends StatefulWidget {
  @override
  _TextInputWidgetState createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends State<TextInputWidget> {
  TextEditingController _controller = TextEditingController();
  FlutterTts flutterTts = FlutterTts();
  String _inputText = ""; // 入力されたテキストを格納する変数

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("ja-JP");  // 日本語に設定
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'テキストを入力してください',
            ),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              // 入力されたテキストを変数に保存
              setState(() {
                _inputText = _controller.text;
              });

              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text('入力されたテキスト: $_inputText'),
                  );
                },
              );

              // 変数を使用してテキストを読み上げ
              _speak(_inputText);
            },
            child: Text('送信と読み上げ'),
          ),
        ],
      ),
    );
  }
}