import 'package:tourism_todo_recommender/data/user.dart';

/// {@template sign_up_with_email_and_password_failure}
/// Thrown if during the sign up process if a failure occurs.
/// {@endtemplate}
class SignUpWithEmailAndPasswordFailure implements Exception {
  /// {@macro sign_up_with_email_and_password_failure}
  const SignUpWithEmailAndPasswordFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// The associated error message.
  final String message;
}

/// {@template log_in_with_email_and_password_failure}
/// Thrown during the login process if a failure occurs.
/// {@endtemplate}
class LogInWithEmailAndPasswordFailure implements Exception {
  /// {@macro log_in_with_email_and_password_failure}
  const LogInWithEmailAndPasswordFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// The associated error message.
  final String message;
}

/// {@template log_out_with_email_and_password_failure}
/// Thrown during the logout process if a failure occurs.
/// {@endtemplate}
class LogOutFailure implements Exception {
  /// {@macro log_out_with_email_and_password_failure}
  const LogOutFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// The associated error message.
  final String message;
}

/// {@template authenticator}
/// Template for class which manages user authentication.
/// {@endtemplate}
abstract class Authenticator {
  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  Stream<User> get user;

  /// Returns the current user.
  User get currentUser;

  /// Creates a new user with the provided [email] and [password].
  ///
  /// Email and password combination for signing up/in is so common
  /// that it can be assumed it will remain the method with every auth solution.
  Future<void> signUp({required String email, required String password});

  /// Signs in with the provided [email] and [password].
  ///
  /// Email and password combination for signing up/in is so common
  /// that it can be assumed it will remain the method with every auth solution.
  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Signs out the current user
  Future<void> logOut();
}