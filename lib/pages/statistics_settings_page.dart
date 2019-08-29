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

  @override
  void initState() {
    super.initState();
    _dataBloc = BlocProvider.of<DataBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Statistics Settings"),
      ),
      body: BlocBuilder(
        bloc: _dataBloc,
        builder: (context, state) {
          if (state is DataAvailableState) {
            return Column(
              children: <Widget>[
                AmountText(
                  state.settings,
                  lowerText: "BALANCE",
                  amount: state.settings.balance,
                  editable: true,
                  onTextChanged: (newBalance) {
                    state.settings.balance = newBalance;
                  },
                ),
                AmountText(
                  state.settings,
                  lowerText: "MONTHLY SAVEUPS",
                  amount: state.settings.desiredMonthlySaveUps,
                  editable: true,
                  onTextChanged: (newMonthlySaveUps){
                    state.settings.desiredMonthlySaveUps = newMonthlySaveUps;
                  },
                ),
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
    _dataBloc.dispatch(SetSettingsEvent());
  }
}
