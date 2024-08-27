import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'main.dart';

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
    setState(() {});
  }

  Future<void> _getImage() async {
    try {
      final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

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

  Future<Uint8List?> _captureImage() async {
    try {
      RenderRepaintBoundary boundary = _repaintBoundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      print('Error capturing image: $e');
      return null;
    }
  }

  void _registerCard() async {
    if (_formKey.currentState!.validate()) {
      if (_croppedImageBytes != null && _textController.text.isNotEmpty) {
        Uint8List? capturedImage = await _captureImage();
        if (capturedImage != null) {
          final newCard = Cards(
            Y_Reading: _textController.text,
            Y_Image: null,
            E_Org: capturedImage, // 頭文字や枠線を含めてキャプチャしたものを保存
            E_Image: null,
          );
          setState(() {
            cardList.add(newCard);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('カードが登録されました')),
          );
          _textController.clear();
          setState(() {
            _croppedImageBytes = null;
            _imageBytes = null;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('画像のキャプチャに失敗しました')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('画像と読み札の両方を入力してください')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String firstChar = _textController.text.isNotEmpty ? _textController.text[0] : '';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
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
                  onPressed: _registerCard,
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
            Expanded(
              child: GestureDetector(
                onTap: _getImage,
                child: RepaintBoundary(
                  key: _repaintBoundaryKey,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border.all(width: 10),
                          color: Colors.red,
                        ),
                        child: _croppedImageBytes != null
                            ? Image.memory(_croppedImageBytes!)
                            : _imageBytes != null
                                ? Image.memory(_imageBytes!)
                                : const Center(
                                    child: Text(
                                      '画像を選択',
                                      style: TextStyle(color: Colors.white, fontSize: 50),
                                    ),
                                  ),
                      ),
                      Positioned(
                        top: 30,
                        right: 30,
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

            // 読み札入力部分
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
                      child: const Text('読み札'),
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
      ),
    );
  }
}