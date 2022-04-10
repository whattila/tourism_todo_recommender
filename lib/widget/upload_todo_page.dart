import 'package:flutter/material.dart';

class UploadTodoPage extends StatelessWidget {
  const UploadTodoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: az ugye nem baj, hogy itt az alap widgeteket használja?
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload'),
      ),
      body: const Center(
        child: Text('Upload'),
      ),
    );
  }
}