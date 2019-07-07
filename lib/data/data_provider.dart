import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../core/settings.dart';

class DataProvider extends InheritedWidget {

  final FirebaseUser firebaseUser;
  final Settings settings;

  const DataProvider({
    Key key,
    @required Widget child,
    @required this.firebaseUser,
    @required this.settings
  })
      : assert(child != null),
        super(key: key, child: child);

  static DataProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(DataProvider) as DataProvider;
  }

  @override
  bool updateShouldNotify(DataProvider old) {
    return true;
  }
}