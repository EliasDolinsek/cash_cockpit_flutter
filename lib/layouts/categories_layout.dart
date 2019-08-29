import 'package:cash_cockpit_app/data/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/category_item.dart';

import '../core/category.dart';

class CategoriesLayout extends StatelessWidget {
  final bool editMode;
  final Function onCategorySelected;

  const CategoriesLayout({
    this.editMode = false,
    this.onCategorySelected(Category category),
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<DataBloc>(context),
      builder: (context, state){
        if(state is DataAvailableState){
          return ListView.separated(
              itemBuilder: (context, index) {
                final category = state.categories.elementAt(index);
                return CategoryItem(
                  category,
                  key: Key(category.id),
                  editMode: editMode,
                  onCategorySelected: onCategorySelected,
                );
              },
              separatorBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(bottom: 4.0),
              ),
              itemCount: state.categories.length);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
