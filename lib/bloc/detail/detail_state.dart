import 'package:equatable/equatable.dart';

import '../../models/rating.dart';

enum DetailStatus { initial, loading, success, failure }

class DetailState extends Equatable {
  const DetailState({
    this.status = DetailStatus.initial,
    this.rating = Rating.empty
  });

  /// The result of the last call to the server
  final DetailStatus status;

  /// The rating the user currently has on this todo
  final Rating rating;

  DetailState copyWith({DetailStatus? status, Rating? rating})
    => DetailState(status: status ?? this.status, rating: rating ?? this.rating);

  @override
  List<Object?> get props => [status, rating];
}