import 'package:cloud_firestore/cloud_firestore.dart';

import 'currency.dart';

class Settings {
  //ISO 4217
  String currencyISOCode, centSeparatorSymbol, thousandSeparatorSymbol;
  double balance, desiredMonthlySaveUps;
  bool _areDefaultSettings = false;

  Settings(
      {this.currencyISOCode,
      this.centSeparatorSymbol,
      this.thousandSeparatorSymbol,
      this.balance,
      this.desiredMonthlySaveUps});

  factory Settings.defaultSettings() {
    final settings = Settings(
      currencyISOCode: "EUR",
      centSeparatorSymbol: ",",
      thousandSeparatorSymbol: ".",
      balance: 0,
      desiredMonthlySaveUps: 0,
    );

    settings._areDefaultSettings = true;
    return settings;
  }

  factory Settings.fromFirestore(DocumentSnapshot documentSnapshot) {
    final map = documentSnapshot.data;
    if (map == null) return Settings.defaultSettings();

    final currencyISOCode = map["currencyISOCode"];
    final centSeparatorSymbol = map["centSeparatorSymbol"];
    final thousandSeparatorSymbol = map["thousandSeparatorSymbol"];
    final balance = map["balance"];
    final desiredMonthlySaveUps = map["desiredMonthlySaveUps"];

    if (currencyISOCode == null &&
        centSeparatorSymbol == null &&
        thousandSeparatorSymbol == null &&
        balance == null &&
        desiredMonthlySaveUps == null) {
      return Settings.defaultSettings();
    }

    return Settings(
        currencyISOCode: currencyISOCode ?? "EUR",
        centSeparatorSymbol: centSeparatorSymbol ?? ",",
        thousandSeparatorSymbol: thousandSeparatorSymbol ?? ".",
        balance: balance ?? 0.0,
        desiredMonthlySaveUps: desiredMonthlySaveUps ?? 0.0);
  }

  static Future<Settings> fromFirebase(String userID) async {
    return Settings.fromFirestore(await Firestore.instance
        .collection("users")
        .document(userID)
        .snapshots()
        .first);
  }

  void update(Settings settings) {
    currencyISOCode = settings.currencyISOCode;
    centSeparatorSymbol = settings.centSeparatorSymbol;
    thousandSeparatorSymbol = settings.thousandSeparatorSymbol;
    balance = settings.balance;
    desiredMonthlySaveUps = settings.desiredMonthlySaveUps;
  }

  bool get areDefaultSettings => _areDefaultSettings;

  Currency get currency => Currency.fromISOCode(currencyISOCode);

  CurrencyFormatter get currencyFormatter => CurrencyFormatter(this);

  Map<String, dynamic> toMap() {
    return {
      "currencyISOCode": currencyISOCode,
      "centSeparatorSymbol": centSeparatorSymbol,
      "thousandSeparatorSymbol": thousandSeparatorSymbol,
      "balance": balance,
      "desiredMonthlySaveUps": desiredMonthlySaveUps
    };
  }
}
