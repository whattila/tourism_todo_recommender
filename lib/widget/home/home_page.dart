import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_todo_recommender/widget/favorites/favorites_page.dart';
import 'package:tourism_todo_recommender/widget/top_rated/top_rated_page.dart';
import 'package:tourism_todo_recommender/widget/upload/upload_page.dart';
import '../../bloc/authentication/authentication_bloc.dart';
import '../../bloc/authentication/authentication_event.dart';
import '../../bloc/home/home_cubit.dart';
import '../../bloc/home/home_state.dart';
import '../own/own_todos_page.dart';
import '../search/search_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentState = context.select((HomeCubit cubit) => cubit.state);
    final selectedTab = currentState.tab;
    final appBarTitle = currentState.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        actions: <Widget>[
          IconButton(
            key: const Key('homePage_logout_iconButton'),
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => context.read<AuthenticationBloc>().add(LogoutRequested()),
          )
        ],
      ),
      body: IndexedStack(
        index: selectedTab.index,
        children: const [TopRatedPage(), SearchPage(), FavoritesPage(), OwnTodosPage()],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        key: const Key('homeView_uploadTodo_floatingActionButton'),
        onPressed: () => Navigator.of(context).push(UploadPage.route()),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        child: const Icon(Icons.upload),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _HomeTabButton(
              groupValue: selectedTab,
              value: HomeTab.top,
              icon: const Icon(Icons.star),
            ),
            _HomeTabButton(
              groupValue: selectedTab,
              value: HomeTab.search,
              icon: const Icon(Icons.search),
            ),
            _HomeTabButton(
              groupValue: selectedTab,
              value: HomeTab.favorites,
              icon: const Icon(Icons.favorite),
            ),
            _HomeTabButton(
              groupValue: selectedTab,
              value: HomeTab.own,
              icon: const Icon(Icons.person),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeTabButton extends StatelessWidget {
  const _HomeTabButton({
    Key? key,
    required this.groupValue,
    required this.value,
    required this.icon,
  }) : super(key: key);

  final HomeTab groupValue;
  final HomeTab value;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => context.read<HomeCubit>().setTab(value),
      iconSize: 42,
      color: groupValue != value ? null : Theme.of(context).colorScheme.secondary,
      icon: icon,
    );
  }
}
