import 'package:equatable/equatable.dart';

/// These values represent the tabs available on the ButtomAppBar
enum HomeTab { top, search, favorites, own}

/// {@template home_state}
/// It keeps record of which tab is selected on the ButtomAppBar
/// {@endtemplate}
class HomeState extends Equatable {
  const HomeState({
    this.tab = HomeTab.top,
  });

  /// The selected tab
  final HomeTab tab;

  @override
  List<Object> get props => [tab];

  /// The string representation of the selected tab.
  /// tab can only have the two HomeTab values as it is non-nullable so this function will always return.
  @override
  String toString() {
    switch (tab) {
      case HomeTab.top:
        return 'The 10 highest rated todos';
      case HomeTab.search:
        return 'Search for todos';
      case HomeTab.favorites:
        return 'Your favorite todos';
      case HomeTab.own:
        return 'Your uploaded todos';
    }
  }
}