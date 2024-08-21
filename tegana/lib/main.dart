import 'package:flutter/material.dart';
import 'dart:typed_data'; // Uint8Listに必要
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() => runApp(MyApp());

// Playerクラス
class Player {
  String name;
  int score;

  Player({
    required this.name,
    this.score = 0
  });
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

List<Player> playerList = [];
List<Card> cardList = [];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => new MainPage(),
        '/testPhoto': (BuildContext context) => new Photo(),
        '/testYomifuda': (BuildContext context) => new Yomifuda()
      },
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Navigator'),
      ),
      body: new Container(
        padding: new EdgeInsets.all(32.0),
        child: new Center(
          child: new Column(
            children: <Widget>[
              Text('Main'),
              ElevatedButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed("/testPhoto"), //遷移先の指定
                child: new Text('絵札登録ページへ'),
              )
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
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

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
                      Navigator.of(context).pushNamed('/testYomifuda');
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