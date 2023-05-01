import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/rating.dart';
import '../../models/todo.dart';
import '../../repository/tourism_repository.dart';

part 'rating_event.dart';
part 'rating_state.dart';

class RatingBloc extends Bloc<RatingEvent, RatingState> {
  RatingBloc({
    required TourismRepository tourismRepository,
  })  : _tourismRepository = tourismRepository,
        super(const RatingState()) {
    on<RatingSubscriptionRequested>(_onSubscriptionRequested);
    on<RatingChanged>(_onRatingChanged);
  }

  final TourismRepository _tourismRepository;

  Future<void> _onSubscriptionRequested(RatingSubscriptionRequested event, Emitter<RatingState> emit) async {
    emit(state.copyWith(status: RatingStatus.loading));
    await emit.forEach<Rating>(
      _tourismRepository.getRating(event.todo.id, _tourismRepository.currentUser.id),
      onData: (rating) => state.copyWith(
        status: RatingStatus.success,
        rating: rating,
      ),
      onError: (object, _) => state.copyWith(
          status: RatingStatus.failure,
          errorMessage: object.toString()
      ),
    );
  }

  Future<void> _onRatingChanged(RatingChanged event, Emitter<RatingState> emit) async {
    try {
      emit(state.copyWith(status: RatingStatus.loading));
      final userId = _tourismRepository.currentUser.id;
      final rating = event.rating.copyWith(userId: userId);
      _tourismRepository.addRating(rating);
    } catch (e) {
      state.copyWith(status: RatingStatus.failure, errorMessage: e.toString());
      // to handle errors that are not from the stream
    }
  }
}
