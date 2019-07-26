import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'currency.dart';

class Settings {
  //ISO 4217
  String currencyISOCode, centSeparatorSymbol, thousandSeparatorSymbol;
  double balance, wantedMonthlySaveUps;

  Settings(
      {this.currencyISOCode,
      this.centSeparatorSymbol,
      this.thousandSeparatorSymbol,
      this.balance,
      this.wantedMonthlySaveUps});

  factory Settings.defaultSettings() {
    return Settings(
      currencyISOCode: "EUR",
      centSeparatorSymbol: ",",
      thousandSeparatorSymbol: ".",
      balance: 0,
      wantedMonthlySaveUps: 0,
    );
  }

  factory Settings.fromFirestore(DocumentSnapshot documentSnapshot) {
    final map = documentSnapshot.data;
    if (map == null) return Settings.defaultSettings();

    return Settings(
        currencyISOCode: map["currencyISOCode"] ?? "EUR",
        centSeparatorSymbol: map["centSeparatorSymbol"] ?? ",",
        thousandSeparatorSymbol: map["thousandSeparatorSymbol"] ?? ".",
        balance: map["balance"] ?? 0,
        wantedMonthlySaveUps: map["wantedMonthlySaveUps"] ?? 0);
  }

  factory Settings.fromFirebase(FirebaseUser user) {
    final settings = Settings.defaultSettings();
    Firestore.instance
        .collection("users")
        .document(user.uid)
        .snapshots()
        .listen((DocumentSnapshot documentSnapshot) {
      final newSettings = Settings.fromFirestore(documentSnapshot);
      settings.update(newSettings);
    });
    return settings;
  }

  void update(Settings settings) {
    currencyISOCode = settings.currencyISOCode;
    centSeparatorSymbol = settings.centSeparatorSymbol;
    thousandSeparatorSymbol = settings.thousandSeparatorSymbol;
  }

  Currency get currency => Currency.fromISOCode(currencyISOCode);

  CurrencyFormatter get currencyFormatter => CurrencyFormatter(this);

  Map<String, dynamic> toMap() {
    return {
      "currencyISOCode": currencyISOCode,
      "centSeparatorSymbol": centSeparatorSymbol,
      "thousandSeparatorSymbol": thousandSeparatorSymbol,
      "balance": balance,
      "wantedMonthlySaveUps": wantedMonthlySaveUps
    };
  }
}
