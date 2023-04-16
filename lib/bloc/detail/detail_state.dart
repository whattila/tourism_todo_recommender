import 'package:equatable/equatable.dart';

import '../../models/rating.dart';

enum DetailStatus { initial, loading, success, failure }

class DetailState extends Equatable {
  const DetailState({
    this.status = DetailStatus.initial,
    this.rating = Rating.empty,
    this.errorMessage = ''
  });

  /// The result of the last call to the server
  final DetailStatus status;

  /// The rating the user currently has on this todo
  final Rating rating;

  /// The description of the error if the last server operation was a failure.
  final String errorMessage;

  DetailState copyWith({DetailStatus? status, Rating? rating, String? errorMessage})
    => DetailState(status: status ?? this.status, rating: rating ?? this.rating, errorMessage: errorMessage ?? this.errorMessage);

  @override
  List<Object?> get props => [status, rating, errorMessage];
}