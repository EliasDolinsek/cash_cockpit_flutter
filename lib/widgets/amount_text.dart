import 'package:cash_cockpit_app/data/data_provider.dart';
import 'package:flutter/material.dart';

class AmountText extends StatelessWidget {

  final String upperText;
  final String lowerText;
  final bool editable;
  final Function onTextChanged;

  const AmountText({this.upperText = "", this.lowerText = "", this.editable = false, this.onTextChanged(value)});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildAmountText(context),
          Text(lowerText, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 0.1),)
        ],
      ),
    );
  }

  Widget _buildAmountText(BuildContext context){
    final style = TextStyle(fontSize: 34, letterSpacing: 0.25);
    if(editable){
      return TextField(
        controller: DataProvider.of(context).settings.currencyFormatter.getCurrencyTextController(upperText),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Amount",
        ),
        textAlign: TextAlign.center,
        style: style,
        keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
        onChanged: onTextChanged ?? (value){
          print(value);
        },
      );
    } else {
      return Text(upperText, textAlign: TextAlign.center, style: style,);
    }
  }
}
