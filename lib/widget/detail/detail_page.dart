import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rating_summary/rating_summary.dart';
import 'package:tourism_todo_recommender/repository/tourism_repository.dart';
import 'package:tourism_todo_recommender/widget/upload/image_item.dart';
import '../../bloc/detail/detail_bloc.dart';
import '../../bloc/detail/detail_event.dart';
import '../../bloc/detail/detail_state.dart';
import '../../bloc/favorites/favorites_bloc.dart';
import '../../bloc/favorites/favorites_event.dart';
import '../../bloc/favorites/favorites_state.dart';
import '../../models/rating.dart';
import '../../models/todo.dart';
import '../image/image_page.dart';
import '../map/map_page.dart';
import '../../repository/tourism_repository.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({Key? key, required this.todo}) : super(key: key);

  final Todo todo;

  // ha nem működik a hozzáférés a TourismRepositoryhoz,
  // csináljunk egy statikus route függvényt és használjuk azt mindenhol (hol?), mint az UploadPage-nél!
  // de kicserélhetjük a BlocProvider create-nél a contextet _-re

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailBloc(
          tourismRepository: context.read<TourismRepository>()
      )..add(DetailSubscriptionRequested(todo: todo)),
      child: BlocListener<DetailBloc, DetailState>(
        listenWhen: (previous, current) =>
            previous.status != current.status &&
            current.status == DetailStatus.success,
        listener: (context, state) {
          if (state.status == FavoritesStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('An error occurred during the server operation'),
                ),
              );
          }
        },
        child: _DetailView(todo: todo,),
      ),
    );
  }
}

class _DetailView extends StatelessWidget {
  const _DetailView({Key? key, required this.todo}) : super(key: key);

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
            _ShortDescription(todo: todo),
            Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _FavoriteButton(todo: todo),
                    const SizedBox(width: 8,),
                    _MapButton(todo: todo),
                  ],
                )
            ),
            _UploaderName(todo: todo),
            _Address(todo: todo),
            _Nature(todo: todo),
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
            _DetailedDescription(todo: todo),
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
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Rate this todo:',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 8),
            _Rater(todo: todo),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Rating summary:',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 8),
            _RatingStatistics(todo: todo),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _DetailedDescription extends StatelessWidget {
  const _DetailedDescription({
    Key? key,
    required this.todo,
  }) : super(key: key);

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Text(
        todo.detailedDescription,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

class _Nature extends StatelessWidget {
  const _Nature({
    Key? key,
    required this.todo,
  }) : super(key: key);

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Text(
        'Type: ${todo.nature}',
        style: const TextStyle(
          fontSize: 25,
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

class _Address extends StatelessWidget {
  const _Address({
    Key? key,
    required this.todo,
  }) : super(key: key);

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Text(
        'Address: ${todo.address}',
        style: const TextStyle(
          fontSize: 25,
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

class _UploaderName extends StatelessWidget {
  const _UploaderName({
    Key? key,
    required this.todo,
  }) : super(key: key);

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        todo.uploaderName,
        style: const TextStyle(
          fontSize: 30,
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

class _MapButton extends StatelessWidget {
  const _MapButton({
    Key? key,
    required this.todo,
  }) : super(key: key);

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
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
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({Key? key, required this.todo,}) : super(key: key);

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
        buildWhen: (previousState, state) => previousState.isTodoFavorite(todo) != state.isTodoFavorite(todo),
        builder: (_, state) {
          final isFavorite = state.isTodoFavorite(todo);
          return ElevatedButton.icon(
            icon: isFavorite ? const Icon(Icons.favorite) : const Icon(Icons.favorite_border),
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
    );
  }
}

class _ShortDescription extends StatelessWidget {
  const _ShortDescription({
    Key? key,
    required this.todo,
  }) : super(key: key);

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        todo.shortDescription,
        style: const TextStyle(
          fontSize: 50,
          color: Colors.black,
          fontWeight: FontWeight.w400,
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
          itemCount: todo.imageReferences.length,
          itemBuilder: (context, index) {
            final imageItem = NetworkImageItem(todo.imageReferences[index]);
            final imageWidget = imageItem.createWidget();

            return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ImagePage(image: imageItem)),
                  );
                },
                child: imageWidget
            );
          },
          separatorBuilder: (_, __) => const SizedBox(width: 4),
        ),
    );
  }
}

class _Rater extends StatelessWidget {
  const _Rater({Key? key, required this.todo}) : super(key: key);

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailBloc, DetailState>(
        buildWhen: (previous, current) => previous.rating.value != current.rating.value,
        builder: (context, state) =>
            RatingBar.builder(
              // About how to formate exactly, view docs:
              // https://pub.dev/documentation/flutter_rating_bar/latest/flutter_rating_bar/RatingBar/RatingBar.builder.html
              initialRating: state.rating.value.toDouble(),
              itemCount: Rating.maxRatingValue,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                context.read<DetailBloc>().add(RatingChanged(rating: Rating(value: rating.toInt(), todoId: todo.id)));
                // tört értékelés elvileg nem lehet
              },
            )
    );
  }
}

class _RatingStatistics extends StatelessWidget {
  const _RatingStatistics({Key? key, required this.todo,}) : super(key: key);

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return todo.rateStatistics.counter > 0 ?
      RatingSummary(
        counter: todo.rateStatistics.counter,
        average: todo.rateStatistics.average,
        counterFiveStars: todo.rateStatistics.counterFiveStars,
        counterFourStars: todo.rateStatistics.counterFourStars,
        counterThreeStars: todo.rateStatistics.counterThreeStars,
        counterTwoStars: todo.rateStatistics.counterTwoStars,
        counterOneStars: todo.rateStatistics.counterOneStars,
      )
      : const Center(
          child: Text(
            'No ratings yet',
            style: TextStyle(fontSize: 20),
          ),
      );
  }
}