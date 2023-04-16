import 'package:bloc/bloc.dart';
import 'package:tourism_todo_recommender/bloc/detail/detail_state.dart';

import '../../models/rating.dart';
import '../../repository/tourism_repository.dart';
import 'detail_event.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  DetailBloc({
    required TourismRepository tourismRepository,
  })  : _tourismRepository = tourismRepository,
        super(const DetailState()) {
          on<DetailSubscriptionRequested>(_onSubscriptionRequested);
          on<RatingChanged>(_onRatingChanged);
        }

  final TourismRepository _tourismRepository;

  Future<void> _onSubscriptionRequested(DetailSubscriptionRequested event, Emitter<DetailState> emit) async {
    emit(state.copyWith(status: DetailStatus.loading));
    await emit.forEach<Rating>(
      _tourismRepository.getRating(event.todo.id, _tourismRepository.currentUser.id),
      onData: (rating) => state.copyWith(
        status: DetailStatus.success,
        rating: rating,
      ),
      onError: (object, _) => state.copyWith(
        status: DetailStatus.failure,
        errorMessage: object.toString()
      ),
    );
  }

  Future<void> _onRatingChanged(RatingChanged event, Emitter<DetailState> emit) async {
    try {
      emit(state.copyWith(status: DetailStatus.loading));
      final userId = _tourismRepository.currentUser.id;
      final rating = event.rating.copyWith(userId: userId);
      _tourismRepository.addRating(rating);
    } catch (e) {
      state.copyWith(status: DetailStatus.failure, errorMessage: e.toString());
      // to handle errors that are not from the stream
    }
  }
}