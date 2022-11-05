import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../upload/image_item.dart';

class ImagePage extends StatelessWidget {
  const ImagePage({Key? key, required this.image, this.modifiable = false}) : super(key: key);

  final ImageItem image;
  final bool modifiable;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image in detail'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          AspectRatio(
            aspectRatio: 1,
            child: SizedBox(
              width: double.infinity,
              child: image.createWidget()
            ),
          ),
          if (modifiable)
            Container(
              margin: const EdgeInsets.all(20.0),
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context, true),
                  icon: const Icon(Icons.delete),
                  label: const Text("DELETE IMAGE"),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.deepOrange),
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}