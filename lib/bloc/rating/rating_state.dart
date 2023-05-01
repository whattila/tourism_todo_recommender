part of 'rating_bloc.dart';

enum RatingStatus { initial, loading, success, failure }

class RatingState extends Equatable {
  const RatingState({
    this.status = RatingStatus.initial,
    this.rating = Rating.empty,
    this.errorMessage = ''
  });

  /// The result of the last call to the server
  final RatingStatus status;

  /// The rating the user currently has on this todo
  final Rating rating;

  /// The description of the error if the last server operation was a failure.
  final String errorMessage;

  RatingState copyWith({RatingStatus? status, Rating? rating, String? errorMessage})
  => RatingState(status: status ?? this.status, rating: rating ?? this.rating, errorMessage: errorMessage ?? this.errorMessage);

  @override
  List<Object?> get props => [status, rating, errorMessage];
}
