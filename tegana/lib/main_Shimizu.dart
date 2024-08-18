import 'package:flutter/material.dart';
<<<<<<< HEAD
    
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
=======

void main() => runApp(MyApp()); /*1*/

class MyApp extends StatelessWidget {
  /*2*/
  @override
  Widget build(BuildContext context) {
    /*3*/
    return MaterialApp(
      /*4*/
      title: 'Welcome to Flutter',
      home: Scaffold(
        /*5*/
        appBar: AppBar(
          /*6*/
          title: Text('Welcome to Flutter'),
        ),
        body: Center(
          /*7*/
          child: Text('こんにちは魔装士'),
>>>>>>> 5085497f5a773d9cf5d4924b500548989674e722
        ),
      ),
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> 5085497f5a773d9cf5d4924b500548989674e722
