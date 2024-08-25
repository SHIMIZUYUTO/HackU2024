import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tegana/ImageEditPage.dart';
import 'dart:typed_data'; // Uint8Listに必要
import 'MainPage.dart';
import 'Photo.dart';
import 'Yomifuda.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image/image.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

final _controller = CropController();

class loadimage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('読み札登録の例'),
      ),
      body: loadImage(),
    );
  }
}

class loadImage extends StatefulWidget {
  @override
  maken createState() => maken();
  TextEditingController _controller = TextEditingController();
}

class maken extends State<loadImage> {
  Uint8List imageBytes = Uint8List(100);
  @override
    Widget build(BuildContext context) {
      return Crop(
        image: imageBytes,
        controller: _controller,
        onCropped: (image) {
          // 切り抜き後の画像を使った処理
        },
      );
    }
}
