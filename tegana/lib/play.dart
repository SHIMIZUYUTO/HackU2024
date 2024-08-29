import 'package:flutter/material.dart';
import 'main.dart';

List<String> playerList = ["noPlayer", "noPlayer", "noPlayer", "noPlayer"];
int human = 0;

//PL登録
class PL extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('人数を選択してください')),
      body: PLHomePage(),
    );
  }
}

class PLHomePage extends StatefulWidget {
  @override
  _PLHomePage createState() => _PLHomePage();
}

//人数選択
class _PLHomePage extends State<PLHomePage> {
  int sor = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Align(
        alignment: Alignment.topCenter, // 画面の中央上部に配置
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  human = 1;
                  Navigator.of(context).pushNamed("/inTexts1");
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(150, 60), // ボタンのサイズを設定
                ),
                child: new Text(
                  '1',
                  style: TextStyle(
                    fontSize: 24, // フォントサイズを設定
                    fontWeight: FontWeight.bold, // フォントの太さを設定
                  ),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  human = 2;
                  Navigator.of(context).pushNamed("/inTexts1");
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(150, 60), // ボタンのサイズを設定
                ),
                child: new Text(
                  '2',
                  style: TextStyle(
                    fontSize: 24, // フォントサイズを設定
                    fontWeight: FontWeight.bold, // フォントの太さを設定
                  ),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  human = 3;
                  Navigator.of(context).pushNamed("/inTexts1");
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(150, 60), // ボタンのサイズを設定
                ),
                child: new Text(
                  '3',
                  style: TextStyle(
                    fontSize: 24, // フォントサイズを設定
                    fontWeight: FontWeight.bold, // フォントの太さを設定
                  ),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  human = 4;
                  Navigator.of(context).pushNamed("/inTexts1");
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(150, 60), // ボタンのサイズを設定
                ),
                child: new Text(
                  '4',
                  style: TextStyle(
                    fontSize: 24, // フォントサイズを設定
                    fontWeight: FontWeight.bold, // フォントの太さを設定
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

//こっからテキストボックス
class inTexts1 extends StatelessWidget {
  /*2*/
  @override
  Widget build(BuildContext context) {
    /*3*/
    return Scaffold(
        /*4*/
        appBar: AppBar(
          title: Text("プレイヤー名の入力"),
        ),
        body: ChangeForm());
  }
}

//テキストボックス名前登録の画面
class ChangeForm extends StatefulWidget {
  @override
  _ChangeFormState createState() => _ChangeFormState();
}

class _ChangeFormState extends State<ChangeForm> {
  String _text1 = '';
  TextEditingController _controller = TextEditingController(); // テキストコントローラを追加
  final _formKey = GlobalKey<FormState>(); // フォームキーを追加
  int count = 0;
  void _handleText(String e) {
    setState(() {
      _text1 = e;
    });
  }

  void setplayer(String te) {
    setState(() {
      playerList[count] = te;

      _text1 = '';
      _controller.clear(); // テキストコントローラをクリアして、入力フィールドをリセット
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(50.0),
      child: SingleChildScrollView(
        //スクロールできるように追加
        child: Form(
          key: _formKey, // フォームキーを設定
          child: Column(
            children: <Widget>[
              Text(
                "$_text1",
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextFormField(
                controller: _controller, // コントローラをテキストフィールドに設定
                enabled: true,
                maxLength: 10,
                style: TextStyle(color: Colors.red),
                obscureText: false,
                maxLines: 1,
                onChanged: _handleText,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '名前を入力してください', // 表示するラベル
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    // 入力欄が空欄だった場合
                    return '名前が入力されていません'; // エラーメッセージ
                  }
                  return null; // エラーがない場合はnullを返す
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // バリデーションの実行
                  if (_formKey.currentState!.validate()) {
                    setplayer(_text1);
                    count++;
                    if (human > count) {
                      // プレイヤーが全員登録されていない場合は何もしない
                    } else {
                      Navigator.of(context).pushNamed("/playing");
                    }
                  }
                },
                child: Text('確定'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class playing extends StatefulWidget {
  String text1 = "";
  List<int> point = [
    0,
    0,
    0,
    0,
  ];
  List<String> pointtx = ["0", "0", "0", "0"];
  @override
  _Ctest createState() => _Ctest();
}

class _Ctest extends State<playing> {
  int count = 0;
  List<int> point = [
    0,
    0,
    0,
    0,
  ];
  List<String> pointtx = ["0", "0", "0", "0"];

  void pointup(int PLnumber) {
    setState(() {
      point[PLnumber] = point[PLnumber] + 1;
      pointtx[PLnumber] = point[PLnumber].toString();
    });
  }

  void pointdown(int PLnumber) {
    setState(() {
      point[PLnumber] = point[PLnumber] - 1;
      pointtx[PLnumber] = point[PLnumber].toString();

      //以下はマイナスを許容しない場合
      //if (point[PLnumber] > 0) { // スコアが0より大きい場合のみ減らす
      //  point[PLnumber] = point[PLnumber] - 1;
      //  pointtx[PLnumber] = point[PLnumber].toString(); // テキスト表示用リストを更新
      //}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('遊ぶ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.grey[200], // 背景色を設定
              child: Text(
                '読み札', // 読み札のテキストを表示、ここを変数に変えれば行ける？
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text('中断'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2, // 2列に配置
                crossAxisSpacing: 20.0, // 列間のスペース
                mainAxisSpacing: 20.0, // 行間のスペース
                children: List.generate(human, (index) {
                  //humanの値に応じて人数を変更
                  return Column(
                    children: [
                      Text(
                        playerList[index],
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          pointup(index);
                        },
                        child: Text(
                          '+',
                          style: TextStyle(
                            fontSize: 20, // フォントサイズを設定
                            fontWeight: FontWeight.bold, // フォントの太さを設定
                          ),
                        ),
                      ),
                      Text(
                        pointtx[index],
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          pointdown(index);
                        },
                        child: Text(
                          '-',
                          style: TextStyle(
                            fontSize: 20, // フォントサイズを設定
                            fontWeight: FontWeight.bold, // フォントの太さを設定
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
