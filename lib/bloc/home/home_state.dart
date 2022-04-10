import 'package:equatable/equatable.dart';

/// These values represent the tabs available on the ButtomAppBar
enum HomeTab {search, saved, map}

/// {@template home_state}
/// It keeps record of which tab is selected on the ButtomAppBar
/// {@endtemplate}
class HomeState extends Equatable {
  const HomeState({
    this.tab = HomeTab.search,
  });

  /// The selected tab
  final HomeTab tab;

  @override
  List<Object> get props => [tab];
}