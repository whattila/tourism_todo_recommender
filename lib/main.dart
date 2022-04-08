import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:tourism_todo_recommender/data/mock_data_client.dart';
import 'package:tourism_todo_recommender/repository/tourism_repository.dart';
import 'package:tourism_todo_recommender/widget/app.dart';

// Ez a sok cucc csak a tesztelési időszakra kell?
Future<void> main() {
  return BlocOverrides.runZoned(
        () async {
      WidgetsFlutterBinding.ensureInitialized();
      // TODO: await Firebase.initializeApp();
      final tourismRepository = TourismRepository(dataClient: MockDataClient());
      runApp(App(tourismRepository: tourismRepository));
    },
    blocObserver: AppBlocObserver(),
  );
}

class AppBlocObserver extends BlocObserver{
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print(error);
    super.onError(bloc, error, stackTrace);
  }
}
