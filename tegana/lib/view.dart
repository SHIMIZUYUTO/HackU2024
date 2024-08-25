import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'main.dart';

class CardListPage extends StatefulWidget {
  @override
  _CardListPageState createState() => _CardListPageState();
}

class _CardListPageState extends State<CardListPage> {
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    initTts();
  }

  Future<void> initTts() async {
    await flutterTts.setLanguage("ja-JP");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
  }

  Future<void> speak(String text) async {
    await flutterTts.speak(text);
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('カードリスト'),
      ),
      body: cardList.isEmpty
          ? Center(child: Text('カードがありません'))
          : ListView.builder(
              itemCount: cardList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: cardList[index].E_Org != null
                        ? Image.memory(
                            cardList[index].E_Org!,
                            width: 50,
                            height: 75,
                            fit: BoxFit.cover,
                          )
                        : Icon(Icons.image_not_supported),
                    title: Text(cardList[index].Y_Reading),
                    onTap: () {
                      speak(cardList[index].Y_Reading);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(cardList[index].Y_Reading),
                            content: cardList[index].E_Org != null
                                ? Image.memory(cardList[index].E_Org!)
                                : Text('画像がありません'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('閉じる'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('読み上げ'),
                                onPressed: () {
                                  speak(cardList[index].Y_Reading);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}