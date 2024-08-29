import 'package:flutter/material.dart';
import 'main.dart';


class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String _errorMessage = '';

  void _handleButtonClick() {
    if (cardList.isEmpty){
      setState(() {
      _errorMessage = '読み札を登録してください。';
      });
      Text(_errorMessage, style: TextStyle(color: Colors.red, fontSize: 18),);
    } else {
      Navigator.of(context).pushNamed("PL");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen,
      appBar: AppBar(
        title: Text('かるたつくつたるか',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Image.asset('images/icon.png'),
              ),
              const SizedBox(height: 20),
              if (cardList.isEmpty)
              Text(_errorMessage, style: TextStyle(color: Colors.red, fontSize: 18),),
              ElevatedButton(
                  onPressed: _handleButtonClick,
                  //=> Navigator.of(context).pushNamed("PL"),
                  child: const Text('遊ぶ',
                      style: TextStyle(fontSize: 20, color: Colors.black87)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen[200],
                    minimumSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  )),
              const SizedBox(height: 70),
              ElevatedButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed("/testPhoto"),
                  child: const Text('札を登録する',
                      style: TextStyle(fontSize: 20, color: Colors.black87)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[200],
                    minimumSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  )),
              const SizedBox(height: 80),
              ElevatedButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed("/viewCards"),
                  child: const Text('札を見る',
                      style: TextStyle(fontSize: 20, color: Colors.black87)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue[200],
                    minimumSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  )),

            ],
          ),
        ),
      ),
    );
  }
}