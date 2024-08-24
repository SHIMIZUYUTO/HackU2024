import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

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
      
      // 画像を圧縮して200x300にリサイズ
      final result = await FlutterImageCompress.compressWithList(
        bytes,
        minWidth: 200,
        minHeight: 300,
      );

      setState(() {
        _imageBytes = Uint8List.fromList(result);
      });
      print('Image selected and resized. Size: ${result.length} bytes');
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
          children: <Widget>[
            // 上部のボタン配置（戻る・登録）
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // 戻るボタン
                  },
                  child: Text('戻る'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // 登録ボタンのアクション
                    print('登録ボタンが押されました');
                  },
                  child: Text('登録'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                  ),
                ),
              ],
            ),
            // 画像選択エリア
            Expanded(
              child: GestureDetector(
                onTap: _getImage,
                child: Container(
                  color: Colors.red,
                  margin: EdgeInsets.all(20),
                  child: _imageBytes == null
                      ? Center(
                          child: Text(
                            '画像を選択',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        )
                      : Image.memory(_imageBytes!),
                ),
              ),
            ),
            // 下部の読み札とテキスト入力エリア
            Container(
              color: Colors.green,
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // 読み札ボタンのアクション
                      print('読み札ボタンが押されました');
                    },
                    child: Text('読札'),
                  ),
                  TextField(
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