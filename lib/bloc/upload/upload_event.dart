import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tourism_todo_recommender/bloc/upload/upload_bloc.dart';

abstract class UploadEvent extends Equatable {
  const UploadEvent();

  @override
  List<Object> get props => [];
}

class UploadSubmitted extends UploadEvent {
  const UploadSubmitted({required this.shortDescription, required this.nature, required this.address, required this.detailedDescription});

  final String shortDescription;
  final String nature;
  final String address;
  final String detailedDescription;

  @override
  List<Object> get props => [shortDescription, nature, address, detailedDescription];
}

class ImageAddRequested extends UploadEvent {
  const ImageAddRequested({required this.source});

  final ImageSource source;

  @override
  List<Object> get props => [source];
}

class ImageDeleted extends UploadEvent {
  const ImageDeleted({required this.deletedIndex});

  final int deletedIndex;

  @override
  List<Object> get props => [deletedIndex];
}
