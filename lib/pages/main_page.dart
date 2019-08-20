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

  DataProvider month;

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
            child: InkWell(
              onTap: _showMonthPicker,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  items: [
                    DropdownMenuItem(
                        child: Text("MONTH_AS_STRING")), //TODO Add month as string
                    DropdownMenuItem(
                      child: Text("CHANGE"),
                      value: "change",
                    )
                  ],
                  onChanged: (value) {
                    if (value == "change") _showMonthPicker();
                  },
                ),
              ),
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

  void _showMonthPicker() {
    showMonthPicker(
      context: context,
      initialDate: month.month,
    ).then((DateTime dateTime) {
      if (dateTime == null) return;
      setState(() {
        month.month = dateTime;
      });
    });
  }
}
