import 'package:flutter/material.dart';

import '../data/data_provider.dart';

class AmountText extends StatefulWidget {

  final double amountText;
  final String lowerText;
  final bool editable;
  final Function onTextChanged;

  const AmountText({this.amountText = 0.0, this.lowerText = "", this.editable = false, this.onTextChanged(value)});

  @override
  _AmountTextState createState() => _AmountTextState();
}

class _AmountTextState extends State<AmountText> {
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildAmountText(context),
          Text(widget.lowerText, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 0.1),)
        ],
      ),
    );
  }

  Widget _buildAmountText(BuildContext context){
    final style = TextStyle(fontSize: 34, letterSpacing: 0.25);
    final currencyController = DataProvider.of(context).settings.currencyFormatter.getCurrencyTextController(widget.amountText ?? 0.0);

    currencyController.addListener((){
      widget.onTextChanged(currencyController.numberValue);
    });

    return TextField(
      controller: currencyController,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Amount",
      ),
      textAlign: TextAlign.center,
      style: style,
      keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
      onChanged: widget.onTextChanged ?? (value){},
      enabled: widget.editable,
    );
  }
}
