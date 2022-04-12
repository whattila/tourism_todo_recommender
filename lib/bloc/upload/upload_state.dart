import 'package:equatable/equatable.dart';
import '../../data/todo.dart';

enum UploadStatus { initial, loading, success, failure }

// ez mire való? biztos kell ez?
extension UploadStatusX on UploadStatus {
  bool get isLoadingOrSuccess => [
    UploadStatus.loading,
    UploadStatus.success,
  ].contains(this);
}

class UploadState extends Equatable {
  const UploadState({
    this.status = UploadStatus.initial,
    this.initialTodo,
    this.shortDescription = '',
    this.nature = '',
    this.address = '',
    this.detailedDescription = '',
  });

  final UploadStatus status;
  final Todo? initialTodo;
  final String shortDescription;
  final String nature;
  final String address;
  final String detailedDescription;

  bool get isNewTodo => initialTodo == null;

  UploadState copyWith({
    UploadStatus? status,
    Todo? initialTodo,
    String? shortDescription,
    String? nature,
    String? address,
    String? detailedDescription,
  }) {
    return UploadState(
      status: status ?? this.status,
      initialTodo: initialTodo ?? this.initialTodo,
      shortDescription: shortDescription ?? this.shortDescription,
      nature: nature ?? this.nature,
      address: address ?? this.address,
      detailedDescription: detailedDescription ?? this.detailedDescription,
    );
  }

  @override
  List<Object?> get props => [status, initialTodo, shortDescription, nature, address, detailedDescription];
}
