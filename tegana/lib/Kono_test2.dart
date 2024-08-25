import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('テキスト入力(ひらがな、カタカナ)の例'),
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

  // フォームのキーを定義
  final _formKey = GlobalKey<FormState>();
  // formKey…フォーム全体の状態を管理するために使う
  // GlobalKey…ウィジェットに一意にアクセスするためのキー
  //           ウィジェットの状態にアクセスし、操作する
  // FormState…フォームの状態を管理するクラス


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),  // 左右に16ピクセルの空白
      child: Form(
        key: _formKey,  // フォームのキーを指定
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: _controller,  // コントローラをTextFormFieldに渡す
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'テキスト（ひらがな、カタカナ）を入力してください', // 表示するラベル
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {    //入力欄が空欄だった場合
                  return 'テキストが入力されていません'; // エラーメッセージ
                }
                if(!RegExp(r'^[ぁ-ゖァ-ヶー]*$').hasMatch(value)){     //ひらがな、カタカナ以外が入力されている場合
                  return 'ひらがなまたはカタカナを入力してください';  //エラーメッセージ 
                }
                return null; // エラーがない場合はnullを返す
              },
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // バリデーションの実行
                // バリデーション…ユーザーが入力したデータが正しいかどうかをチェックする仕組み
                if (_formKey.currentState!.validate()) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text('入力されたテキスト: ${_controller.text}'),
                      );
                    },
                  );
                }
              },
              child: Text('入力内容の表示'),
            ),
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
