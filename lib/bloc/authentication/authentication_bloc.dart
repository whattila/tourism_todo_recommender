import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../models/user.dart';
import '../../repository/tourism_repository.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({required TourismRepository tourismRepository})
      : _tourismRepository = tourismRepository,
        super(
        tourismRepository.currentUser.isNotEmpty
            ? AuthenticationState.authenticated(tourismRepository.currentUser)
            : const AuthenticationState.unauthenticated(),
      ) {
    on<UserChanged>(_onUserChanged);
    on<LogoutRequested>(_onLogoutRequested);
    _userSubscription = _tourismRepository.user.listen(
          (user) => add(UserChanged(user)),
    );
  }

  final TourismRepository _tourismRepository;
  late final StreamSubscription<User> _userSubscription;

  void _onUserChanged(UserChanged event, Emitter<AuthenticationState> emit) {
    emit(
      event.user.isNotEmpty
          ? AuthenticationState.authenticated(event.user)
          : const AuthenticationState.unauthenticated(),
    );
  }

  void _onLogoutRequested(LogoutRequested event, Emitter<AuthenticationState> emit) {
    unawaited(_tourismRepository.logOut());
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}