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

void createDefaultCategoriesIfNoExist(BuildContext context) {
  final dataProvider = DataProvider.of(context);
  if(dataProvider.categoriesProvider.categoeries.length == 0) {
    return createDefaultCategories(dataProvider.firebaseUser.uid);
  }
}

Future<dynamic> createUserSettings(Settings settings, String firebaseUserID) {
  return Firestore.instance.collection("users").document(firebaseUserID).setData(settings.toMap());
}

Future<dynamic> createCategory(Category category, String firebaseUserID){
  return Firestore.instance.collection("categories").document().setData(category.toMap(firebaseUserID));
}

void createDefaultCategories(String firebaseUserID){
  Category.getDefaultCategories().forEach((category){
    createCategory(category, firebaseUserID);
  });
}

Future<String> createBill(Bill bill, String firebaseUserID) async {
  return (await Firestore.instance.collection("bills").add(bill.toMap(firebaseUserID))).documentID;
}

Future<void> updateUserSettings(Settings settings, String firebaseUserID) {
  return Firestore.instance
      .collection("users")
      .document(firebaseUserID)
      .updateData(settings.toMap());
}

Future<void> updateCategory(Category category, String firebaseUserID){
  return Firestore.instance.collection("categories").document(category.id).updateData(category.toMap(firebaseUserID));
}

Future<void> updateBill(Bill bill, String firebaseUserID){
  return Firestore.instance.collection("bills").document(bill.id).updateData(bill.toMap(firebaseUserID));
}

Future<void> setUserSettings(Settings settings, String firebaseUserID) async {
  if (await doUserSettingsExist(firebaseUserID)) {
    return updateUserSettings(settings, firebaseUserID);
  } else {
    return createUserSettings(settings, firebaseUserID);
  }
}

Future<void> deleteCategory(Category category){
  return Firestore.instance.collection("categories").document(category.id).delete();
}

Future<void> deleteBill(Bill bill){
  return Firestore.instance.collection("bills").document(bill.id).delete();
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
