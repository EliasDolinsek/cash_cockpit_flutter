import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

import 'settings.dart';

class Currency {
  static const USD = Currency(
      isoCode: "USD",
      currencySymbolAlignment: CurrencySymbolAlignment.LEFT,
      currencySymbol: "\$");

  static const EUR = Currency(
      isoCode: "EUR",
      currencySymbolAlignment: CurrencySymbolAlignment.RIGHT,
      currencySymbol: "€");

  static const JPY = Currency(
      isoCode: "JPY",
      currencySymbolAlignment: CurrencySymbolAlignment.LEFT,
      currencySymbol: "¥");

  static const GBP = Currency(
      isoCode: "GBP",
      currencySymbolAlignment: CurrencySymbolAlignment.LEFT,
      currencySymbol: "£");

  static const AUD = Currency(
      isoCode: "AUD",
      currencySymbolAlignment: CurrencySymbolAlignment.LEFT,
      currencySymbol: "\$");

  static const CAD = Currency(
      isoCode: "CAD",
      currencySymbolAlignment: CurrencySymbolAlignment.LEFT,
      currencySymbol: "\$");

  static const CHF = Currency(
      isoCode: "CHF",
      currencySymbolAlignment: CurrencySymbolAlignment.RIGHT,
      currencySymbol: "CHF");

  static const SEK = Currency(
      isoCode: "SEK",
      currencySymbolAlignment: CurrencySymbolAlignment.RIGHT,
      currencySymbol: "Skr");

  static const NZD = Currency(
      isoCode: "NZD",
      currencySymbolAlignment: CurrencySymbolAlignment.LEFT,
      currencySymbol: "\$");

  static const List<Currency> defaultCurrencies = [
    USD,
    EUR,
    JPY,
    GBP,
    AUD,
    CAD,
    CHF,
    SEK,
    NZD
  ];

  final String isoCode, currencySymbol;
  final CurrencySymbolAlignment currencySymbolAlignment;

  const Currency(
      {this.isoCode, this.currencySymbol, this.currencySymbolAlignment});

  factory Currency.fromISOCode(String isoCode) {
    switch (isoCode) {
      case "USD":
        return USD;
      case "JPY":
        return JPY;
      case "GBP":
        return GBP;
      case "AUD":
        return AUD;
      case "CAD":
        return CAD;
      case "CHF":
        return CHF;
      case "SEK":
        return SEK;
      case "NZD":
        return NZD;
      default:
        return EUR;
    }
  }
}

class CurrencyFormatter {
  final Settings settings;

  const CurrencyFormatter(this.settings);

  MoneyMaskedTextController getCurrencyTextController(
      double amount, onTextChanged(double value)) {
    final alignCurrencySymbolRight =
        settings.currency.currencySymbolAlignment ==
            CurrencySymbolAlignment.RIGHT;
    final currencySymbol = settings.currency.currencySymbol;

    final controller = MoneyMaskedTextController(
      initialValue: amount,
      decimalSeparator: settings.centSeparatorSymbol,
      thousandSeparator: settings.thousandSeparatorSymbol,
      rightSymbol: alignCurrencySymbolRight ? currencySymbol : "",
      leftSymbol: !alignCurrencySymbolRight ? currencySymbol : "",
    );

    controller.addListener((){
      final offset = controller.value.text.length - (alignCurrencySymbolRight ? 1 : 0);
      controller.selection = TextSelection.collapsed(offset: offset);
      onTextChanged(controller.numberValue);
    });

    return controller;
  }

  String formatAmount(double amount) {
    final formatterOutput = FlutterMoneyFormatter(
      amount: amount,
      settings: MoneyFormatterSettings(
          thousandSeparator: settings.thousandSeparatorSymbol,
          decimalSeparator: settings.centSeparatorSymbol,
          symbol: settings.currency.currencySymbol),
    ).output;

    return settings.currency.currencySymbolAlignment ==
            CurrencySymbolAlignment.RIGHT
        ? formatterOutput.symbolOnRight
        : formatterOutput.symbolOnLeft;
  }
}

enum CurrencySymbolAlignment { LEFT, RIGHT }
