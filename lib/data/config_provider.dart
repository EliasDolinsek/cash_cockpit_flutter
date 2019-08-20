import 'package:cash_cockpit_app/core/bill.dart';
import 'package:cash_cockpit_app/core/category.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../core/settings.dart';

// ignore: must_be_immutable
class ConfigProvider extends InheritedWidget {

  final FirebaseUser firebaseUser;
  final Settings settings;

  ConfigProvider(
      {Key key,
      @required Widget child,
      @required this.firebaseUser,
      @required this.settings})
      : assert(child != null),
        super(key: key, child: child){
  }

  static ConfigProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(ConfigProvider) as ConfigProvider;
  }

  @override
  bool updateShouldNotify(ConfigProvider old) {
    return true;
  }

  String get userID => firebaseUser.uid;

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

  /*
   * Others
   */

  Future<bool> doUserSettingsExist(String firebaseUserID) async {
    return (await Firestore.instance
        .collection("users")
        .document(firebaseUserID)
        .snapshots()
        .first)
        .exists;
  }

  Future<void> setUserSettings(Settings settings, String firebaseUserID) async {
    if (await doUserSettingsExist(firebaseUserID)) {
      return updateUserSettings(settings, firebaseUserID);
    } else {
      return createUserSettings(settings, firebaseUserID);
    }
  }

  Future<dynamic> createUserSettings(Settings settings, String firebaseUserID) {
    return Firestore.instance.collection("users").document(firebaseUserID).setData(settings.toMap());
  }

  Future<void> updateUserSettings(Settings settings, String firebaseUserID) {
    return Firestore.instance
        .collection("users")
        .document(firebaseUserID)
        .updateData(settings.toMap());
  }
}
