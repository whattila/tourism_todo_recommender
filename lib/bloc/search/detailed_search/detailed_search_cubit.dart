import 'package:bloc/bloc.dart';
import 'package:tourism_todo_recommender/data/device_services.dart';
import 'package:tourism_todo_recommender/data/geocoder.dart';
import 'package:tourism_todo_recommender/models/detailed_search_data.dart';
import 'package:tourism_todo_recommender/models/geolocation.dart';
import '../../../models/rating.dart';
import 'detailed_search_state.dart';

class DetailedSearchCubit extends Cubit<DetailedSearchState> {
  DetailedSearchCubit(this._listener) : super(const DetailedSearchState.initial());

  static const minRatingAverage = 0.0;
  static const maxRatingAverage = 5.0; // TODO: should convert this from the Rating max somehow...

  final DetailedSearchRequestListener _listener;

  void nearbyOnlyCheckedChanged(bool checked) {
    emit(state.copyWith(isNearbyOnlyChecked: checked));
  }

  void onRatingAverageValuesChanged(double start, double end) {
    emit(
      state.copyWith(minRatingAverageValue: start, maxRatingAverageValue: end),
    );
  }

  Future<void> searchLaunched({
    required String uploaderSearchTerm,
    required String shortDescriptionSearchTerm,
    required String addressSearchTerm,
    required String natureSearchTerm,
    required String detailedDescriptionSearchTerm
  }) async {

    Geolocation? userLocation;
    if (state.isNearbyOnlyChecked) {
      try {
        userLocation = await _listener.getDeviceLocation();
      } on DeviceException catch (e) {
        // if an exception occurs, we leave the location null
        // later we can also do additional stuff here if we wish
      } on LocationException catch (e) {
        // if an exception occurs, we leave the location null
        // later we can also do additional stuff here if we wish
      } catch (_) {
        // if an exception occurs, we leave the location null
        // later we can also do additional stuff here if we wish
      }
    }

    // TODO: I could add a waiting animation while getting the location.

    final DetailedSearchData searchData = DetailedSearchData(
        uploaderSearchTerm: uploaderSearchTerm,
        shortDescriptionSearchTerm: shortDescriptionSearchTerm,
        natureSearchTerm: natureSearchTerm,
        addressSearchTerm: addressSearchTerm,
        detailedDescriptionSearchTerm: detailedDescriptionSearchTerm,
        userLocation: userLocation,
        ratingMinValue: state.minRatingAverageValue,
        ratingMaxValue: state.maxRatingAverageValue
    );

    emit(state.copyWith(isSubmitted: true));
    _listener.launchDetailedSearch(searchData);
  }
}

abstract class DetailedSearchRequestListener {
  void launchDetailedSearch(DetailedSearchData searchData);
  Future<Geolocation> getDeviceLocation();
}