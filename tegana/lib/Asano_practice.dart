import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Form'),
        ),
        body: Center(
          child: ChangeForm(),
        ),
      ),
    );
  }
}

class ChangeForm extends StatefulWidget {
  @override
  _ChangeFormState createState() => _ChangeFormState();
}

class _ChangeFormState extends State<ChangeForm> {
  int _count = 0;

  void _handlePressed() {
    setState(() {
      _count++;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Stack(
              alignment: AlignmentDirectional.topEnd,
              fit: StackFit.passthrough,
              children: <Widget>[
                Container(
                  width: 200,
                  height: 200,
                  color: Colors.red,
                ),
                Positioned(
                  left: 1000,
                  top: 50,
                  child: Container(
                    width: 60,
                    height: 60,
                    color: Colors.blue,
                    child: Text(
                      'き',
                      style: TextStyle(color: Colors.white, fontSize: 50),
                      textAlign: TextAlign.center,
                    )
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
