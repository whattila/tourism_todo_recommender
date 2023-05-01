import 'package:equatable/equatable.dart';

import '../../models/rating.dart';
import '../../models/todo.dart';

abstract class DetailEvent extends Equatable {
  const DetailEvent();
}

class DetailSubscriptionRequested extends DetailEvent {
  const DetailSubscriptionRequested({required this.todo});

  final Todo todo;

  @override
  List<Object?> get props => [todo];
}

class RatingChanged extends DetailEvent {
  const RatingChanged({required this.rating});

  final Rating rating;

  @override
  List<Object?> get props => [rating];
}

class CommentAdded extends DetailEvent {
  const CommentAdded({required this.commentText, required this.todo});

  final String commentText;
  final Todo todo;

  @override
  List<Object?> get props => [commentText, todo];
}