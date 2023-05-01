import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tourism_todo_recommender/models/comment.dart';

import '../../models/todo.dart';
import '../../repository/tourism_repository.dart';

part 'comment_event.dart';
part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  CommentBloc({
    required TourismRepository tourismRepository,
  })  : _tourismRepository = tourismRepository,
        super(const CommentState()) {
    on<CommentSubscriptionRequested>(_onSubscriptionRequested);
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

  Future<void> _onSubscriptionRequested(CommentSubscriptionRequested event, Emitter<CommentState> emit) async {
    emit(state.copyWith(status: CommentStatus.loading));
    await emit.forEach<List<Comment>>(
      _tourismRepository.getTodoComments(event.todo),
      onData: (comments) => state.copyWith(
          status: CommentStatus.success,
          comments: comments
      ),
      onError: (object, _) => state.copyWith(
        status: CommentStatus.failure,
      ),
    );
  }

  Future<void> _onCommentAdded(CommentAdded event, Emitter<CommentState> emit) async {
    try {
      emit(state.copyWith(status: CommentStatus.loading));
      final comment = Comment(
          text: event.commentText,
          date: DateTime.now(),
          userName: _tourismRepository.currentUser.email!,
          todoId: event.todo.id
      );
      await _tourismRepository.addCommentToTodo(comment);
    } catch (e) {
      state.copyWith(status: CommentStatus.failure);
      // to handle errors that are not from the stream
    }
  }
}
