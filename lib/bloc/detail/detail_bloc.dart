import 'package:bloc/bloc.dart';
import 'package:tourism_todo_recommender/bloc/detail/detail_state.dart';

import '../../models/comment.dart';
import '../../models/rating.dart';
import '../../repository/tourism_repository.dart';
import 'detail_event.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  DetailBloc({
    required TourismRepository tourismRepository,
  })  : _tourismRepository = tourismRepository,
        super(const DetailState()) {
          on<DetailSubscriptionRequested>(_onSubscriptionRequested);
          on<RatingChanged>(_onRatingChanged);
          on<CommentAdded>(_onCommentAdded);
        }

  final TourismRepository _tourismRepository;

  // 1 char in UTF-8 is 1 to 4 bytes.
  // We shouldn't run out of the 1 MB/document limit of Cloud Firestore.
  static const commentMaxLength = 200000;

  static String? validateComment(String? value) {
    if (value?.isEmpty ?? true) {
      return 'A comment cannot be empty';
    }
    return null;
  }

  Future<void> _onSubscriptionRequested(DetailSubscriptionRequested event, Emitter<DetailState> emit) async {
    emit(state.copyWith(ratingStatus: RatingStatus.loading, commentStatus: CommentStatus.loading));
    // lehet hogy előfordulhat valami lost update az state-nél
    // de szerintem ez nem okoz akkora problémát, látszik a felületen, és újrapróbálkozással javítható
    await emit.forEach<Rating>(
      _tourismRepository.getRating(event.todo.id, _tourismRepository.currentUser.id),
      onData: (rating) => state.copyWith(
        ratingStatus: RatingStatus.success,
        rating: rating,
      ),
      onError: (object, _) => state.copyWith(
        ratingStatus: RatingStatus.failure,
      ),
    );
    await emit.forEach<List<Comment>>(
      _tourismRepository.getTodoComments(event.todo),
      onData: (comments) => state.copyWith(
        commentStatus: CommentStatus.success,
        comments: comments
      ),
      onError: (object, _) => state.copyWith(
        commentStatus: CommentStatus.failure,
      ),
    );
  }

  Future<void> _onRatingChanged(RatingChanged event, Emitter<DetailState> emit) async {
    try {
      emit(state.copyWith(ratingStatus: RatingStatus.loading));
      final userId = _tourismRepository.currentUser.id;
      final rating = event.rating.copyWith(userId: userId);
      await _tourismRepository.addRating(rating);
    } catch (e) {
      state.copyWith(ratingStatus: RatingStatus.failure);
      // to handle errors that are not from the stream
    }
  }

  Future<void> _onCommentAdded(CommentAdded event, Emitter<DetailState> emit) async {
    try {
      emit(state.copyWith(commentStatus: CommentStatus.loading));
      final comment = Comment(
          text: event.commentText,
          date: DateTime.now(),
          userName: _tourismRepository.currentUser.email!,
          todoId: event.todo.id
      );
      await _tourismRepository.addCommentToTodo(comment);
    } catch (e) {
      state.copyWith(commentStatus: CommentStatus.failure);
      // to handle errors that are not from the stream
    }
  }
}