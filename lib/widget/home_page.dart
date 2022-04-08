import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_todo_recommender/widget/saved_page.dart';
import 'package:tourism_todo_recommender/widget/search_page.dart';
import 'package:tourism_todo_recommender/widget/upload_todo_page.dart';

import '../bloc/home_cubit.dart';
import '../bloc/home_state.dart';
import 'map_page.dart';

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
    final selectedTab = context.select((HomeCubit cubit) => cubit.state.tab);

    return Scaffold(
      body: IndexedStack(
        index: selectedTab.index,
        children: const [SearchPage(), SavedPage(), MapPage()],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        key: const Key('homeView_uploadTodo_floatingActionButton'),
        // TODO: may need to be modified (add route method to UploadTodoPage)
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const UploadTodoPage())),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _HomeTabButton(
              groupValue: selectedTab,
              value: HomeTab.search,
              icon: const Icon(Icons.explore),
            ),
            _HomeTabButton(
              groupValue: selectedTab,
              value: HomeTab.saved,
              icon: const Icon(Icons.favorite),
            ),
            _HomeTabButton(
              groupValue: selectedTab,
              value: HomeTab.map,
              icon: const Icon(Icons.map),
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
      iconSize: 32,
      color:
      groupValue != value ? null : Theme.of(context).colorScheme.secondary,
      icon: icon,
    );
  }
}
