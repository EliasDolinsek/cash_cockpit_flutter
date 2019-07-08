import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../data/data_provider.dart';

class HistoryLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: DataProvider.of(context).monthDataProvider.bills,
      builder: (context, snapshot){
        if(snapshot.hasData){
          return ListView(
            children: snapshot.data.documents.map((document) => Text(document.data.toString())).toList(),
          );
        } else {
          return Text("LOADING");
        }
      },
    );
  }
}
