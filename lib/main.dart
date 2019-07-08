import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'data/data_provider.dart';
import 'data/month_data_provider.dart';
import 'data/data_manager.dart' as dataManager;

import 'pages/loading_page.dart';
import 'core/settings.dart';

import 'pages/main_page.dart';
import 'pages/sign_in_page.dart';
import 'pages/welcome_page.dart';

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
        } else if (snapshot.data == null) {
          return MaterialApp(
            theme: appTheme,
            home: SignInPage(),
          );
        } else {
          final firebaseUser = snapshot.data;
          return DataProvider(
            firebaseUser: firebaseUser,
            categories: Firestore.instance.collection("categories").where("userID", isEqualTo: firebaseUser.uid).snapshots(),
            settings: Settings.fromFirebase(firebaseUser),
            monthDataProvider: MonthDataProvider(
              month: DateTime.now(),
              firebaseUserID: firebaseUser.uid
            ),
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
            return MainPage();
          } else {
            return WelcomePage();
          }
        } else {
          return LoadingPage();
        }
      },
    );
  }
}
