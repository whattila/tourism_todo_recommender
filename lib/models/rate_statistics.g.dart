// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rate_statistics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RateStatistics _$RateStatisticsFromJson(Map<String, dynamic> json) =>
    RateStatistics(
      counter: json['counter'] as int,
      average: (json['average'] as num).toDouble(),
      counterFiveStars: json['counterFiveStars'] as int,
      counterFourStars: json['counterFourStars'] as int,
      counterThreeStars: json['counterThreeStars'] as int,
      counterTwoStars: json['counterTwoStars'] as int,
      counterOneStars: json['counterOneStars'] as int,
    );

