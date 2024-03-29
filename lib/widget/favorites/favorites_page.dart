import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_todo_recommender/bloc/favorites/favorites_bloc.dart';
import 'package:tourism_todo_recommender/bloc/favorites/favorites_event.dart';

import '../../bloc/favorites/favorites_state.dart';
import '../../models/todo.dart';
import '../../repository/tourism_repository.dart';
import '../detail/detail_page.dart';
import '../map/map_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<FavoritesBloc, FavoritesState>(
        listenWhen: (previous, current)
          => current.status == FavoritesStatus.failure,
        listener: (context, state) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('An error occurred while loading your favorite todos'),
              ),
            );
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
    return Card(
        child: ListTile(
          leading: _RatingAverage(item: item),
          title: Text(item.shortDescription),
          subtitle: Text(item.address),
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (_) => BlocProvider.value(
                    value: context.read<FavoritesBloc>(),
                    child: DetailPage(todo: item),
                  ),
                )
            );
          },
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _FavoriteIconButton(item: item),
              _MapIconButton(item: item),
            ],
          ),
        ),
    );
  }
}

class _RatingAverage extends StatelessWidget {
  const _RatingAverage({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Todo item;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.star,
          color: Colors.amber,
        ),
        Text(item.rateStatistics.average.toStringAsPrecision(2)),
      ],
    );
  }
}

class _MapIconButton extends StatelessWidget {
  const _MapIconButton({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Todo item;

  @override
  Widget build(BuildContext context) {
    return IconButton(
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
    );
  }
}

class _FavoriteIconButton extends StatelessWidget {
  const _FavoriteIconButton({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Todo item;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.favorite, color: Colors.red,),
      tooltip: 'Delete todo from favorites',
      onPressed: () => context.read<FavoritesBloc>().add(TodosDeletedFromFavorites(todos: [item])),
    );
  }
}