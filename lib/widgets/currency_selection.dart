import 'package:flutter/material.dart';

import '../data/data_provider.dart';
import '../core/currency.dart';

class CurrencySelection extends StatelessWidget
{
  final Function(String currencyISOCode) onCurrencySelected;

  const CurrencySelection({this.onCurrencySelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 500),
      child: Column(
        children: <Widget>[
          Text("Currency", style: TextStyle(fontSize: 16),),
          GridView.count(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            crossAxisCount: 5,
            children: Currency.defaultCurrencies
                .map((currency) => _buildChipForCurrency(currency, context))
                .toList(),
          )
        ],
      ),
    );
  }

  Widget _buildChipForCurrency(Currency currency, BuildContext context) {
    return ChoiceChip(
      label: Text(currency.isoCode),
      selected: _isCurrencyActiveCurrency(currency, context),
      onSelected: (value){
        onCurrencySelected(currency.isoCode);
      },
    );
  }

  bool _isCurrencyActiveCurrency(Currency currency, BuildContext context){
    return DataProvider.of(context).settings.currencyISOCode == currency.isoCode;
  }
}
