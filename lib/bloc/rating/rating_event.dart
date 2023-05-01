part of 'rating_bloc.dart';

abstract class RatingEvent extends Equatable {
  const RatingEvent();
}

class RatingSubscriptionRequested extends RatingEvent {
  const RatingSubscriptionRequested({required this.todo});

  final Todo todo;

  @override
  List<Object?> get props => [todo];
}

class RatingChanged extends RatingEvent {
  const RatingChanged({required this.rating});

  final Rating rating;

  @override
  List<Object?> get props => [rating];
}
