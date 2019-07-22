import 'package:flutter/material.dart';

class StatisticsCard extends StatelessWidget {

  final Widget title, options, statistic, bottomAction;

  const StatisticsCard({this.title, this.options, this.statistic, this.bottomAction});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            title ?? Container(),
            SizedBox(height: 8.0),
            options ?? Container(),
            SizedBox(height: 8.0),
            statistic ?? Container(),
            SizedBox(height: 8.0),
            bottomAction ?? Container()
          ],
        ),
      ),
    );
  }
}

enum DefaultStatisticsOptions {

  outcomeBased, incomeBased, usageBased, amountBased

}
