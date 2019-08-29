import 'package:cash_cockpit_app/core/core.dart';
import 'package:cash_cockpit_app/data/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrencySeparatorsSelection extends StatelessWidget {
  final Function(String centSeparationSymbol, String thousandSeparationSymbol, Settings settings)
      onSelected;

  const CurrencySeparatorsSelection(this.onSelected);

  @override
  Widget build(BuildContext context) {
    final state = BlocProvider.of<DataBloc>(context).currentState;
    if(state is SetupSettingsState){
      return _buildSeparatorSettings(state.settings);
    } else if (state is DataAvailableState){
      return _buildSeparatorSettings(state.settings);
    } else {
      return Center(
        child: Text("Couldn't load settings")
      );
    }

  }

  Widget _buildSeparatorSettings(Settings settings){
    return Column(
      children: <Widget>[
        Text(
          "Separators",
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 16.0,),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ChoiceChip(
              label: Text("European system"),
              selected: settings.centSeparatorSymbol == "," && settings.thousandSeparatorSymbol == ".",
              onSelected: (value){
                onSelected(",", ".", settings);
              },
            ),
            SizedBox(width: 8.0,),
            ChoiceChip(
              label: Text("American system"),
              selected: settings.centSeparatorSymbol == "." && settings.thousandSeparatorSymbol == ",",
              onSelected: (value){
                onSelected(".", ",", settings);
              },
            )
          ],
        )
      ],
    );
  }
}
