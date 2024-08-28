import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('画像選択と表示'),
        ),
        body: ImagePickerExample(),
      ),
    );
  }
}

class ImagePickerExample extends StatefulWidget {
  @override
  _ImagePickerExampleState createState() => _ImagePickerExampleState();
}

class _ImagePickerExampleState extends State<ImagePickerExample> {
  File? _image;  // 選択した画像を保存する変数
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _image != null
              ? Stack(
                  children: [
                    Image.file(
                      _image!,
                      width: 300,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '丸',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Text('画像が選択されていません'),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _pickImage,
            child: Text('画像を選択'),
          ),
        ],
      ),
    );
  }
}