import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'main.dart';
import 'MainPage.dart';
import 'Yomifuda.dart';
import 'ImageEditPage.dart';

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

      final editedImageBytes = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageEditPage(originalImage: bytes),
        ),
      );

      if(editedImageBytes != null){
        setState(() {
          _imageBytes = editedImageBytes;

          Cards newCard = Cards(
            Y_Reading: '',
            Y_Image: null,
            E_Org: bytes,
            E_Image: editedImageBytes,
          );
          // 後から修正？
          cardList.add(newCard);
        });

        print('Image added to cardList. Total cards: ${cardList.length}');
      }
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
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}