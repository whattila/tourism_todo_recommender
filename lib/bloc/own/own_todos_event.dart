import 'package:equatable/equatable.dart';

/// So far it has only one realization but more can be added in the future.
abstract class OwnTodosEvent extends Equatable {
  const OwnTodosEvent();

  @override
  List<Object> get props => [];
}

class OwnTodosSubscriptionRequested extends OwnTodosEvent {
  const OwnTodosSubscriptionRequested();
}