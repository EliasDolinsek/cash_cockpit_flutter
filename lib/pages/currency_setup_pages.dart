import 'package:cash_cockpit_app/data/data_provider.dart';
import 'package:flutter/material.dart';

import '../widgets/amount_text.dart';
import '../widgets/currency_selection.dart';
import '../widgets/currency_separators_selection.dart';

import '../data/data_manager.dart' as dataManager;

class CurrencySetupPage extends StatefulWidget {

  final bool showBackButton;

  const CurrencySetupPage({this.showBackButton = true});
  @override
  _CurrencySetupPageState createState() => _CurrencySetupPageState();
}

class _CurrencySetupPageState extends State<CurrencySetupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: widget.showBackButton,
        title: Text(
          "Currency Setup",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              final dataProvider = DataProvider.of(context);
              dataManager.setUserSettings(
                  dataProvider.settings, dataProvider.firebaseUser.uid);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return Column(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Center(
                  child: _buildAmountText(),
                ),
              ),
              Expanded(
                flex: 7,
                child: Column(
                  children: <Widget>[
                    _buildCurrencySelection(),
                    SizedBox(
                      height: 32.0,
                    ),
                    _buildSeparatorsSelection()
                  ],
                ),
              ),
            ],
          );
        } else {
          return Column(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: _buildAmountText(),
              ),
              Expanded(
                flex: 6,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Center(
                        child: _buildCurrencySelection(),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Center(
                        child: _buildSeparatorsSelection(),
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        }
      }),
    );
  }

  Widget _buildAmountText() {
    return AmountText(
      upperText: DataProvider.of(context)
          .settings
          .currencyFormatter
          .formatAmount(1000),
      lowerText: "EXAMPLE",
    );
  }

  Widget _buildCurrencySelection() {
    return CurrencySelection(
      onCurrencySelected: (currencyISOCode) {
        setState(() {
          DataProvider.of(context).settings.currencyISOCode = currencyISOCode;
        });
      },
    );
  }

  Widget _buildSeparatorsSelection() {
    return CurrencySeparatorsSelection(
          (centSeparator, thousandSeparator) {
        setState(
              () {
            final settings = DataProvider.of(context).settings;
            settings.centSeparatorSymbol = centSeparator;
            settings.thousandSeparatorSymbol =
                thousandSeparator;
          },
        );
      },
    );
  }
}
