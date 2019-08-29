import 'package:cash_cockpit_app/data/data_providers/firebase_provider.dart';
import 'package:cash_cockpit_app/core/core.dart';

class Repository {

  final _firebaseProvider = FirebaseProvider();
  String userID;

  Repository({this.userID});

  Stream<List<Bill>> billsOfMonth(String monthAsString) {
    return _firebaseProvider
        .billsOfMonth(monthAsString, userID)
        .map((q) => q.documents.map((ds) => Bill.fromnFirestore(ds)).toList());
  }

  Stream<List<Category>> categories() {
    return _firebaseProvider.categories(userID).map(
        (q) => q.documents.map((ds) => Category.fromFirestore(ds)).toList());
  }

  Future<void> createCategory(Category category, ) {
    return _firebaseProvider.createCategory(category, userID);
  }

  void createDefaultCategories() {
    _firebaseProvider.createDefaultCategories(userID);
  }

  Future<void> updateCategory(Category category, ) {
    return _firebaseProvider.updateCategory(category, userID);
  }

  Future<void> deleteCategory(Category category) {
    return _firebaseProvider.deleteCategory(category);
  }

  Future<String> createBill(Bill bill, ) async {
    return _firebaseProvider.createBill(bill, userID);
  }

  Future<void> updateBill(Bill bill, ) {
    return _firebaseProvider.updateBill(bill, userID);
  }

  Future<void> deleteBill(Bill bill) {
    return _firebaseProvider.deleteBill(bill);
  }

  Future<bool> doUserSettingsExist(String firebaseUserID) async {
    return _firebaseProvider.doUserSettingsExist(firebaseUserID);
  }

  Future<void> setUserSettings(Settings settings, ) async {
    return _firebaseProvider.setUserSettings(settings, userID);
  }
}
