import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthEvent extends Equatable {
  AuthEvent([List props = const []]) : super(props);
}

class SignInWithGoogleEvent extends AuthEvent {}

class SetupEvent extends AuthEvent {}

class SignOutEvent extends AuthEvent {}
