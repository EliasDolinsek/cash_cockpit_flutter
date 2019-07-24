import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../core/settings.dart';
import 'categories_provider.dart';
import 'month_data_provider.dart';

class DataProvider extends InheritedWidget {

  final MonthDataProvider monthDataProvider;
  final CategoriesProvider categoriesProvider;
  final FirebaseUser firebaseUser;
  final Settings settings;

  DataProvider(
      {Key key,
      @required Widget child,
      @required this.firebaseUser,
      @required this.settings,
      @required this.categoriesProvider,
      @required this.monthDataProvider})
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
