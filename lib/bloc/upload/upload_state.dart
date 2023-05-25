import 'package:equatable/equatable.dart';
import 'package:tourism_todo_recommender/widget/upload/image_item.dart';
import '../../models/todo.dart';

enum UploadStatus { initial, loading, success, failure }
enum AddressStatus { initial, loading, success, failure }
// TODO: we should add new status enums here for different operations

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
      for (final imageReference in initialTodo.imageReferences) {
        imageItems.add(NetworkImageItem(imageReference));
      }
    }
    return UploadState._internal(initialTodo: initialTodo, images: List.unmodifiable(imageItems));
  }

  // Do NOT add more private constructors, ALWAYS make sure 'images' is unmodifiable!
  const UploadState._internal({
    this.uploadStatus = UploadStatus.initial,
    this.addressStatus = AddressStatus.initial,
    this.initialTodo,
    this.images = const[],
    this.deviceAddress = ""
  });

  /// The result of the last upload attempt
  final UploadStatus uploadStatus;
  /// The result of the last attempt to get the current device address
  final AddressStatus addressStatus;
  final Todo? initialTodo;
  final List<ImageItem> images;
  /// The address of the device obtained from its location via reverse geocoding
  final String deviceAddress;

  bool get isNewTodo => initialTodo == null;

  UploadState copyWith({
    UploadStatus? uploadStatus,
    AddressStatus? addressStatus,
    Todo? initialTodo,
    int? deletedIndex,
    List<ImageItem>? newItems,
    String? deviceAddress
  }) {
    final newImages = List.of(images);

    if (deletedIndex != null) {
      newImages.removeAt(deletedIndex);
    }

    if (newItems != null) {
      newImages.addAll(newItems);
    }

    return UploadState._internal(
      uploadStatus: uploadStatus ?? this.uploadStatus,
      addressStatus: addressStatus ?? this.addressStatus,
      initialTodo: initialTodo ?? this.initialTodo,
      images: List.unmodifiable(newImages),
      deviceAddress: deviceAddress ?? this.deviceAddress
    );
  }

  @override
  List<Object?> get props => [uploadStatus, addressStatus, initialTodo, images, deviceAddress];
}
