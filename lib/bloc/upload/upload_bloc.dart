import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tourism_todo_recommender/bloc/upload/upload_event.dart';
import 'package:tourism_todo_recommender/bloc/upload/upload_state.dart';
import 'package:tourism_todo_recommender/widget/upload/image_item.dart';
import '../../models/todo.dart';
import '../../repository/tourism_repository.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  UploadBloc({required TourismRepository tourismRepository, required Todo? initialTodo,})
      : _tourismRepository = tourismRepository, super(UploadState.initial(initialTodo: initialTodo))
  {
    on<ImageAddRequested>(_onImageAddRequested);
    on<ImageDeleted>(_onImageDeleted);
    on<UploadSubmitted>(_onSubmitted);
  }

  final TourismRepository _tourismRepository;

  // Users should not write something too long here.
  static const shortDescriptionMaxCharacters = 50;

  // Users should not write something too long here.
  static const natureMaxCharacters = 50;

  // It should not be too long, and I think this is enough for every case.
  static const addressMaxCharacters = 100;

  // Only the first 1,500 bytes of the UTF-8 representation are considered by queries by Cloud Firestore.
  // 1 char in UTF-8 is 1 to 4 bytes.
  // Actually now it does not matter as we search in the client app
  // but if we switch to e.g. Algolia, it may matter
  static const detailedDescriptionMaxCharacters = 375;

  static String? validateShortDescription(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Short description cannot be empty';
    }
    return null;
  }

  static String? validateNature(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Nature cannot be empty';
    }
    return null;
  }

  static String? validateAddress(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Address cannot be empty';
    }
    return null;
  }

  static String? validateDetailedDescription(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Detailed description cannot be empty';
    }
    return null;
  }

  Future<void> _onImageAddRequested(ImageAddRequested event, Emitter<UploadState> emit) async {
    // TODO: how we travel between states must be cleared
    // emit(state.copyWith(status: UploadStatus.loading));
    try {
      final List<XFile> imageFiles = await _tourismRepository.getImages(event.source);
      final imageItems = <ImageItem>[];
      for (final imageFile in imageFiles) {
        try {
          final imageBytes = await imageFile.readAsBytes();
          imageItems.add(MemoryImageItem(imageBytes));
        } catch (_) {
          // TODO: what exceptions can come?
          // TODO: what do we do here?
        }
      }
      emit(state.copyWith(newItems: imageItems));
    } catch (_) {
      // TODO: what exceptions can come?
      // TODO: what do we do here?
    }
  }

  void _onImageDeleted(ImageDeleted event, Emitter<UploadState> emit) {
    emit(state.copyWith(deletedIndex: event.deletedIndex));
  }

  Future<void> _onSubmitted(UploadSubmitted event, Emitter<UploadState> emit) async {
    emit(state.copyWith(status: UploadStatus.loading));
    final location = await _tourismRepository.getLocationFromAddress(event.address);
    final todo = (state.initialTodo ?? const Todo(nature: '', detailedDescription: '', shortDescription: '', id: '', address: '', uploaderName: '', uploaderId: '', imageReferences: []))
        .copyWith(
            uploaderName: _tourismRepository.currentUser.email,
            uploaderId: _tourismRepository.currentUser.id,
            shortDescription: event.shortDescription,
            nature: event.nature,
            address: event.address,
            latitude: location?.latitude,
            longitude: location?.longitude,
            detailedDescription: event.detailedDescription
    );
    final List<Uint8List> imagesToUpload = [];
    final List<String> remainingURLs = [];
    for (final image in state.images) {
      if (image is MemoryImageItem) {
        imagesToUpload.add(image.bytes);
      }
      if (image is NetworkImageItem){
        remainingURLs.add(image.url);
      }
    }
    try {
      await _tourismRepository.uploadTodo(todo, imagesToUpload: imagesToUpload, remainingImages: remainingURLs);
      emit(state.copyWith(status: UploadStatus.success));
    } catch (e) {
      emit(state.copyWith(status: UploadStatus.failure));
    }
  }
}
