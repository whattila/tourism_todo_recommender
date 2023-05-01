part of 'comment_bloc.dart';

abstract class CommentEvent extends Equatable {
  const CommentEvent();
}

class CommentSubscriptionRequested extends CommentEvent {
  const CommentSubscriptionRequested({required this.todo});

  final Todo todo;

  @override
  List<Object?> get props => [todo];
}

class CommentAdded extends CommentEvent {
  const CommentAdded({required this.commentText, required this.todo});

  final String commentText;
  final Todo todo;

  @override
  List<Object?> get props => [commentText, todo];
}
