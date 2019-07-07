import 'package:cash_cockpit_app/data/data_provider.dart';
import 'package:flutter/material.dart';

import '../widgets/amount_text.dart';
import '../widgets/currency_selection.dart';

import '../data/data_manager.dart' as dataManager;

class CurrencySetup extends StatefulWidget {
  @override
  _CurrencySetupState createState() => _CurrencySetupState();
}

class _CurrencySetupState extends State<CurrencySetup> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Currency Setup",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Center(
              child: AmountText(
                upperText: DataProvider.of(context).settings
                    .currencyFormatter
                    .formatAmount(1000),
                lowerText: "EXAMPLE",
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: CurrencySelection(
              onCurrencySelected: (currencyISOCode) {
                setState(() {
                  DataProvider.of(context).settings.currencyISOCode = currencyISOCode;
                });
              },
            ),
          ),
          Expanded(
            flex: 4,
            child: Text("TEST"),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    final dataProvider = DataProvider.of(context);
    dataManager.setUserSettings(dataProvider.settings, dataProvider.firebaseUser.uid);
  }
}
