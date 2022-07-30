import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:tourism_todo_recommender/data/authenticator.dart';
import '../../models/user.dart';

/// {@template firebase_authenticator}
/// Implementation of [Authenticator] which uses Firebase.
/// {@endtemplate}
class FirebaseAuthenticator extends Authenticator {
  /// {@macro firebase_authenticator}
  FirebaseAuthenticator({firebase_auth.FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  User? _user;
  final firebase_auth.FirebaseAuth _firebaseAuth;

  @override
  Future<void> logInWithEmailAndPassword({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw FirebaseLogInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithEmailAndPasswordFailure();
    }
  }

  @override
  Future<void> logOut() async {
    try {
      // ez így biztos jó?
      await _firebaseAuth.signOut();
    } catch (_) {
      throw const LogOutFailure();
    }
  }

  @override
  Future<void> signUp({required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw FirebaseSignUpWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const SignUpWithEmailAndPasswordFailure();
    }
  }

  @override
  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser == null ? User.empty : firebaseUser.toUser;
      _user = user;
      return user;
    });
  }

  @override
  User get currentUser => _user ?? User.empty;
}

class FirebaseSignUpWithEmailAndPasswordFailure extends SignUpWithEmailAndPasswordFailure {
  const FirebaseSignUpWithEmailAndPasswordFailure(String message) : super(message);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  /// https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/createUserWithEmailAndPassword.html
  factory FirebaseSignUpWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const FirebaseSignUpWithEmailAndPasswordFailure(
          'Email is not valid or badly formatted.',
        );
      case 'user-disabled':
        return const FirebaseSignUpWithEmailAndPasswordFailure(
          'This user has been disabled. Please contact support for help.',
        );
      case 'email-already-in-use':
        return const FirebaseSignUpWithEmailAndPasswordFailure(
          'An account already exists for that email.',
        );
      case 'operation-not-allowed':
        return const FirebaseSignUpWithEmailAndPasswordFailure(
          'Operation is not allowed.  Please contact support.',
        );
      case 'weak-password':
        return const FirebaseSignUpWithEmailAndPasswordFailure(
          'Please enter a stronger password.',
        );
      default:
        return const FirebaseSignUpWithEmailAndPasswordFailure(
            'An unknown exception occurred.'
        );
    }
  }
}

class FirebaseLogInWithEmailAndPasswordFailure extends LogInWithEmailAndPasswordFailure {
  const FirebaseLogInWithEmailAndPasswordFailure(String message) : super(message);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  factory FirebaseLogInWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const FirebaseLogInWithEmailAndPasswordFailure(
          'Email is not valid or badly formatted.',
        );
      case 'user-disabled':
        return const FirebaseLogInWithEmailAndPasswordFailure(
          'This user has been disabled. Please contact support for help.',
        );
      case 'user-not-found':
        return const FirebaseLogInWithEmailAndPasswordFailure(
          'Email is not found, please create an account.',
        );
      case 'wrong-password':
        return const FirebaseLogInWithEmailAndPasswordFailure(
          'Incorrect password, please try again.',
        );
      default:
        return const FirebaseLogInWithEmailAndPasswordFailure(
            'An unknown exception occurred.'
        );
    }
  }
}

/// For converting Firebase's User objects to ours.
extension on firebase_auth.User {
  User get toUser {
    return User(id: uid, email: email, name: displayName);
  }
}