import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget{
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: az ugye nem baj, hogy itt az alap widgeteket használja?
    return const Scaffold(
      body: Center(
        child: Text('Search'),
      ),
    );
  }
}