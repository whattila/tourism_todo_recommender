import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/search/search_bloc.dart';
import '../../bloc/search/search_event.dart';
import '../../bloc/search/search_state.dart';
import '../../data/todo.dart';
import '../../repository/tourism_repository.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(tourismRepository: context.read<TourismRepository>()),
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
          ElevatedButton.icon(
            onPressed: () {
              final value = _textController.value.text;
              _searchBloc.add(SearchLaunched(text: value));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_textController.value.text),
                ),
              );
            },
            icon: const Icon(Icons.search),
            label: const Text("SEARCH"),
          ),
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
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        return _SearchResultItem(item: items[index]);
      },
    );
  }
}

class _SearchResultItem extends StatelessWidget {
  const _SearchResultItem({Key? key, required this.item}) : super(key: key);

  final Todo item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      /*leading: CircleAvatar(
        child: Image.network(item.owner.avatarUrl),
      ),*/
      title: Text(item.shortDescription),
      /*onTap: () async {
        if (await canLaunch(item.htmlUrl)) {
          await launch(item.htmlUrl);
        }
      },*/
    );
  }
}
