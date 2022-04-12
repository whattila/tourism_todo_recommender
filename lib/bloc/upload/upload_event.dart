import 'package:equatable/equatable.dart';

abstract class UploadEvent extends Equatable {
  const UploadEvent();

  @override
  List<Object> get props => [];
}

class UploadShortDescriptionChanged extends UploadEvent {
  const UploadShortDescriptionChanged(this.shortDescription);

  final String shortDescription;

  @override
  List<Object> get props => [shortDescription];
}

class UploadNatureChanged extends UploadEvent {
  const UploadNatureChanged(this.nature);

  final String nature;

  @override
  List<Object> get props => [nature];
}

class UploadAddressChanged extends UploadEvent {
  const UploadAddressChanged(this.address);

  final String address;

  @override
  List<Object> get props => [address];
}

class UploadDetailedDescriptionChanged extends UploadEvent {
  const UploadDetailedDescriptionChanged(this.detailedDescription);

  final String detailedDescription;

  @override
  List<Object> get props => [detailedDescription];
}

class UploadSubmitted extends UploadEvent {
  const UploadSubmitted();
}
