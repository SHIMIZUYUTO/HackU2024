import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'main.dart';
import 'MainPage.dart';
import 'Photo.dart';


class Yomifuda extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('読み札登録の例'),
      ),
      body: TextInputWidget(),
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

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("ja-JP");
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
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text('入力されたテキスト: ${_controller.text}'),
                  );
                },
              );
              _speak(_controller.text);
            },
            child: Text('送信と読み上げ'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('戻る'),
          )
        ],
      ),
    );
  }
}