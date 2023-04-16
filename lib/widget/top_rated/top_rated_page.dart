import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_todo_recommender/bloc/favorites/favorites_bloc.dart';
import 'package:tourism_todo_recommender/bloc/favorites/favorites_state.dart';
import '../../bloc/favorites/favorites_event.dart';
import '../../bloc/top_rated/top_rated_bloc.dart';
import '../../models/todo.dart';
import '../../repository/tourism_repository.dart';
import '../detail/detail_page.dart';
import '../map/map_page.dart';
import '../upload/upload_page.dart';

class TopRatedPage extends StatelessWidget {
  const TopRatedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TopRatedBloc(
        tourismRepository: context.read<TourismRepository>(),
      )..add(const TopRatedSubscriptionRequested()),
      child: const TopRatedView(),
    );
  }
}

class TopRatedView extends StatelessWidget {
  const TopRatedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<TopRatedBloc, TopRatedState>(
        listenWhen: (previous, current)
          => current.status == TopRatedStatus.failure,
        listener: (context, state) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('An error occurred while loading the top rated todos'),
              ),
            );
        },
        child: BlocBuilder<TopRatedBloc, TopRatedState>(
          builder: (context, state) {
            if (state.todos.isEmpty) {
              if (state.status == TopRatedStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state.status != TopRatedStatus.success) {
                return const SizedBox();
              } else {
                return const Center(
                  child: Text(
                    'There are no todos (with ratings)',
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
            _FavoriteButton(item: item),
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

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Todo item;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
        buildWhen: (previousState, state) =>
        previousState.isTodoFavorite(item) != state.isTodoFavorite(item),
        builder: (context, state) {
          final isFavorite = state.isTodoFavorite(item);
          return IconButton(
            icon: isFavorite ?
            const Icon(
              Icons.favorite,
              color: Colors.red,
            )
                : const Icon(
              Icons.favorite_border,
              color: Colors.red,
            )
            ,
            tooltip: isFavorite ? 'Delete from favorites' : 'Save to favorites',
            onPressed: () => context.read<FavoritesBloc>().add(
                isFavorite ?
                TodosDeletedFromFavorites(todos: [item]) :
                TodosSavedToFavorites(todos: [item])
            ),
          );
        }
    );
  }
}