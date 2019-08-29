import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/blocs/auth_bloc/bloc.dart';
import 'data/blocs/blocs.dart';

import 'pages/main_page.dart';
import 'pages/sign_in_page.dart';
import 'pages/welcome_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final authBloc = AuthBloc();
  final dataBloc = DataBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      builder: (context) => authBloc,
      child: BlocProvider(
        builder: (context) {
          dataBloc.dispatch(SetupDataEvent(DateTime.now()));
          return dataBloc;
        },
        child: MaterialApp(
          title: "CashCockpit",
          theme: ThemeData(primarySwatch: Colors.blue),
          home: BlocBuilder(
            bloc: authBloc,
            builder: (BuildContext context, AuthState state) {
              if (state is SignedOutAuthState) {
                return SignInPage();
              } else if (state is SignedInAuthState) {
                return BlocBuilder(
                    bloc: dataBloc,
                    builder: (context, state) {
                      if (state is SetupSettingsState) {
                        return WelcomePage();
                      } else {
                        return MainPage();
                      }
                    });
              } else {
                if (state is InitialAuthState) authBloc.dispatch(SetupEvent());
                return Scaffold(
                    body: Center(child: CircularProgressIndicator()));
              }
            },
          ),
        ),
      ),
    );
  }
}
