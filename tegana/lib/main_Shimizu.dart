import 'package:flutter/material.dart';
    
void main() => runApp(MyApp()); /*1*/
    
class MyApp extends StatelessWidget {/*2*/
  @override
  Widget build(BuildContext context) { /*3*/
    return MaterialApp(  /*4*/
      title: 'Welcome to Flutter',
      home: Scaffold( /*5*/
        appBar: AppBar( /*6*/
          title: Text('Welcome to Flutter'),
        ),
        body: Center( /*7*/
          child: Text('こんにちは'),
        ),
      ),
    );
  }
}