import 'package:tourism_todo_recommender/models/detailed_search_data.dart';

abstract class DetailedSearchRequestListener {
  void launchDetailedSearch(DetailedSearchData searchData);
}