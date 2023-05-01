import 'package:equatable/equatable.dart';

import '../../models/comment.dart';
import '../../models/rating.dart';

enum RatingStatus { initial, loading, success, failure }
enum CommentStatus { initial, loading, success, failure }

class DetailState extends Equatable {
  const DetailState({
    this.ratingStatus = RatingStatus.initial,
    this.commentStatus = CommentStatus.initial,
    this.rating = Rating.empty,
    this.comments = const [],
  });

  /// The result of the last server operation with the rating
  final RatingStatus ratingStatus;

  /// The result of the last server operation with comments
  final CommentStatus commentStatus;

  /// The rating the user currently has on this todo
  final Rating rating;

  /// The comments given to this todo.
  final List<Comment> comments;

  DetailState copyWith({RatingStatus? ratingStatus, CommentStatus? commentStatus, Rating? rating, List<Comment>? comments})
    => DetailState(
        ratingStatus: ratingStatus ?? this.ratingStatus,
        commentStatus: commentStatus ?? this.commentStatus,
        rating: rating ?? this.rating,
        comments: comments ?? this.comments,
      );

  @override
  List<Object?> get props => [ratingStatus, commentStatus, rating, comments];
}