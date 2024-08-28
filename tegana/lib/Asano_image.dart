import 'package:flutter/material.dart';
import 'dart:ui' as ui;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Composition Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ImageCompositionScreen(),
    );
  }
}

class ImageCompositionScreen extends StatefulWidget {
  @override
  _ImageCompositionScreenState createState() => _ImageCompositionScreenState();
}

class _ImageCompositionScreenState extends State<ImageCompositionScreen> {
  ui.Image? _image1;
  ui.Image? _image2;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final image1 = await _loadImage('images/icon.png');
    final image2 = await _loadImage('images/image4.png');

    setState(() {
      _image1 = image1;
      _image2 = image2;
    });
  }

  Future<ui.Image> _loadImage(String path) async {
    final data = await DefaultAssetBundle.of(context).load(path);
    final list = data.buffer.asUint8List();
    final image = await decodeImageFromList(list);
    return image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Composition Demo'),
      ),
      body: Center(
        child: CustomPaint(
          size: Size(200, 300), // 必要に応じてサイズを調整
          painter: ImageComposerPainter(image1: _image1, image2: _image2),
        ),
      ),
    );
  }
}

class ImageComposerPainter extends CustomPainter {
  final ui.Image? image1;
  final ui.Image? image2;

  ImageComposerPainter({this.image1, this.image2});

  @override
  void paint(Canvas canvas, Size size) {
    if (image1 != null) {
      canvas.drawImageRect(
        image1!,
        Rect.fromLTWH(0, 0, image1!.width.toDouble(), image1!.height.toDouble()),
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint(),
      );
    }

    if (image2 != null) {
      canvas.drawImageRect(
        image2!,
        Rect.fromLTWH(0, 0, image2!.width.toDouble(), image2!.height.toDouble()),
        Rect.fromLTWH((size.width - (image2!.width.toDouble() * 1.5)) / 2, (size.height - (image2!.height.toDouble() * 1.5)) / 2, image2!.width.toDouble(), image2!.height.toDouble()),
        Paint()..blendMode = BlendMode.overlay, // 画像の合成モードを指定
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is ImageComposerPainter) {
      return image1 != oldDelegate.image1 || image2 != oldDelegate.image2;
    }
    return false;
  }
}