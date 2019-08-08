import 'package:flutter/material.dart';

import '../data/config_provider.dart';

class CurrencySeparatorsSelection extends StatelessWidget {
  final Function(String centSeparationSymbol, String thousandSeparationSymbol)
      onSelected;

  const CurrencySeparatorsSelection(this.onSelected);

  @override
  Widget build(BuildContext context) {
    final settings = ConfigProvider.of(context).settings;
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
                onSelected(",", ".");
              },
            ),
            SizedBox(width: 8.0,),
            ChoiceChip(
              label: Text("American system"),
              selected: settings.centSeparatorSymbol == "." && settings.thousandSeparatorSymbol == ",",
              onSelected: (value){
                onSelected(".", ",");
              },
            )
          ],
        )
      ],
    );
  }
}
