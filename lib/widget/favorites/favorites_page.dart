import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_todo_recommender/bloc/favorites/favorites_bloc.dart';
import 'package:tourism_todo_recommender/bloc/favorites/favorites_event.dart';

import '../../bloc/favorites/favorites_state.dart';
import '../../models/todo.dart';
import '../detail/detail_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<FavoritesBloc, FavoritesState>(
        listenWhen: (previous, current) =>
        previous.status != current.status,
        listener: (context, state) {
          if (state.status == FavoritesStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('An error occurred while loading your favorite todos'),
                ),
              );
          }
        },
        child: BlocBuilder<FavoritesBloc, FavoritesState>(
          builder: (context, state) {
            if (state.favorites.isEmpty) {
              if (state.status == FavoritesStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state.status != FavoritesStatus.success) {
                return const SizedBox();
              } else {
                return const Center(
                  child: Text(
                    'You don\'t have any favorite todos',
                    style: TextStyle(fontSize: 20),
                  ),
                );
              }
            }

            return Scrollbar(
              child: ListView(
                children: [
                  for (final todo in state.favorites)
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
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => DetailPage(todo: item)
            )
        );
      },
      trailing: IconButton(
        icon: const Icon(Icons.star),
        tooltip: 'Delete todo from favorites',
        onPressed: () => context.read<FavoritesBloc>().add(TodosDeletedFromFavorites(todos: [item])),
      ),
    );
  }
}