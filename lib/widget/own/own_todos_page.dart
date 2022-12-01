import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_todo_recommender/bloc/favorites/favorites_bloc.dart';
import 'package:tourism_todo_recommender/bloc/favorites/favorites_state.dart';
import '../../bloc/favorites/favorites_event.dart';
import '../../bloc/own/own_todos_bloc.dart';
import '../../bloc/own/own_todos_event.dart';
import '../../bloc/own/own_todos_state.dart';
import '../../models/todo.dart';
import '../../repository/tourism_repository.dart';
import '../map/map_page.dart';
import '../upload/upload_page.dart';

class OwnTodosPage extends StatelessWidget {
  const OwnTodosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OwnTodosBloc(
        tourismRepository: context.read<TourismRepository>(),
      )..add(const OwnTodosSubscriptionRequested()),
      child: const OwnTodosView(),
    );
  }
}

class OwnTodosView extends StatelessWidget {
  const OwnTodosView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<OwnTodosBloc, OwnTodosState>(
        listenWhen: (previous, current) =>
        previous.status != current.status,
        listener: (context, state) {
          if (state.status == OwnTodosStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('An error occurred while loading your uploaded todos'),
                ),
              );
          }
        },
        child: BlocBuilder<OwnTodosBloc, OwnTodosState>(
          builder: (context, state) {
            if (state.todos.isEmpty) {
              if (state.status == OwnTodosStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state.status != OwnTodosStatus.success) {
                return const SizedBox();
              } else {
                return const Center(
                  child: Text(
                    'You have not uploaded any todos yet',
                    style: TextStyle(fontSize: 20),
                  ),
                );
              }
            }

            return Scrollbar(
              child: ListView(
                children: [
                  for (final todo in state.todos)
                    _TodoListTile(item: todo)
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _TodoListTile extends StatelessWidget {
  const _TodoListTile({Key? key, required this.item}) : super(key: key);

  final Todo item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.shortDescription),
      subtitle: Text(item.address),
      onTap: () => Navigator.of(context).push(UploadPage.route(initialTodo: item)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocBuilder<FavoritesBloc, FavoritesState>(
              buildWhen: (previousState, state) =>
              previousState.isTodoFavorite(item) != state.isTodoFavorite(item),
              builder: (context, state) {
                final isFavorite = state.isTodoFavorite(item);
                return IconButton(
                  icon: isFavorite ? const Icon(Icons.star) : const Icon(Icons.star_border),
                  tooltip: isFavorite ? 'Delete from favorites' : 'Save to favorites',
                  onPressed: () => context.read<FavoritesBloc>().add(
                      isFavorite ?
                      TodosDeletedFromFavorites(todos: [item]) :
                      TodosSavedToFavorites(todos: [item])
                  ),
                );
              }
          ),
          IconButton(
            icon: const Icon(Icons.map),
            tooltip: 'Show on map',
            onPressed: () {
              if (item.latitude != null && item.longitude != null) {
                Navigator.of(context).push(
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (_) => BlocProvider.value(
                        value: context.read<FavoritesBloc>(),
                        child: MapPage(todo: item),
                      ),
                    )
                );
              }
              else {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(content: Text('This todo does not have valid coordinates')),
                  );
              }
            },
          ),
        ],
      ),
    );
  }
}