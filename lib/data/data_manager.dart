import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../core/bill.dart';
import '../core/settings.dart';
import '../core/category.dart';
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
  return Firestore.instance.collection("users").document(firebaseUserID).setData(settings.toMap());
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

void uploadFile(File file, String fileName, onUploaded(downloadURL)) {
  final StorageReference storageReference = FirebaseStorage.instance
      .ref()
      .child(fileName);
  final StorageUploadTask storageUploadTask = storageReference.putFile(file);

  storageUploadTask.onComplete.then((StorageTaskSnapshot s) async {
    final url = await s.ref.getDownloadURL();
    onUploaded(url);
  });
}

void uploadFileRandomNamed(File file, onUploaded(downloadURL)) => uploadFile(file, Uuid().v1(), onUploaded);

void deleteFile(String fileName, Function onDeleted){
  FirebaseStorage.instance.ref().child(fileName).delete().whenComplete(onDeleted);
}
