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

  @override
  void initState() {
    super.initState();
    _dataBloc = BlocProvider.of<DataBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
    _dataBloc.dispatch(SetSettingsEvent());
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
    return BlocBuilder(
      bloc: BlocProvider.of<DataBloc>(context),
      builder: (context, state) {
        if (state is DataAvailableState) {
          return AmountText(
            state.settings,
            amount: 1000,
            lowerText: "EXAMPLE",
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
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
          onPressed: () => Navigator.pop(context),
        ),
      ];
    } else {
      return null;
    }
  }
}
