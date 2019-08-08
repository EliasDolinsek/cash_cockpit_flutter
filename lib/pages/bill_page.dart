import 'package:cash_cockpit_app/core/category.dart';
import 'package:cash_cockpit_app/data/config_provider.dart';
import 'package:cash_cockpit_app/data/data_provider.dart';
import 'package:flutter/material.dart';

import '../core/bill.dart';

import '../widgets/amount_text.dart';
import '../layouts/images_list.dart';

import 'select_category_page.dart';

import '../data/config_provider.dart';

class BillPage extends StatefulWidget {

  final Bill bill;
  final bool editMode;
  final DataProvider dataProvider;

  const BillPage(this.bill, this.editMode, this.dataProvider);

  @override
  _BillPageState createState() => _BillPageState();
}

class _BillPageState extends State<BillPage> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  ConfigProvider _dataProvider;
  TextEditingController _nameController;

  int _billType;
  double _amount;
  String _name;
  Category _category;

  @override
  void initState() {
    super.initState();
    _billType = widget.bill.billType;
    _amount = widget.bill.amount;
    _name = widget.bill.name;
    _nameController = TextEditingController(text: _name)
      ..selection = TextSelection.collapsed(offset: _name.length);
    _category = widget.dataProvider.categories.firstWhere((c) =>c.billIDs.contains(widget.bill.id), orElse: () => null);
    
    Future.delayed(Duration.zero, (){
      _dataProvider = ConfigProvider.of(context);
    });
  }

  @override
  void dispose() {
    if (widget.editMode) {
      updateBill();
      updateCategory(widget.bill.id);
    }

    super.dispose();
  }

  void updateCategory(String billID) {
    if (_category != null) {
      print(_category.billIDs);
      if (!_category.billIDs.contains(billID)) _category.billIDs.add(billID);
      _dataProvider.updateCategory(_category);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_name.isNotEmpty ? _name : "Bill",
            style: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        actions: _buildActions(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Flexible(
              flex: 3,
              child: AmountText(
                amount: _amount,
                lowerText: "Amount",
                editable: true,
                autoFocus: true,
                onTextChanged: (value) {
                  _amount = value;
                },
              ),
            ),
            Flexible(
                flex: 7,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 16.0),
                    _buildBillTypeSelection(),
                    SizedBox(height: 16.0),
                    _buildNameField(),
                    SizedBox(height: 8.0),
                    _buildCategoryListTitle(),
                    SizedBox(height: 8.0),
                    Container(
                      child: ImagesList(widget.bill),
                      constraints: BoxConstraints(maxHeight: 100),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  List<Widget> _buildActions() {
    if (widget.editMode) {
      return [
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            showDeleteDialog();
          },
        )
      ];
    } else {
      return [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            updateBill();
            Navigator.pop(context);
          },
        )
      ];
    }
  }

  Widget _buildBillTypeSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ChoiceChip(
          avatar: CircleAvatar(
            child: Text("+"),
          ),
          label: Text("INCOME"),
          selected: _billType == Bill.income,
          onSelected: (value) {
            setState(() {
              _billType = Bill.income;
            });
          },
        ),
        SizedBox(width: 16.0),
        ChoiceChip(
          avatar: CircleAvatar(
            child: Text("-"),
          ),
          label: Text("OUTCOME"),
          selected: _billType == Bill.outcome,
          onSelected: (value) {
            setState(() {
              _billType = Bill.outcome;
            });
          },
        )
      ],
    );
  }

  void updateBill() {
    widget.bill.name = _name;
    widget.bill.billType = _billType;
    widget.bill.amount = _amount;

    if (widget.editMode) {
      _dataProvider.updateBill(widget.bill);
    } else {
      _dataProvider
          .createBill(widget.bill)
          .then((billID) => updateCategory(billID));
    }
  }

  Widget _buildNameField() {
    return TextField(
      decoration:
          InputDecoration(border: OutlineInputBorder(), hintText: "Name"),
      controller: _nameController,
      onChanged: (value) {
        setState(() {
          _name = value;
        });
      },
    );
  }

  Widget _buildCategoryListTitle() {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor:
            _category == null ? Colors.black : Color(int.parse(_category.color)),
      ),
      title: Text(_category == null ? "No category" : _category.name),
      trailing: MaterialButton(
        onPressed: () {
          Navigator.of(context)
              .push(
                  MaterialPageRoute(builder: (context) => SelectCategoryPage()))
              .then((category) {
            setState(() {
              this._category = category;
            });
          });
        },
        child: Text("CHANGE"),
      ),
    );
  }

  void showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete bill"),
        content: Text("Do you really want to delete this bill?"),
        actions: <Widget>[
          MaterialButton(
            child: Text("CANCEL"),
            onPressed: () => Navigator.pop(context),
          ),
          MaterialButton(
            child: Text("DELETE"),
            onPressed: () {
              _dataProvider.deleteBill(widget.bill);
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          )
        ],
      ),
    );
  }
}
