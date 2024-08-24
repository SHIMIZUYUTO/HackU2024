import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tegana/ImageEditPage.dart';
import 'dart:typed_data'; // Uint8Listに必要
import 'MainPage.dart';
import 'Photo.dart';
import 'Yomifuda.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:http/http.dart' as http;
final _controller = CropController();

Future<Uint8List> loadImageFromNetwork(String url) async{
  final response = await http.get(Uri.parse(url));
  if(response.statusCode == 200){
    return response.bodyBytes;
  } else {
    throw Exception('Failed');
  }
  Uint8List imageBytes = await loadImageFromNetwork('https://img.gamewith.jp/img/6ed5f1964573e9f4a15b4ca90eb4e3fe.jpg');
  @override
  Widget build(BuildContext context) {
    return Crop(
      image:imageBytes,
      controller: _controller,
      onCropped: (image) {
      // 切り抜き後の画像を使った処理
    },
  );
}
}