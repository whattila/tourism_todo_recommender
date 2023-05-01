// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      userName: json['userName'] as String,
      date: DateTime.parse(json['date'] as String),
      text: json['text'] as String,
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'userName': instance.userName,
      'date': instance.date.toIso8601String(),
      'text': instance.text,
    };
