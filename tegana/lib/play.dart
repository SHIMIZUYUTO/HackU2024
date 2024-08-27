import 'package:flutter/material.dart';

List<String> playerList = [
  "NOplayer",
  "NOplayer ",
  " NOplayer",
  "NOplayer ",
  " NOplayer"
];
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

  void setplayer(String te) {
    setState(() {
      playerList[count] = te;
      _text1 = '';
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
                  setplayer(_text1);
                  count++;
                  if (human > count) {
                  } else {
                    Navigator.of(context).pushNamed("/playing");
                  }
                },
                child: new Text('確定'))
          ],
        ));
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
    });
  }

  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(50.0),
        child: Column(children: <Widget>[
          Text(
            playerList[0],
            style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 30.0,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                pointup(0);
              },
              child: new Text('+')),
          Text(
            pointtx[0],
            style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 30.0,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                pointdown(0);
              },
              child: new Text("-")),
          //2
          Text(
            playerList[1],
            style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 30.0,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                pointup(1);
              },
              child: new Text('+')),
          Text(
            pointtx[1],
            style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 30.0,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                pointdown(1);
              },
              child: new Text("-")),
          //3
          Text(
            playerList[2],
            style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 30.0,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                pointup(2);
              },
              child: new Text('+')),
          Text(
            pointtx[2],
            style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 30.0,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                pointdown(2);
              },
              child: new Text("-")),
          //4
          Text(
            playerList[3],
            style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 30.0,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                pointup(3);
              },
              child: new Text('+')),
          Text(
            pointtx[3],
            style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 30.0,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                pointdown(3);
              },
              child: new Text("-")),
        ]));
  }
}
