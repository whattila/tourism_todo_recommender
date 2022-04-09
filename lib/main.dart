import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tourism_todo_recommender/data/firebase_authenticator.dart';
import 'package:tourism_todo_recommender/data/mock_data_client.dart';
import 'package:tourism_todo_recommender/repository/tourism_repository.dart';
import 'package:tourism_todo_recommender/widget/app.dart';

import 'firebase_options.dart';

// Ez a sok cucc csak a tesztelési időszakra kell?
Future<void> main() {
  return BlocOverrides.runZoned(
        () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      final tourismRepository = TourismRepository(
          authenticator: FirebaseAuthenticator(),
          dataClient: MockDataClient()
      );
      await tourismRepository.user.first; // ez biztos kell?
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
