import 'package:equatable/equatable.dart';

abstract class OwnTodosEvent extends Equatable {
  const OwnTodosEvent();

  @override
  List<Object> get props => [];
}

class OwnTodosSubscriptionRequested extends OwnTodosEvent {
  const OwnTodosSubscriptionRequested();
}