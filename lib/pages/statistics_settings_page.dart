import 'package:cash_cockpit_app/core/core.dart';
import 'package:cash_cockpit_app/data/blocs/blocs.dart';
import 'package:cash_cockpit_app/widgets/amount_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatisticsSettingsPage extends StatefulWidget {
  @override
  _StatisticsSettingsPageState createState() => _StatisticsSettingsPageState();
}

class _StatisticsSettingsPageState extends State<StatisticsSettingsPage> {
  DataBloc _dataBloc;
  Settings _settings = Settings.defaultSettings();

  @override
  void initState() {
    super.initState();
    _dataBloc = BlocProvider.of<DataBloc>(context);

    final state = _dataBloc.currentState;
    if (state is DataAvailableState) _settings = state.settings;
    if (state is SetupSettingsState) _settings = state.settings;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Statistics Settings", style: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      body: BlocBuilder(
        bloc: _dataBloc,
        builder: (context, state) {
          if (state is DataAvailableState) {
            return ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      AmountText(
                        _settings,
                        lowerText: "BALANCE",
                        amount: _settings.balance,
                        editable: true,
                        onTextChanged: (newBalance) {
                          _settings.balance = newBalance;
                        },
                        autoFocus: true,
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        "With the balance field, you can set your total balance of all your bank accounts. This isn't reqired, but nessessary to display proper values.",
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 32.0),
                      AmountText(
                        _settings,
                        lowerText: "MONTHLY SAVEUPS",
                        amount: _settings.desiredMonthlySaveUps,
                        editable: true,
                        onTextChanged: (newMonthlySaveUps) {
                          _settings.desiredMonthlySaveUps = newMonthlySaveUps;
                        },
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        "Monthly saveups is a costumizable amount of how much you desire to save every month. This is used in statistics to display proper values.",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _dataBloc.dispatch(SetSettingsEvent(_settings));
  }
}
