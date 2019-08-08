import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'data/config_provider.dart';
import 'data/data_manager.dart' as dataManager;

import 'core/settings.dart';

import 'pages/main_page.dart';
import 'pages/sign_in_page.dart';
import 'pages/welcome_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      title: "CashCockpit",
      home: Scaffold(
        body: Container(
          child: StreamBuilder<FirebaseUser>(
            stream: FirebaseAuth.instance.onAuthStateChanged,
            builder: (context, snapshot) {
              print(snapshot.data);
              if (snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.hasError) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                final firebaseUser = snapshot.data;
                return ConfigProvider(
                  firebaseUser: firebaseUser,
                  settings: Settings.fromFirebase(firebaseUser),
                  child: firebaseUser == null
                      ? SignInPage()
                      : _buildPageForFirebaseUser(context),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  _buildPageForFirebaseUser(context) {
    final configProvider = ConfigProvider.of(context);
    return FutureBuilder(
      future: configProvider.doUserSettingsExist(configProvider.userID),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data) {
            return MainPage();
          } else {
            return WelcomePage();
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
