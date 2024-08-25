import 'package:flutter/material.dart';
import 'dart:typed_data'; // Uint8Listに必要
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:english_words/english_words.dart';
import 'package:tegana/main_test_tex.dart';

void main() => runApp(MyApp());

// Playerクラス
class Player {
  String name;
  int score;

  Player({required this.name, this.score = 0});
}

// Cardクラス
class Card {
  String Y_Reading;
  Uint8List? Y_Image;
  Uint8List? E_Org;
  Uint8List? E_Image;

  Card({
    required this.Y_Reading,
    required this.Y_Image,
    required this.E_Org,
    required this.E_Image,
  });
}

// リストの宣言
List<String> playerList = [];
List<Card> cardList = [];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => new MainPage(),
        '/testPhoto': (BuildContext context) => new Photo(),
        '/testYomifuda': (BuildContext context) => new Yomifuda(),
        '/inTexts1': (BuildContext context) => new inTexts1(),
        '/inTexts2': (BuildContext context) => new inTexts2(),
        '/inTexts3': (BuildContext context) => new inTexts3(),
        '/inTexts4': (BuildContext context) => new inTexts4(),
        'PL': (BuildContext context) => new PL(),
      },
    );
  }
}

// ここから下はメインページですよ。
class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('かるためーかー（仮）'),
        centerTitle: true,
      ),
      body: new Container(
        padding: new EdgeInsets.all(32.0),
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                  onPressed: () =>
                      // 遷移先は後から実装
                      Navigator.of(context).pushNamed("PL"), //遷移先の指定
                  child: const Text('遊ぶ',
                      style: TextStyle(fontSize: 20, color: Colors.black87)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen[200],
                    minimumSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  )),
              const SizedBox(height: 80), // 余白
              ElevatedButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed("/testPhoto"), //遷移先の指定
                  child: const Text('札を登録する',
                      style: TextStyle(fontSize: 20, color: Colors.black87)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[200],
                    minimumSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  )),
              const SizedBox(height: 80), // 余白
              ElevatedButton(
                  onPressed: () =>
                      // 遷移先は後から実装
                      Navigator.of(context).pushNamed("/testYomifuda"), //遷移先の指定
                  child: const Text('札を見る',
                      style: TextStyle(fontSize: 20, color: Colors.black87)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue[200],
                    minimumSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

// ここから下は写真を登録するプログラムですよ。
class Photo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyHomePage(title: '絵札登録ページ'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Uint8List? _imageBytes;
  final picker = ImagePicker();

  Future<void> _getImage() async {
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_imageBytes == null)
              Text('No image selected.')
            else
              Column(
                children: [
                  Image.memory(_imageBytes!),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // ここに画面遷移のロジックを追加
                      Navigator.of(context).pushNamed("/testYomifuda");
                    },
                    child: Text('読み札登録ページへ'),
                  ),
                ],
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getImage,
        child: Icon(Icons.image),
      ),
    );
  }
}

// ここから下は読み札登録の例ですよ。
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
    await flutterTts.setLanguage("ja-JP"); // 日本語に設定
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
              _speak(_controller.text); // テキストを読み上げ
            },
            child: Text('送信と読み上げ'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: new Text('戻る'),
          )
        ],
      ),
    );
  }
}

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
            onPressed: () => Navigator.of(context).pushNamed("/inTexts1"),
            child: new Text('1'),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pushNamed("/inTexts2"),
            child: new Text('2'),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pushNamed("/inTexts3"),
            child: new Text('3'),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pushNamed("/inTexts4"),
            child: new Text('4'),
          )
        ],
      ),
    );
  }
}
//こっからテキストボックス

class inTexts1 extends StatelessWidget {
  /*2*/
  final int human = 1;
  @override
  Widget build(BuildContext context) {
    /*3*/
    return Scaffold(
        /*4*/
        appBar: AppBar(
          title: Text('Startup Name Generator'),
        ),
        body: ChangeForm());
  }
}

class inTexts2 extends StatelessWidget {
  /*2*/
  final int human = 2;
  @override
  Widget build(BuildContext context) {
    /*3*/
    return Scaffold(
        /*4*/
        appBar: AppBar(
          title: Text('Startup Name Generator'),
        ),
        body: ChangeForm());
  }
}

class inTexts3 extends StatelessWidget {
  /*2*/
  final int human = 3;
  @override
  Widget build(BuildContext context) {
    /*3*/
    return Scaffold(
        /*4*/
        appBar: AppBar(
          title: Text('Startup Name Generator'),
        ),
        body: ChangeForm());
  }
}

class inTexts4 extends StatelessWidget {
  /*2*/
  final int human = 4;
  @override
  Widget build(BuildContext context) {
    /*3*/
    return Scaffold(
        /*4*/
        appBar: AppBar(
          title: Text('Startup Name Generator'),
        ),
        body: ChangeForm());
  }
}

class ChangeForm extends StatefulWidget {
  @override
  _ChangeFormState createState() => _ChangeFormState();
}

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
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: () => playerList.add(_text1), child: new Text('確定')),
          ],
        ));
  }
}