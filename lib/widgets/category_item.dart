import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

import '../core/category.dart';

import '../data/data_provider.dart';
import '../data/data_manager.dart' as dataManager;

class CategoryItem extends StatefulWidget {

  final bool editMode;
  final Category category;
  final Function onCategorySelected;

  const CategoryItem(this.category, {this.editMode = false, this.onCategorySelected(Category category), Key key}) : super(key: key);

  @override
  _CategoryItemState createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {

  String _name;

  @override
  void initState() {
    super.initState();
    _name = widget.category.name;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: widget.category.usableColor,
        child: widget.editMode
            ? IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => _showSelectColorDialog(context),
              )
            : null,
      ),
      title: _buildTitle(),
      subtitle: _buildSubtitle(),
      trailing: _buildTrailing(),
    );
  }

  Widget _buildTitle() {
    if (widget.editMode) {
      return TextField(
        controller: TextEditingController(text: _name)
          ..selection = TextSelection.collapsed(offset: _name.length),
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
        onChanged: (value) {
          setState(() {
            _name = value;
          });
        },
      );
    } else {
      return Text(widget.category.name);
    }
  }

  Widget _buildSubtitle() {
    return widget.editMode
        ? Text("Click to change this title")
        : null;
  }

  Widget _buildTrailing() {
    if (widget.editMode) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _name != widget.category.name
              ? IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () {
                    widget.category.name = _name;
                    dataManager.updateCategory(widget.category, DataProvider.of(context).firebaseUser.uid);
                  },
                )
              : Container(),
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () => _showDeleteConfirmDialog(context),
          ),
        ],
      );
    } else {
      return MaterialButton(
        child: Text("SELECT"),
        onPressed: () => widget.onCategorySelected(widget.category),
      );
    }
  }

  void _showDeleteConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("Delete ${widget.category.name}"),
            content:
                Text("Do you really want to delete this category permanently"),
            actions: <Widget>[
              MaterialButton(
                child: Text("CANCEL"),
                onPressed: () => Navigator.pop(context),
              ),
              MaterialButton(
                child: Text("DELETE"),
                onPressed: () {
                  dataManager.deleteCategory(widget.category);
                  Navigator.pop(context);
                },
              )
            ],
          ),
    );
  }

  void _showSelectColorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Category color"),
          content: MaterialColorPicker(
            onColorChange: (Color color) {
              setState(() {
                widget.category.color = color.value.toString();
              });
              dataManager.updateCategory(widget.category, DataProvider.of(context).firebaseUser.uid);
            },
            selectedColor: widget.category.usableColor,
          ),
          actions: <Widget>[
            MaterialButton(
              child: Text("CLOSE"),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      },
    );
  }
}
