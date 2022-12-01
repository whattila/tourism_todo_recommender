import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_todo_recommender/widget/upload/image_item.dart';
import '../../bloc/favorites/favorites_bloc.dart';
import '../../bloc/favorites/favorites_event.dart';
import '../../bloc/favorites/favorites_state.dart';
import '../../models/todo.dart';
import '../image/image_page.dart';
import '../map/map_page.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({Key? key, required this.todo}) : super(key: key);

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        title: const Text('Todo details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                todo.shortDescription,
                style: const TextStyle(
                  fontSize: 50,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    BlocBuilder<FavoritesBloc, FavoritesState>(
                        buildWhen: (previousState, state) =>
                        previousState.isTodoFavorite(todo) != state.isTodoFavorite(todo),
                        builder: (_, state) {
                          final isFavorite = state.isTodoFavorite(todo);
                          return ElevatedButton.icon(
                            icon: isFavorite ? const Icon(Icons.star) : const Icon(Icons.star_border),
                            label: isFavorite ? const Text('Delete from favorites') : const Text('Save to favorites'),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            ),
                            onPressed: () => BlocProvider.of<FavoritesBloc>(context).add(
                                isFavorite ?
                                TodosDeletedFromFavorites(todos: [todo]) :
                                TodosSavedToFavorites(todos: [todo])
                            ),
                          );
                        }
                    ),
                    const SizedBox(width: 8,),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.map),
                      label: const Text('Show on map'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                      ),
                      onPressed: () {
                        if (todo.latitude != null && todo.longitude != null) {
                          Navigator.of(context).push(
                              MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (_) => BlocProvider.value(
                                  value: BlocProvider.of<FavoritesBloc>(context),
                                  child: MapPage(todo: todo),
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
                )
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                todo.uploaderName,
                style: const TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
              child: Text(
                'Address: ${todo.address}',
                style: const TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
              child: Text(
                'Type: ${todo.nature}',
                style: const TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Description:',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
              child: Text(
                todo.detailedDescription,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Images:',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 8),
            _ImageList(todo: todo,),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _ImageList extends StatelessWidget {
  const _ImageList({Key? key, required this.todo}) : super(key: key);

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    if (todo.imageReferences.isEmpty) {
      return const Center(
        child: Text(
          'No images',
          style: TextStyle(fontSize: 20),
        ),
      );
    }
    return Container(
        margin: const EdgeInsets.all(5.0),
        height: 250.0,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: todo.imageReferences.length,
          itemBuilder: (context, index) {
            final imageItem = NetworkImageItem(todo.imageReferences[index]);

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ImagePage(image: imageItem)),
                );
              },
              child: imageItem.createWidget()
            );
          },
          separatorBuilder: (_, __) => const SizedBox(width: 4),
        ),
    );
  }
}