import 'package:flutter/material.dart';

class AmountText extends StatelessWidget {

  final String upperText;
  final String lowerText;

  const AmountText({this.upperText = "", this.lowerText = ""});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(upperText, textAlign: TextAlign.center, style: TextStyle(fontSize: 34, letterSpacing: 0.25),),
          Text(lowerText, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 0.1),)
        ],
      ),
    );
  }
}
