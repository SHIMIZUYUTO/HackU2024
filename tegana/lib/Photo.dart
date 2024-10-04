import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart'; // デバイスのギャラリーやcameraから画像を選択するためのプラグイン
import 'package:crop_your_image/crop_your_image.dart';
import 'package:image/image.dart' as img;
import 'main.dart';

class Photo extends StatelessWidget {
  const Photo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MyHomePage(title: '絵札・読札登録ページ');
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

  // ImagePicker: デバイスのギャラリーから画像を選択するためのプラグイン
  final picker = ImagePicker();

  // CropController: クロップ操作を制御する
  final _cropController = CropController();
  final TextEditingController _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey _repaintBoundaryKey = GlobalKey();
  bool _isLoading = false;

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

  // 画像選択機能
  Future<void> _getImage() async {
    try {
      // pickImage：デバイスのギャラリーから画像を選択
      // ImageSource.gallery：画像の取得元をギャラリーに指定
      // await：非同期処理を使用して、ユーザが画像を選択するのを待つ
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);

      // pickedFile != null：(画像が選択された場合)画像をバイトデータとして読み込む
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();

        // setState：_imageBytesを更新し、UIを再描画する
        // _croppedImageBytesをリセットして、新しい画像のクロップを準備する
        setState(() {
          _imageBytes = Uint8List.fromList(bytes);
          _croppedImageBytes = null;
        });

        // クロップダイアログを表示する
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

  // 画像クロップ機能
  void _showCropDialog() {
    // クロップダイアログを表示する
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Column(
            children: [
              Expanded(
                // Crop：画像のクロップ機能を提供
                // image：クロップする画像データ(_imageBytes)を指定
                // controller：クロップ操作を制御するためのコントローラを指定
                // aspectRatio：クロップする画像の長辺と短辺の比率を指定
                // onStatusChanged：クロップ状態の変更をコンソールに出力
                // onCropped：クロップされた画像データを_resizeAndSetImage()に渡す
                child: Crop(
                  image: _imageBytes!,
                  controller: _cropController,
                  aspectRatio: 2 / 3,
                  onStatusChanged: (status) => print(status),
                  onCropped: (croppedData) {
                    if (!mounted) return;
                    _resizeAndSetImage(croppedData);
                    Navigator.of(context).pop();
                  },
                ),
              ),

              // クロップボタン
              // _cropController.crop():クロップ処理を開始
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
      RenderRepaintBoundary boundary = _repaintBoundaryKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      print('Error capturing image: $e');
      return null;
    }
  }

  // 画像をリサイズ
  void _resizeAndSetImage(Uint8List croppedData) {
    // imageライブラリのdecodeImage()関数を利用して、バイトデータからImageオブジェクトを生成
    // この操作によって、画像データを操作可能な形式に変換する
    img.Image? image = img.decodeImage(croppedData);

    // imageが正常にデコードされた場合、copyResize()関数を利用して画像をリサイズ
    if (image != null) {
      img.Image resizedImage = img.copyResize(image, width: 450, height: 675);
      
      // リサイズされた画像をJPEG方式にエンコードする
      // エンコードされたデータをUint8Listとして_croppedImageBytesに設定
      setState(() {
        _croppedImageBytes = Uint8List.fromList(img.encodeJpg(resizedImage));
      });
    } else {
      print('Failed to decode image');
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
            _isLoading = true;
          });
          // (登録したとき2秒遅延)
          await Future.delayed(Duration(seconds: 2));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('カードが登録されました')),
          );
          _textController.clear();
          setState(() {
            _croppedImageBytes = null;
            _imageBytes = null;
            _isLoading = false;
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
    String firstChar =
        _textController.text.isNotEmpty ? _textController.text[0] : '';

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
                    padding: const EdgeInsets.all(25),
                  ),
                  child: const Text('戻る'),
                ),
                ElevatedButton(
                  onPressed: _registerCard,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.all(25),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text('登録'),
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
                          border: Border.all(color: Colors.green, width: 10),
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
