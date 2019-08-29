import 'package:cash_cockpit_app/core/settings.dart';
import 'package:cash_cockpit_app/data/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/currency.dart';

class CurrencySelection extends StatelessWidget {
  final Function(String currencyISOCode, Settings settings) onCurrencySelected;

  const CurrencySelection({this.onCurrencySelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 500),
      child: Column(
        children: <Widget>[
          Text(
            "Currency",
            style: TextStyle(fontSize: 16),
          ),
          BlocBuilder(
            bloc: BlocProvider.of<DataBloc>(context),
            builder: (context, state) {
              var settings = Settings.defaultSettings();
              if(state is SetupSettingsState) settings = state.settings;
              if(state is DataAvailableState) settings = state.settings;

              return GridView.count(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                crossAxisCount: 5,
                children: Currency.defaultCurrencies
                    .map((currency) => _buildChipForCurrency(currency, settings, context))
                    .toList(),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildChipForCurrency(
      Currency currency, Settings settings, BuildContext context) {
    return ChoiceChip(
      label: Text(currency.isoCode),
      selected: _isCurrencyActiveCurrency(currency, context),
      onSelected: (value) {
        onCurrencySelected(currency.isoCode, settings);
      },
    );
  }

  bool _isCurrencyActiveCurrency(Currency currency, BuildContext context) {
    final state = BlocProvider.of<DataBloc>(context).currentState;
    if (state is SetupSettingsState) {
      return state.settings.currencyISOCode == currency.isoCode;
    } else {
      return false;
    }
  }
}
