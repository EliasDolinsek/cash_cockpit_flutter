import 'package:flutter/material.dart';

import '../data/data_provider.dart';
import '../core/currency.dart';

class CurrencySelection extends StatefulWidget {
  final Function(String currencyISOCode) onCurrencySelected;

  const CurrencySelection({this.onCurrencySelected});

  @override
  _CurrencySelectionState createState() => _CurrencySelectionState();
}

class _CurrencySelectionState extends State<CurrencySelection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text("Currency", style: TextStyle(fontSize: 16),),
        GridView.count(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          crossAxisCount: 5,
          children: Currency.defaultCurrencies
              .map((currency) => _buildChipForCurrency(currency))
              .toList(),
        )
      ],
    );
  }

  Widget _buildChipForCurrency(Currency currency) {
    return ActionChip(
      label: Text(currency.isoCode),
      onPressed: () => widget.onCurrencySelected(currency.isoCode),
      backgroundColor: DataProvider.of(context).settings.currencyISOCode == currency.isoCode ? Theme.of(context).primaryColor : Colors.grey,
    );
  }
}
