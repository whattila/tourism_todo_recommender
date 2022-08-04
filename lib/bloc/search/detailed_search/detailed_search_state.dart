import 'package:equatable/equatable.dart';

class DetailedSearchState extends Equatable {
  final bool isNearbyOnlyChecked;
  final bool isSubmitted; // should be false while we are on this page, and set to true when we are done

  const DetailedSearchState(this.isNearbyOnlyChecked, this.isSubmitted,);

  const DetailedSearchState.initial({this.isNearbyOnlyChecked = false, this.isSubmitted = false,});

  DetailedSearchState copyWith({bool? isNearbyOnlyChecked, bool? isSubmitted}) {
    return DetailedSearchState(
        isNearbyOnlyChecked ?? this.isNearbyOnlyChecked,
        isSubmitted ?? this.isSubmitted,
    );
  }

  @override
  List<Object> get props => [isNearbyOnlyChecked, isSubmitted];
}