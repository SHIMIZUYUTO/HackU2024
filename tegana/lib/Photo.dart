import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'main.dart';
import 'package:image_picker/image_picker.dart';
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
  final TextEditingController _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();  // フォームのキーを追加

  Future<void> _getImage() async {
    try {
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
                  aspectRatio: 2/3,
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

  void _registerCard() {
    if (_formKey.currentState!.validate()) {
      if (_croppedImageBytes != null && _textController.text.isNotEmpty) {
        final newCard = Cards(
          Y_Reading: _textController.text,
          Y_Image: null,  // 今回は使用しない
          E_Org: _croppedImageBytes,
          E_Image: null,  // 今回は使用しない
        );
        setState(() {
          cardList.add(newCard);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('カードが登録されました')),
        );
        // 入力をクリア
        _textController.clear();
        setState(() {
          _croppedImageBytes = null;
          _imageBytes = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('画像と読み札の両方を入力してください')),
        );
      }
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
                child: InkWell(
                borderRadius: BorderRadius.circular(8.0),
                onTap: _getImage,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 10),
                    color: Colors.red,
                  ),
                    margin: const EdgeInsets.all(20),
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
              ),
            ),
            ),
            Container(
              color: Colors.green,
              padding: const EdgeInsets.all(20),
              child: Form(  // Formウィジェットでラップ
                key: _formKey,  // フォームのキーを指定
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          print('読み札ボタンが押されました');
                        },
                        child: const Text('読札'),
                      ),
                      TextFormField(  // TextFieldをTextFormFieldに変更
                          controller: _textController,
                          decoration: InputDecoration(
                            hintText: 'ここに入力',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {    // 入力欄が空欄だった場合
                              return 'テキストが入力されていません'; // エラーメッセージ
                            }
                            if(!RegExp(r'^[ぁ-ゖァ-ヶー]*$').hasMatch(value)){     // ひらがな、カタカナ以外が入力されている場合
                              return 'ひらがなまたはカタカナを入力してください';  // エラーメッセージ 
                            }
                            return null; // エラーがない場合はnullを返す
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