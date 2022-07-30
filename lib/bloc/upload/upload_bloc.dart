import 'package:bloc/bloc.dart';
import 'package:tourism_todo_recommender/bloc/upload/upload_event.dart';
import 'package:tourism_todo_recommender/bloc/upload/upload_state.dart';
import '../../models/geolocation.dart';
import '../../models/todo.dart';
import '../../repository/tourism_repository.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  UploadBloc({
    required TourismRepository tourismRepository,
    required Todo? initialTodo,
  })  : _tourismRepository = tourismRepository,
        super(
        UploadState(
          initialTodo: initialTodo,
          shortDescription: initialTodo?.shortDescription ?? '',
          nature: initialTodo?.nature ?? '',
          address: initialTodo?.address ?? '',
          detailedDescription: initialTodo?.detailedDescription ?? '',
        ),
      ) {
    on<UploadShortDescriptionChanged>(_onShortDescriptionChanged);
    on<UploadNatureChanged>(_onNatureChanged);
    on<UploadAddressChanged>(_onAddressChanged);
    on<UploadDetailedDescriptionChanged>(_onDetailedDescriptionChanged);
    on<UploadSubmitted>(_onSubmitted);
  }

  final TourismRepository _tourismRepository;

  void _onShortDescriptionChanged(
      UploadShortDescriptionChanged event,
      Emitter<UploadState> emit,
      ) {
    emit(state.copyWith(shortDescription: event.shortDescription));
  }

  void _onNatureChanged(
      UploadNatureChanged event,
      Emitter<UploadState> emit,
      ) {
    emit(state.copyWith(nature: event.nature));
  }

  void _onAddressChanged(
      UploadAddressChanged event,
      Emitter<UploadState> emit,
      ) {
    emit(state.copyWith(address: event.address));
  }

  void _onDetailedDescriptionChanged(
      UploadDetailedDescriptionChanged event,
      Emitter<UploadState> emit,
      ) {
    emit(state.copyWith(detailedDescription: event.detailedDescription));
  }

  Future<void> _onSubmitted(
      UploadSubmitted event,
      Emitter<UploadState> emit,
      ) async {
    emit(state.copyWith(status: UploadStatus.loading));
    Geolocation? location = await _tourismRepository.getLocationFromAddress(state.address);
    final todo = (state.initialTodo ?? const Todo(nature: '', detailedDescription: '', shortDescription: '', id: '', address: '', uploaderName: '', uploaderId: ''))
        .copyWith(
      uploaderName: _tourismRepository.currentUser.email,
      uploaderId: _tourismRepository.currentUser.id,
      shortDescription: state.shortDescription,
      nature: state.nature,
      address: state.address,
      latitude: location?.latitude,
      longitude: location?.longitude,
      detailedDescription: state.detailedDescription
    );

    try {
      await _tourismRepository.uploadTodo(todo);
      emit(state.copyWith(status: UploadStatus.success));
    } catch (e) {
      emit(state.copyWith(status: UploadStatus.failure));
    }
  }
}
