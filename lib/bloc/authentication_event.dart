import 'package:equatable/equatable.dart';

import '../data/user.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class LogoutRequested extends AuthenticationEvent {}

class UserChanged extends AuthenticationEvent {
  const UserChanged(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}
