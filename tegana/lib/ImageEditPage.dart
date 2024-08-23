import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';
import 'dart:math' as math;

class ImageEditPage extends StatefulWidget {
  final Uint8List originalImage;

  ImageEditPage({required this.originalImage});

  @override
  _ImageEditPageState createState() => _ImageEditPageState();
}

class _ImageEditPageState extends State<ImageEditPage> {
  late img.Image _image;
  double _scale = 1.0;
  double _rotation = 0.0;

  @override
  void initState() {
    super.initState();
    _image = img.decodeImage(widget.originalImage)!;
  }

  void _applyChanges() {
    setState(() {
      _image = img.copyResize(_image, width: (_image.width * _scale).round());

      double rotationInRadians = _rotation * (math.pi / 180);
      _image = img.copyRotate(_image, angle: rotationInRadians);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Image')),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Image.memory(img.encodePng(_image)),
            ),
          ),
          Slider(
            value: _scale,
            min: 0.5,
            max: 2.0,
            onChanged: (value) {
              setState(() {
                _scale = value;
              });
            },
            onChangeEnd: (_) => _applyChanges(),
          ),
          Slider(
            value: _rotation,
            min: 0,
            max: 360,
            onChanged: (value) {
              setState(() {
                _rotation = value;
              });
            },
            onChangeEnd: (_) => _applyChanges(),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, img.encodePng(_image));
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}