import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_todo_recommender/bloc/favorites/favorites_bloc.dart';

import '../../bloc/favorites/favorites_event.dart';
import '../../repository/tourism_repository.dart';
import '../home/home_page.dart';

class LoggedInView extends StatelessWidget {
  const LoggedInView({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: LoggedInView());

  @override
  Widget build(BuildContext context) {
    // TODO: May switch to a MultiBlocProvider if more features come in
    return BlocProvider(
      create: (_) => FavoritesBloc(
          tourismRepository: context.read<TourismRepository>()
      )..add(const FavoritesSubscriptionRequested()),
      child: const HomePage(),
    );
  }
}