import 'package:cash_cockpit_app/data/blocs/auth_bloc/bloc.dart';
import 'package:cash_cockpit_app/data/blocs/blocs.dart';
import 'package:cash_cockpit_app/data/data_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import '../layouts/home_layout.dart';
import '../layouts/history_layout.dart';
import '../layouts/settings_layout.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  final _bodies = [
    HomeLayout(),
    HistoryLayout(),
    SettingsLayout(),
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "CashCockpit",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        actions: <Widget>[
          Container(
            child: BlocBuilder(
              bloc: BlocProvider.of<DataBloc>(context),
              builder: (context, state){
                if(state is DataAvailableState){
                  return InkWell(
                    onTap: () => _showMonthPicker(state.month),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        items: [
                          DropdownMenuItem(
                              child: Text(state.monthAsString)),
                          DropdownMenuItem(
                            child: Text("CHANGE"),
                            value: "change",
                          )
                        ],
                        onChanged: (value) {
                          if (value == "change") _showMonthPicker(state.month);
                        },
                      ),
                    ),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          )
        ],
      ),
      body: _bodies.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Container(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            title: Container(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Container(),
          )
        ],
        currentIndex: _selectedIndex,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
      ),
    );
  }

  void _showMonthPicker(DateTime month) {
    showMonthPicker(
      context: context,
      initialDate: month,
    ).then((DateTime dateTime) {
      if (dateTime == null) return;
      setState(() {
        BlocProvider.of<DataBloc>(context).dispatch(SetupDataEvent(dateTime));
      });
    });
  }
}
