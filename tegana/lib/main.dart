import 'package:flutter/material.dart';
import 'dart:typed_data'; // Uint8Listに必要
import 'package:image_picker/image_picker.dart';

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
//        '/subpage2': (BuildContext context) => new test()
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
                child: new Text('Photoページへ'),
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

      ElevatedButton(
        onPressed: () =>
          Navigator.of(context).pushNamed("/testPhoto"), //遷移先の指定
          child: new Text('Photoページへ'),
      );

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
        child: _imageBytes == null 
            ? Text('No image selected.') 
            : Image.memory(_imageBytes!),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getImage,
        child: Icon(Icons.image),
      ),
    );
  }
}