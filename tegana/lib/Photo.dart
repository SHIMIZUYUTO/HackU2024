import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:crop_your_image/crop_your_image.dart';

class Photo extends StatelessWidget {
  const Photo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MyHomePage(title: '絵札登録ページ');
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Uint8List? _imageBytes;
  Uint8List? _croppedImageBytes;
  final picker = ImagePicker();
  final _cropController = CropController();

  Future<void> _getImage() async {
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = Uint8List.fromList(bytes);
        _croppedImageBytes = null; // リセット
      });
      _showCropDialog();
    } else {
      print('No image selected.');
    }
  }

  void _showCropDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Column(
            children: [
              Expanded(
                child: Crop(
                  image: _imageBytes!,
                  controller: _cropController,
                  aspectRatio: 2/3,
                  onStatusChanged: (status) {
                    if (status == CropStatus.ready) {
                      // クロップの準備ができたときの処理
                      print('Crop is ready');
                    }
                  },
                  onCropped: (croppedData) async {
                    try {
                      final compressedData = await FlutterImageCompress.compressWithList(
                        croppedData,
                        minWidth: 200,
                        minHeight: 300,
                      );
                      setState(() {
                        _croppedImageBytes = Uint8List.fromList(compressedData);
                      });
                      Navigator.of(context).pop();
                    } catch (e,stackTrace) {
                      print('Error during image processing: $e');
                      print('Stack trace: $stackTrace');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('画像の処理中にエラーが発生しました')),
                      );
                    }
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  try {
                    _cropController.crop();
                  } catch (e,stackTrace) {
                    print('Error during cropping: $e');
                    print('Stack trace: $stackTrace');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('画像のクロップ中にエラーが発生しました')),
                    );
                  }
                },
                child: const Text('Crop'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            // 上部のボタン配置（戻る・登録）
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // 戻るボタン
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                  ),
                  child: const Text('戻る'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // 登録ボタンのアクション
                    print('登録ボタンが押されました');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                  ),
                  child: const Text('登録'),
                ),
              ],
            ),
            // 画像選択エリア
            Expanded(
              child: GestureDetector(
                onTap: _getImage,
                child: Container(
                  color: Colors.red,
                  margin: const EdgeInsets.all(20),
                  child: _croppedImageBytes != null
                      ? Image.memory(_croppedImageBytes!)
                      : _imageBytes != null
                          ? Image.memory(_imageBytes!)
                          : const Center(
                              child: Text(
                                '画像を選択',
                                style: TextStyle(color: Colors.white, fontSize: 20),
                              ),
                            ),
                ),
              ),
            ),
            // 下部の読み札とテキスト入力エリア
            Container(
              color: Colors.green,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // 読み札ボタンのアクション
                      print('読み札ボタンが押されました');
                    },
                    child: const Text('読札'),
                  ),
                  const TextField(
                    decoration: InputDecoration(
                      hintText: 'ここに入力',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}