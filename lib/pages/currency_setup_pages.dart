import 'package:cash_cockpit_app/core/core.dart';
import 'package:cash_cockpit_app/data/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/amount_text.dart';
import '../widgets/currency_selection.dart';
import '../widgets/currency_separators_selection.dart';

class CurrencySetupPage extends StatefulWidget {
  final bool showBackButton, showDoneButton;

  const CurrencySetupPage(
      {this.showBackButton = true, this.showDoneButton = true});

  @override
  _CurrencySetupPageState createState() => _CurrencySetupPageState();
}

class _CurrencySetupPageState extends State<CurrencySetupPage> {

  DataBloc _dataBloc;
  Settings _settings = Settings.defaultSettings();

  @override
  void initState() {
    super.initState();
    _dataBloc = BlocProvider.of<DataBloc>(context);

    final state = _dataBloc.currentState;
    if(state is DataAvailableState) _settings = _settings;
    if(state is SetupSettingsState) _settings = _settings;
  }

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
        actions: _buildActions(),
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
    final state = BlocProvider.of<DataBloc>(context).currentState;
    var settings = Settings.defaultSettings();
    if(state is SetupSettingsState) settings = settings;
    if(state is DataAvailableState) settings = settings;

    return AmountText(
      settings,
      amount: 1000,
      lowerText: "EXAMPLE",
    );
  }

  Widget _buildCurrencySelection() {
    return CurrencySelection(
      onCurrencySelected: (currencyISOCode, settings) {
        setState(() {
          settings.currencyISOCode = currencyISOCode;
        });
      },
    );
  }

  Widget _buildSeparatorsSelection() {
    return CurrencySeparatorsSelection(
      (centSeparator, thousandSeparator, settings) {
        setState(
          () {
            settings.centSeparatorSymbol = centSeparator;
            settings.thousandSeparatorSymbol = thousandSeparator;
          },
        );
      },
    );
  }

  List<Widget> _buildActions() {
    if (widget.showDoneButton) {
      return <Widget>[
        IconButton(
          icon: Icon(Icons.check),
          onPressed: (){
            _dataBloc.dispatch(SetSettingsEvent(_settings));
            Navigator.pop(context);
            _dataBloc.dispatch(SetupDataEvent(DateTime.now()));
          },
        ),
      ];
    } else {
      return null;
    }
  }
}
