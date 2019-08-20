import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './bloc.dart';

import '../../../core/auth_manager.dart' as authManager;

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  FirebaseUser _user;

  FirebaseUser get user => _user;
  
  @override
  AuthState get initialState => InitialAuthState();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if(event is SignInWithGoogleEvent){
      yield SigningInAuthState();
      _user = await authManager.signInWithGoogle();
      yield SignedInAuthState(_user);
    } else if (event is SetupEvent){
      _user = await FirebaseAuth.instance.currentUser();
      if(_user == null){
        yield SignedOutAuthState();
      } else {
        yield SignedInAuthState(_user);
      }
    } else if (event is SignOutEvent){
      await authManager.signOut();
      yield SignedOutAuthState();
    }
  }

}
