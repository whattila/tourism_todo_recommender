import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/tourism_repository.dart';
import 'home_page.dart';

class App extends StatelessWidget {
  const App({Key? key, required this.tourismRepository}) : super(key: key);

  final TourismRepository tourismRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: tourismRepository,
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepOrange
      ),
      // TODO: darkTheme, localization?
      // TODO: itt majd az AuthenticationPage jön
      home: const HomePage(),
    );
  }
}
