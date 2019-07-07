import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'data/data_provider.dart';
import 'data/data_manager.dart' as dataManager;

import 'pages/loading_page.dart';
import 'pages/settings_setup_pages.dart';

import 'core/settings.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final appTheme = ThemeData(
    primarySwatch: Colors.blue,
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.hasError) {
          return MaterialApp(
            theme: appTheme,
            home: LoadingPage(),
          );
        } else {
          final firebaseUser = snapshot.data;
          return DataProvider(
            firebaseUser: firebaseUser,
            settings: Settings.fromFirebase(firebaseUser),
            child: MaterialApp(
              title: "CashCockpit",
              theme: appTheme,
              home: _buildPageForFirebaseUser(firebaseUser.uid),
            ),
          );
        }
      },
    );
  }

  _buildPageForFirebaseUser(String firebaseUserID) {
    return FutureBuilder(
      future: dataManager.doUserSettingsExist(firebaseUserID),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data) {
            return Text("FULLY");
          } else {
            return CurrencySetup();
          }
        } else {
          return LoadingPage();
        }
      },
    );
  }
}