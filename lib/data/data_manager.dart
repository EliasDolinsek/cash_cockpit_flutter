import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../core/settings.dart';
import 'data_provider.dart';

Future<bool> doUserSettingsExist(String firebaseUserID) async {
  return (await Firestore.instance
          .collection("users")
          .document(firebaseUserID)
          .snapshots()
          .first)
      .exists;
}

Future<dynamic> createUserSettings(Settings settings, String firebaseUserID) {
  final document =
      Firestore.instance.collection("users").document(firebaseUserID);
  return Firestore.instance.runTransaction((transaction) async {
    await transaction.set(document, settings.toMap());
  });
}

Future<void> updateUserSettings(Settings settings, String firebaseUserID) {
  return Firestore.instance
      .collection("users")
      .document(firebaseUserID)
      .updateData(settings.toMap());
}

Future<void> setUserSettings(Settings settings, String firebaseUserID) async {
  if (await doUserSettingsExist(firebaseUserID)) {
    return updateUserSettings(settings, firebaseUserID);
  } else {
    return createUserSettings(settings, firebaseUserID);
  }
}
