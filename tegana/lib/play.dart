import 'package:flutter/material.dart';

List<String> playerList = [];
int human = 0;

//こっからテキストボックス
//人数を頑張って渡そうとした
//PL登録
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
      child: Column(
        children: <Widget>[
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              human = 1;
              Navigator.of(context).pushNamed("/inTexts1");
            },
            child: new Text('1'),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              human = 2;
              Navigator.of(context).pushNamed("/inTexts1");
            },
            child: new Text('2'),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              human = 3;
              Navigator.of(context).pushNamed("/inTexts1");
            },
            child: new Text('3'),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              human = 4;
              Navigator.of(context).pushNamed("/inTexts1");
            },
            child: new Text('4'),
          )
        ],
      ),
    );
  }
}

//こっからテキストボックス
//人数を頑張って渡そうとした
class inTexts1 extends StatelessWidget {
  /*2*/
  @override
  Widget build(BuildContext context) {
    /*3*/
    return Scaffold(
        /*4*/
        appBar: AppBar(
          title: Text("Startup Name Generator"),
        ),
        body: ChangeForm());
  }
}

//テキストボックス名前登録の画面
class ChangeForm extends StatefulWidget {
  @override
  _ChangeFormState createState() => _ChangeFormState();
}

int count = 0;

class _ChangeFormState extends State<ChangeForm> {
  String _text1 = '';

  void _handleText(String e) {
    setState(() {
      _text1 = e;
    });
  }

  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: <Widget>[
            Text(
              "$_text1",
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w500),
            ),
            new TextField(
              enabled: true,
              // 入力数
              maxLength: 10,

              style: TextStyle(color: Colors.red),
              obscureText: false,
              maxLines: 1,
              //パスワード
              onChanged: _handleText,
            ),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  playerList.add(_text1);
                  count++;
                  if (human > count) {
                    Navigator.of(context).pushNamed("/inTexts1");
                  } else {
                    Navigator.of(context).pushNamed("/ct");
                  }
                },
                child: new Text('確定'))
          ],
        ));
  }
}

//名前登録のチェック用
class ct extends StatefulWidget {
  String text1 = "";
  @override
  _Ctest createState() => _Ctest();
}

int cunt = 0;

class _Ctest extends State<ct> {
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(50.0),
        child: Column(children: <Widget>[
          Text(
            playerList[cunt],
            style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 30.0,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              cunt++;
              if (human > cunt) {
                Navigator.of(context).pushNamed("/ct");
              } else {
                for (int i = 0; i < human * 2; i++) {
                  Navigator.of(context).pop();
                }
              }
            },
            child: new Text('次の人'),
          )
        ]));
  }
}
