import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:path_provider/path_provider.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Uint8List? _imageBytes;
  Uint8List? _croppedImageBytes;
  final picker = ImagePicker();
  final _cropController = CropController();
  final TextEditingController _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey _repaintBoundaryKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _textController.addListener(_updateAvatar);
  }

  @override
  void dispose() {
    _textController.removeListener(_updateAvatar);
    _textController.dispose();
    super.dispose();
  }

  void _updateAvatar() {
    setState(() {}); // テキスト変更時に`CircleAvatar`を更新
  }

  Future<void> _getImage() async {
    try {
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _imageBytes = Uint8List.fromList(bytes);
          _croppedImageBytes = null;
        });
        _showCropDialog();
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('画像の選択中にエラーが発生しました: $e')),
      );
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
                  aspectRatio: 2 / 3,
                  onStatusChanged: (status) => print(status),
                  onCropped: (croppedData) {
                    if (!mounted) return;
                    setState(() {
                      _croppedImageBytes = croppedData;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  try {
                    _cropController.crop();
                  } catch (e) {
                    print('Error during cropping: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('画像のクロップ中にエラーが発生しました: $e')),
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

  Future<void> _captureAndSaveImage(BuildContext context) async {
    try {
      RenderRepaintBoundary boundary = _repaintBoundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/captured_image.png';
      final file = File(path);
      await file.writeAsBytes(pngBytes);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image saved to $path')),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    String firstChar = _textController.text.isNotEmpty ? _textController.text[0] : ''; // 最初の1文字を取得

    return Center(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: const StadiumBorder(),
                  side: const BorderSide(color: Colors.green),
                  padding: const EdgeInsets.all(20),
                ),
                child: const Text('戻る'),
              ),
              ElevatedButton(
                onPressed: () => _captureAndSaveImage(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(20),
                ),
                child: const Text('保存'),
              ),
            ],
          ),
          Expanded(
            child: GestureDetector(
              child: InkWell(
                borderRadius: BorderRadius.circular(8.0),
                onTap: _getImage,
                child: RepaintBoundary(
                  key: _repaintBoundaryKey,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green,width: 10),
                          color: Colors.red,
                        ),
                        child: _croppedImageBytes != null
                            ? Image.memory(_croppedImageBytes!)
                            : _imageBytes != null
                                ? Image.memory(_imageBytes!)
                                : const Center(
                                    child: Text(
                                      '画像を選択',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 50),
                                    ),
                                  ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.green,
                          child: Text(
                            firstChar,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            color: Colors.green,
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      print('読み札ボタンが押されました');
                    },
                    child: const Text('読札'),
                  ),
                  TextFormField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'ここに入力',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'テキストが入力されていません';
                      }
                      if (!RegExp(r'^[ぁ-ゖァ-ヶー]*$').hasMatch(value)) {
                        return 'ひらがなまたはカタカナを入力してください';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}