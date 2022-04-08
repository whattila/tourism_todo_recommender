import 'package:flutter/material.dart';

class SavedPage extends StatelessWidget{
  const SavedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: az ugye nem baj, hogy itt az alap widgeteket használja?
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved'),
      ),
      body: const Center(
        child: Text('Saved'),
      ),
    );
  }
}