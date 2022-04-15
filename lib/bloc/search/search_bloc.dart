import 'package:bloc/bloc.dart';
import 'package:tourism_todo_recommender/bloc/search/search_event.dart';
import 'package:tourism_todo_recommender/bloc/search/search_state.dart';
import '../../repository/tourism_repository.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({required TourismRepository tourismRepository,})
      : _tourismRepository = tourismRepository,
        super(SearchStateEmpty()) {
    on<SearchLaunched>(_onSearchLaunched);
    on<SearchFieldCleared>(_onSearchFieldCleared);
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
}
