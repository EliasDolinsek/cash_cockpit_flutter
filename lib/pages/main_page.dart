import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import '../layouts/history_layout.dart';
import '../layouts/settings_layout.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _bodies = [
    Text("HOME"),
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
            child: InkWell(
              onTap: _showMonthPicker,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  items: [
                    DropdownMenuItem(child: Text("JAN 2020")),
                    DropdownMenuItem(child: Text("CHANGE"), value: "change",)
                  ],
                  onChanged: (value) {
                    if(value == "change") _showMonthPicker();
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _selectedIndex == 0  ? FloatingActionButton.extended(onPressed: (){}, label: Text("ADD BILL")) : null,
    );
  }

  void _showMonthPicker(){
    showMonthPicker(context: context, initialDate: DateTime.now(),).then((DateTime dateTime){print(dateTime.toString());});
  }
}
