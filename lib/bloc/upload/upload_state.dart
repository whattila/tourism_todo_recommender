import 'package:equatable/equatable.dart';
import 'package:tourism_todo_recommender/widget/upload/image_item.dart';
import '../../models/todo.dart';

enum UploadStatus { initial, loading, success, failure }

extension UploadStatusX on UploadStatus {
  bool get isLoadingOrSuccess => [
    UploadStatus.loading,
    UploadStatus.success,
  ].contains(this);
}

class UploadState extends Equatable {

  factory UploadState.initial({Todo? initialTodo}) {
    final imageItems = [];
    if (initialTodo != null) {
      for (final imageReference in initialTodo.imageReferences){
        imageItems.add(NetworkImageItem(imageReference));
      }
    }
   return UploadState._internal(initialTodo: initialTodo, images: List.unmodifiable(imageItems));
  }

  // Do NOT add more private constructors, ALWAYS make sure 'images' is unmodifiable!
  const UploadState._internal({this.status = UploadStatus.initial, this.initialTodo, this.images = const[] });

  final UploadStatus status;
  final Todo? initialTodo;
  final List<ImageItem> images;

  bool get isNewTodo => initialTodo == null;

  UploadState copyWith({UploadStatus? status, Todo? initialTodo, int? deletedIndex, List<ImageItem>? newItems}) {
    final newImages = List.of(images);

    if (deletedIndex != null) {
      newImages.removeAt(deletedIndex);
    }

    if (newItems != null) {
      newImages.addAll(newItems);
    }

    return UploadState._internal(
      status: status ?? this.status,
      initialTodo: initialTodo ?? this.initialTodo,
      images: List.unmodifiable(newImages)
    );
  }

  @override
  List<Object?> get props => [status, initialTodo, images];
}
