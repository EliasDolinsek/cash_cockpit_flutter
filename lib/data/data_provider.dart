import 'package:cash_cockpit_app/core/bill.dart';
import 'package:cash_cockpit_app/core/category.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

import '../core/settings.dart';
import 'month_data_provider.dart';

// ignore: must_be_immutable
class DataProvider extends InheritedWidget {
  //TODO delete old providers
  final MonthDataProvider monthDataProvider;

  final FirebaseUser firebaseUser;
  final Settings settings;

  Stream<QuerySnapshot> categoriesStream;

  DataProvider(
      {Key key,
      @required Widget child,
      @required this.firebaseUser,
      @required this.settings,
      @required this.monthDataProvider})
      : assert(child != null),
        super(key: key, child: child) {
    categoriesStream = Observable(Firestore.instance
            .collection("categories")
            .where("userID", isEqualTo: firebaseUser.uid)
            .snapshots())
        .shareReplay(maxSize: 1);
  }

  static DataProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(DataProvider) as DataProvider;
  }

  @override
  bool updateShouldNotify(DataProvider old) {
    return true;
  }

  String get userID => firebaseUser.uid;

  Stream<List<Category>> get categories =>
      categoriesStream.asBroadcastStream().map((snapshot) => snapshot.documents
          .map((document) => Category.fromFirestore(document))
          .toList());

  /*
   * Categories
   */

  Future<void> createCategory(Category category) {
    return Firestore.instance
        .collection("categories")
        .document()
        .setData(category.toMap(userID));
  }

  void createDefaultCategories() {
    Category.getDefaultCategories().forEach((category) {
      createCategory(category);
    });
  }

  Future<void> updateCategory(Category category) {
    return Firestore.instance
        .collection("categories")
        .document(category.id)
        .updateData(category.toMap(userID));
  }

  Future<void> deleteCategory(Category category) {
    return Firestore.instance
        .collection("categories")
        .document(category.id)
        .delete();
  }

  /*
   * Bills
   */

  Future<String> createBill(Bill bill) async {
    return (await Firestore.instance
            .collection("bills")
            .add(bill.toMap(userID)))
        .documentID;
  }

  Future<void> updateBill(Bill bill) {
    return Firestore.instance
        .collection("bills")
        .document(bill.id)
        .updateData(bill.toMap(userID));
  }

  Future<void> deleteBill(Bill bill) {
    return Firestore.instance.collection("bills").document(bill.id).delete();
  }
}
