import 'package:equatable/equatable.dart';

import 'detailed_search_cubit.dart';

class DetailedSearchState extends Equatable {
  final bool isNearbyOnlyChecked;
  final bool isSubmitted; // should be false while we are on this page, and set to true when we are done
  final double minRatingAverageValue;
  final double maxRatingAverageValue;

  const DetailedSearchState(this.isNearbyOnlyChecked, this.isSubmitted, this.minRatingAverageValue, this.maxRatingAverageValue);

  const DetailedSearchState.initial({
    this.isNearbyOnlyChecked = false,
    this.isSubmitted = false,
    this.minRatingAverageValue = DetailedSearchCubit.minRatingAverage,
    this.maxRatingAverageValue = DetailedSearchCubit.maxRatingAverage
  });

  DetailedSearchState copyWith({
    bool? isNearbyOnlyChecked,
    bool? isSubmitted,
    double? minRatingAverageValue,
    double? maxRatingAverageValue})
  {
    return DetailedSearchState(
        isNearbyOnlyChecked ?? this.isNearbyOnlyChecked,
        isSubmitted ?? this.isSubmitted,
        minRatingAverageValue ?? this.minRatingAverageValue,
        maxRatingAverageValue ?? this.maxRatingAverageValue
    );
  }

  @override
  List<Object> get props => [isNearbyOnlyChecked, isSubmitted, minRatingAverageValue, maxRatingAverageValue];
}