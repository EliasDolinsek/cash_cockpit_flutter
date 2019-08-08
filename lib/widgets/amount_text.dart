import 'package:flutter/material.dart';

import '../data/config_provider.dart';

class AmountText extends StatefulWidget {
  final double amount;
  final String lowerText;
  final bool editable, redWhenNegative, autoFocus;
  final Function onTextChanged;

  const AmountText(
      {this.amount = 0.0,
      this.lowerText = "",
      this.editable = false,
      this.onTextChanged(value),
      this.redWhenNegative = false,
      this.autoFocus = false});

  @override
  _AmountTextState createState() => _AmountTextState();
}

class _AmountTextState extends State<AmountText> {
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.autoFocus) {
      Future.delayed(
          Duration.zero, () => FocusScope.of(context).requestFocus(_focusNode));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildAmountText(context),
          Text(
            widget.lowerText,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 0.1),
          )
        ],
      ),
    );
  }

  Widget _buildAmountText(BuildContext context) {
    final style = TextStyle(
        fontSize: 34,
        letterSpacing: 0.25,
        color: widget.redWhenNegative && widget.amount < 0
            ? Colors.red
            : Colors.black);
    final dataProvider = ConfigProvider.of(context);

    final currencyController = dataProvider.settings.currencyFormatter
        .getCurrencyTextController(widget.amount ?? 0.0, (value) {
      widget.onTextChanged(value);
    });

    return widget.editable
        ? TextField(
            controller: currencyController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Amount",
            ),
            textAlign: TextAlign.center,
            style: style,
            keyboardType: TextInputType.numberWithOptions(
                signed: widget.amount < 0, decimal: true),
            focusNode: _focusNode,
          )
        : Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              dataProvider.settings.currencyFormatter
                  .formatAmount(widget.amount ?? 0.0),
              style: style,
            ),
          );
  }
}
