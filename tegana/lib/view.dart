import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
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

  Future<void> printAllImages() async {
    final pdf = pw.Document();

    // 1ページあたりの画像数
    final int imagesPerPage = 6;
    
    for (var i = 0; i < cardList.length; i += imagesPerPage) {
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(
                imagesPerPage,
                (index) {
                  final itemIndex = i + index;
                  if (itemIndex < cardList.length && cardList[itemIndex].E_Org != null) {
                    return pw.Column(
                      children: [
                        pw.Container(
                          width: 150,
                          height: 200,
                          child: pw.Image(pw.MemoryImage(cardList[itemIndex].E_Org!), fit: pw.BoxFit.contain),
                        ),
                        pw.SizedBox(height: 5),
//                        pw.Text(cardList[itemIndex].Y_Reading),
                      ],
                    );
                  } else {
                    return pw.Container();
                  }
                },
              ),
            );
          },
        ),
      );
    }

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
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
        actions: [
          IconButton(
            icon: Icon(Icons.print),
            onPressed: () {
              printAllImages();
            },
          ),
        ],
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