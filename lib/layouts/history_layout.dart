import 'package:cash_cockpit_app/data/blocs/blocs.dart';
import 'package:cash_cockpit_app/data/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/bill_item.dart';
import '../pages/bill_page.dart';

class HistoryLayout extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<DataBloc>(context),
      builder: (context, state){
        if(state is DataAvailableState){
          return ListView.separated(
            itemBuilder: (context, index) {
              final bill = state.bills.elementAt(index);
              return BillItem(
                bill,
                state.settings,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BillPage(bill, true, state.categories, state.settings)));
                },
              );
            },
            separatorBuilder: (context, index) => Divider(),
            itemCount: state.bills.length,
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
