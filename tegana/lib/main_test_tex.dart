import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => new MainPage(),
        '/subpage': (BuildContext context) => new SubPage()
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
              RaisedButton(
                onPressed: () => Navigator.of(context).pushNamed("/subpage"),
                child: new Text('Subページへ'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SubPage extends StatelessWidget {
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
              Text('Sub'),
              RaisedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: new Text('戻る'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
