import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('テキスト入力の例'),
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
  // テキスト入力のコントローラを作成
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),  //左右に16ピクセルの空白
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: _controller,  // コントローラをTextFieldに渡す
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'テキストを入力してください',  //表示するラベル
            ),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () { // ボタンが押されたとき
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text('入力されたテキスト: ${_controller.text}'),
                  );
                },
              );
            },
            child: Text('送信'),
          ),
        ],
      ),
    );
  }
}