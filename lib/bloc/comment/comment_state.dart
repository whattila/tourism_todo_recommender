part of 'comment_bloc.dart';

enum CommentStatus { initial, loading, success, failure }

class CommentState extends Equatable {
  const CommentState({
    this.status = CommentStatus.initial,
    this.comments = const [],
    this.errorMessage = ""
  });

  /// The result of the last server operation.
  final CommentStatus status;

  /// The comments given to this todo.
  final List<Comment> comments;

  /// The description of the error if the last server operation was a failure.
  final String errorMessage;

  CommentState copyWith({CommentStatus? status, List<Comment>? comments, String? errorMessage})
  => CommentState(
    status: status ?? this.status,
    comments: comments ?? this.comments,
    errorMessage: errorMessage ?? this.errorMessage
  );

  @override
  List<Object?> get props => [status, comments, errorMessage];
}
