import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class Photo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyHomePage(title: '絵札登録ページ'),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_imageBytes == null)
              Text('No image selected.')
            else
              Column(
                children: [
                  Image.memory(_imageBytes!),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed("/testYomifuda");
                    },
                    child: Text('読み札登録ページへ'),
                  ),
                ],
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getImage,
        child: Icon(Icons.image),
      ),
    );
  }
}