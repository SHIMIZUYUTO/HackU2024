import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('かるためーかー（Shimizu）'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamed("/testPhoto"),
                child: const Text('遊ぶ',style: TextStyle(fontSize: 20,color: Colors.black87)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen[200],
                  minimumSize: const Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                )
              ),
              const SizedBox(height: 80),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamed("/testPhoto"),
                child: const Text('札を登録する',style: TextStyle(fontSize: 20,color: Colors.black87)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow[200],
                  minimumSize: const Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                )      
              ),
              const SizedBox(height: 80),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamed("/testYomifuda"),
                child: const Text('札を見る',style: TextStyle(fontSize: 20,color: Colors.black87)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue[200],
                  minimumSize: const Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}