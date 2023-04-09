import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rate_statistics.g.dart';

/// Stores the derived data about the ratings of a [Todo], like the average of ratings.
@JsonSerializable()
class RateStatistics extends Equatable {
  const RateStatistics({
    required this.counter,
    required this.average,
    required this.counterFiveStars,
    required this.counterFourStars,
    required this.counterThreeStars,
    required this.counterTwoStars,
    required this.counterOneStars,
  });

  factory RateStatistics.fromJson(Map<String, dynamic> json) => _$RateStatisticsFromJson(json);

  /// The count of ratings.
  final int counter;

  /// The average of the ratings.
  final double average;

  /// The count of five star ratings
  final int counterFiveStars;

  /// The count of four star ratings
  final int counterFourStars;

  /// The count of three star ratings
  final int counterThreeStars;

  /// The count of two star ratings
  final int counterTwoStars;

  /// The count of one star ratings
  final int counterOneStars;

  /// Empty statistics used at todos no one rated yet.
  static const empty = RateStatistics
    (
      counter: 0,
      average: 0.0,
      counterFiveStars: 0,
      counterFourStars: 0,
      counterThreeStars: 0,
      counterTwoStars: 0,
      counterOneStars: 0
    );

  @override
  List<Object?> get props =>
      [
        counter,
        average,
        counterFiveStars,
        counterFourStars,
        counterThreeStars,
        counterTwoStars,
        counterOneStars
      ];

  // There is no toJson as these values are derived data calculated at the server, so we never serialize them
}