import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthState extends Equatable {
  AuthState([List props = const []]) : super(props);
}

class InitialAuthState extends AuthState {}

class SignedInAuthState extends AuthState {
  final FirebaseUser firebaseUser;

  SignedInAuthState(this.firebaseUser) : super([firebaseUser]);
}

class SignedOutAuthState extends AuthState {}

class SigningInAuthState extends AuthState {}
