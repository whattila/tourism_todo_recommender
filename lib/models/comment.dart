import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

/// A comment added to a todo
@JsonSerializable()
class Comment extends Equatable {
  const Comment({this.todoId, required this.userName, required this.date, required this.text});

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);

  /// The id of the todo this comment was added to
  @JsonKey(ignore: true)
  final String? todoId;

  /// The name of the user who added the comment
  final String userName;

  /// The date when the comment was added
  // TODO: azt meg lehet kapni valahogy, hogy milyen rég volt (pl. 2 hete) mint Facebookon?
  final DateTime date;

  /// The text of the comment
  final String text;

  /// The date in the form to use when displaying it.
  /// TODO: we will switch to a solution with flutter_date_difference if we manage to update Dart SDK.
  @JsonKey(ignore: true)
  String get formattedDate {
    var dateString = date.toString();
    var end = dateString.indexOf(' ');
    return dateString.substring(0, end);
  }
  
  Map<String, dynamic> toJson() => _$CommentToJson(this);

  @override
  List<Object?> get props => [todoId, userName, date, text];

}