import 'package:flutter/material.dart';

class MapPage extends StatelessWidget{
  const MapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: az ugye nem baj, hogy itt az alap widgeteket használja?
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: const Center(
        child: Text('Map'),
      ),
    );
  }
}