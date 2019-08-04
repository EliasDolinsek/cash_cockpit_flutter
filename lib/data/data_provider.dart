import 'package:cash_cockpit_app/core/bill.dart';
import 'package:cash_cockpit_app/core/category.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../core/settings.dart';
import 'categories_provider.dart';
import 'month_data_provider.dart';

class DataProvider extends InheritedWidget {
  //TODO delete old providers
  final MonthDataProvider monthDataProvider;

  final FirebaseUser firebaseUser;
  final Settings settings;

  final Stream<QuerySnapshot> billsStream;
  final Stream<QuerySnapshot> categoriesStream;

  DataProvider(
      {Key key,
      @required Widget child,
      @required this.firebaseUser,
      @required this.settings,
      @required this.monthDataProvider,
      @required this.billsStream,
      @required this.categoriesStream})
      : assert(child != null),
        super(key: key, child: child);

  static DataProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(DataProvider) as DataProvider;
  }

  @override
  bool updateShouldNotify(DataProvider old) {
    return true;
  }

  String get userID => firebaseUser.uid;

  Stream<List<Bill>> get bills =>
      billsStream.map((snapshot) => snapshot.documents
          .map((document) => Bill.fromnFirestore(document))
          .toList());

  Stream<List<Category>> get categories =>
      categoriesStream.map((snapshot) => snapshot.documents
          .map((document) => Category.fromFirestore(document))
          .toList());

  /*
   * Categories
   */

  Future<void> createCategory(Category category){
    return Firestore.instance.collection("categories").document().setData(category.toMap(userID));
  }

  void createDefaultCategories(){
    Category.getDefaultCategories().forEach((category){
      createCategory(category);
    });
  }

  Future<void> updateCategory(Category category){
    return Firestore.instance.collection("categories").document(category.id).updateData(category.toMap(userID));
  }

  Future<void> deleteCategory(Category category){
    return Firestore.instance.collection("categories").document(category.id).delete();
  }
}
