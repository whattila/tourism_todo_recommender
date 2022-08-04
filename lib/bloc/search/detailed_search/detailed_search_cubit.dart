import 'package:bloc/bloc.dart';
import 'package:tourism_todo_recommender/models/detailed_search_data.dart';
import 'package:tourism_todo_recommender/models/geolocation.dart';
import 'detailed_search_state.dart';

class DetailedSearchCubit extends Cubit<DetailedSearchState>{
  DetailedSearchCubit(this._listener) : super(const DetailedSearchState.initial());

  final DetailedSearchRequestListener _listener;

  void nearbyOnlyCheckedChanged(bool checked) {
    emit(state.copyWith(isNearbyOnlyChecked: checked));
  }

  void searchLaunched({
    required String uploaderSearchTerm,
    required String shortDescriptionSearchTerm,
    required String addressSearchTerm,
    required String natureSearchTerm,
    required String detailedDescriptionSearchTerm
  }) {
    // TODO: the two 0.0s are temporary, swap with real data later!
    final DetailedSearchData searchData = DetailedSearchData(
        uploaderSearchTerm: uploaderSearchTerm,
        shortDescriptionSearchTerm: shortDescriptionSearchTerm,
        natureSearchTerm: natureSearchTerm,
        addressSearchTerm: addressSearchTerm,
        detailedDescriptionSearchTerm: detailedDescriptionSearchTerm,
        userLocation: const Geolocation(longitude: 0.0, latitude: 0.0)
    );

    _listener.launchDetailedSearch(searchData);
    emit(state.copyWith(isSubmitted: true));
  }
}

abstract class DetailedSearchRequestListener {
  void launchDetailedSearch(DetailedSearchData searchData);
}