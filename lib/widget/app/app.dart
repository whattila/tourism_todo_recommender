import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/authentication/authentication_bloc.dart';
import '../../bloc/authentication/authentication_state.dart';
import '../../repository/tourism_repository.dart';
import '../authentication/login_page.dart';
import '../logged_in/logged_in_view.dart';

class App extends StatelessWidget {
  const App({Key? key, required this.tourismRepository}) : super(key: key);

  final TourismRepository tourismRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: tourismRepository,
      child: BlocProvider(
        create: (_) => AuthenticationBloc(
          tourismRepository: tourismRepository,
        ),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.orange,
        sliderTheme: const SliderThemeData(
          valueIndicatorColor: Colors.white,
          valueIndicatorTextStyle: TextStyle(fontSize: 20, color: Colors.black)
        )
      ),
      home: FlowBuilder<AuthenticationStatus>(
        state: context.select((AuthenticationBloc bloc) => bloc.state.status),
        onGeneratePages: onGenerateAppViewPages,
      ),
    );
  }
}

List<Page> onGenerateAppViewPages(AuthenticationStatus state, List<Page<dynamic>> pages) {
  switch (state) {
    case AuthenticationStatus.authenticated:
      return [LoggedInView.page()];
    case AuthenticationStatus.unauthenticated:
      return [LoginPage.page()];
  }
}
