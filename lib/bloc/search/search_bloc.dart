import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:tourism_todo_recommender/bloc/search/detailed_search/detailed_search_cubit.dart';
import 'package:tourism_todo_recommender/bloc/search/search_event.dart';
import 'package:tourism_todo_recommender/bloc/search/search_state.dart';
import 'package:tourism_todo_recommender/models/detailed_search_data.dart';
import '../../repository/tourism_repository.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> implements DetailedSearchRequestListener {
  SearchBloc(this._tourismRepository) : super(SearchStateEmpty()) {
    on<SearchLaunched>(_onSearchLaunched);
    on<SearchFieldCleared>(_onSearchFieldCleared);
    on<DetailedSearchLaunched>(_onDetailedSearchLaunched);
  }

  final TourismRepository _tourismRepository;

  void _onSearchFieldCleared(
      SearchFieldCleared event,
      Emitter<SearchState> emit,
      ) {
    emit(SearchStateEmpty());
  }

  void _onSearchLaunched(
      SearchLaunched event,
      Emitter<SearchState> emit,
      ) async {
    final searchTerm = event.text;
    emit(SearchStateLoading());
    try {
      final results = await _tourismRepository.searchTodos(searchTerm);
      emit(SearchStateSuccess(results));
    } catch (error) {
      emit(const SearchStateError('Something went wrong'));
    }
  }

  void _onDetailedSearchLaunched(
      DetailedSearchLaunched event,
      Emitter<SearchState> emit,
      ) async {
    // TODO: switch to SearchStateLoading when actually implementing
    emit(SearchStateEmpty());
  }

  @override
  void launchDetailedSearch(DetailedSearchData searchData) {
    add(DetailedSearchLaunched(searchData: searchData));
  }
}