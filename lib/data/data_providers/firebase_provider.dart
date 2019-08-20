import 'package:cash_cockpit_app/core/bill.dart';
import 'package:cash_cockpit_app/core/category.dart';
import 'package:cash_cockpit_app/core/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseProvider {

  Firestore _firestore = Firestore.instance;

  Stream<QuerySnapshot> billsOfMonth(String month, String userID) => _firestore
      .collection("bills")
      .where("month", isEqualTo: month)
      .where("userID", isEqualTo: userID)
      .snapshots();

  Stream<QuerySnapshot> categories(String userID){
    return _firestore
        .collection("categories")
        .where("userID", isEqualTo: userID)
        .snapshots();
  }

  Future<void> createCategory(Category category, String userID) {
    return _firestore
        .collection("categories")
        .document()
        .setData(category.toMap(userID));
  }

  void createDefaultCategories(String userID) {
    Category.getDefaultCategories().forEach((category) {
      createCategory(category, userID);
    });
  }

  Future<void> updateCategory(Category category, String userID) {
    return _firestore
        .collection("categories")
        .document(category.id)
        .updateData(category.toMap(userID));
  }

  Future<void> deleteCategory(Category category) {
    return _firestore.collection("categories").document(category.id).delete();
  }

  Future<String> createBill(Bill bill, String userID) async {
    return (await _firestore.collection("bills").add(bill.toMap(userID)))
        .documentID;
  }

  Future<void> updateBill(Bill bill, String userID) {
    return _firestore
        .collection("bills")
        .document(bill.id)
        .updateData(bill.toMap(userID));
  }

  Future<void> deleteBill(Bill bill) {
    return _firestore.collection("bills").document(bill.id).delete();
  }

  Future<bool> doUserSettingsExist(String firebaseUserID) async {
    return (await _firestore
            .collection("users")
            .document(firebaseUserID)
            .snapshots()
            .first)
        .exists;
  }

  Future<void> setUserSettings(Settings settings, String userID) async {
    if (await doUserSettingsExist(userID)) {
      return updateUserSettings(settings, userID);
    } else {
      return createUserSettings(settings, userID);
    }
  }

  Future<dynamic> createUserSettings(Settings settings, String userID) {
    return _firestore
        .collection("users")
        .document(userID)
        .setData(settings.toMap());
  }

  Future<void> updateUserSettings(Settings settings, String userID) {
    return _firestore
        .collection("users")
        .document(userID)
        .updateData(settings.toMap());
  }
}
