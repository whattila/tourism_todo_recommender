import 'package:bloc/bloc.dart';

import 'home_state.dart';

/// {@template home_cubit}
/// Business logic for switching tabs
/// {@endtemplate}
class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  /// Emits the state with the selected tab so the widget tree can rebuild itself.
  void setTab(HomeTab tab) => emit(HomeState(tab: tab));
}
