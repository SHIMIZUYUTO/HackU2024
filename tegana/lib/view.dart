import 'package:flutter/material.dart';
import 'main.dart'; 

class CardListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('読札・絵札リスト'),
      ),
      body: cardList.isEmpty
          ? Center(child: Text('札がありません'))
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