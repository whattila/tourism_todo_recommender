import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/favorites/favorites_bloc.dart';
import '../../bloc/favorites/favorites_event.dart';
import '../../bloc/favorites/favorites_state.dart';
import '../../bloc/search/search_bloc.dart';
import '../../bloc/search/search_event.dart';
import '../../bloc/search/search_state.dart';
import '../../models/todo.dart';
import '../../repository/tourism_repository.dart';
import '../detail/detail_page.dart';
import '../map/map_page.dart';
import 'detailed_search/detailed_search_page.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(context.read<TourismRepository>()),
      child: Column(
        children: <Widget>[
          _Searcher(),
          _SearchBody(),
        ],
      ),
    );
  }
}

class _Searcher extends StatefulWidget {
  @override
  State<_Searcher> createState() => _SearcherState();
}

class _SearcherState extends State<_Searcher> {
  final _textController = TextEditingController();
  late SearchBloc _searchBloc;

  @override
  void initState() {
    super.initState();
    _searchBloc = context.read<SearchBloc>();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          const SizedBox(height: 8),
          TextField (
            controller: _textController,
            autocorrect: false,
            decoration: InputDecoration(
              suffixIcon: GestureDetector(
                onTap: _onClearTapped,
                child: const Icon(Icons.clear),
              ),
              border: const OutlineInputBorder(),
              hintText: 'Enter a search term',
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  final value = _textController.value.text;
                  _searchBloc.add(SearchLaunched(text: value));
                },
                icon: const Icon(Icons.search),
                label: const Text("SEARCH"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).push(DetailedSearchPage.route(listener: _searchBloc)),
                child: const Text('DETAILED SEARCH'),
              )
            ]
          )
        ]
    );
  }

  void _onClearTapped() {
    _textController.text = '';
    _searchBloc.add(const SearchFieldCleared());
  }
}

class _SearchBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchStateLoading) {
          return const CircularProgressIndicator();
        }
        if (state is SearchStateError) {
          return Text(state.error);
        }
        if (state is SearchStateSuccess) {
          return state.items.isEmpty
              ? const Expanded( // add this
            child: Align(
                alignment: Alignment.center,
                child: Text(
                  'No results',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                )
            ),
          )
              : Expanded(child: _SearchResults(items: state.items));
        }
        return const Expanded( // add this
          child: Align(
              alignment: Alignment.center,
              child: Text(
                'Here you can search for touristic todos uploaded by others and you',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30),
              )
          ),
        );
      },
    );
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults({Key? key, required this.items}) : super(key: key);

  final List<Todo> items;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView(
        // TODO: we may switch to builder here
        children: [
          for (final todo in items)
            _SearchResultItem(item: todo)
        ],
      ),
    );
  }
}

class _SearchResultItem extends StatelessWidget {
  const _SearchResultItem({Key? key, required this.item}) : super(key: key);

  final Todo item;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
          leading: _RatingAverage(item: item),
          tileColor: Colors.white,
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