import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cash_cockpit_app/core/core.dart';
import 'package:cash_cockpit_app/data/data_providers/repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import './bloc.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  final repository = Repository();

  List<Category> _categories = [];
  List<Bill> _bills = [];
  Settings _settings;
  DateTime _month = DateTime.now();
  bool _categoriesListenerSetup = false;

  @override
  DataState get initialState => InitialDataState();

  @override
  Stream<DataState> mapEventToState(
    DataEvent event,
  ) async* {
    if (event is SetupDataEvent) {
      _month = event.month;
      repository.userID = (await FirebaseAuth.instance.currentUser()).uid;
      _settings = await Settings.fromFirebase(repository.userID);

      if (_settings == null) {
        dispatch(SetupSettingsEvent());
      } else {
        repository.billsOfMonth(monthAsString(event.month)).listen((bills) {
          if (event.month.isAtSameMomentAs(_month)) {
            _bills = bills;
            dispatch(DataUpdatedEvent(_bills, _categories, _settings));
          }
        });

        if (!_categoriesListenerSetup) {
          _categoriesListenerSetup = true;
          repository.categories().listen((categories) {
            _categories = categories;
            dispatch(DataUpdatedEvent(_bills, _categories, _settings));
          });
        }
      }
    } else if (event is DataUpdatedEvent) {
      yield DataAvailableState(
          event.bills, event.categories, event.settings, _month);
    } else if (event is CreateBill) {
      repository.createBill(event.bill);
    } else if (event is UpdateBill) {
      repository.updateBill(event.bill);
    } else if (event is DeleteBill) {
      repository.deleteBill(event.bill);
    } else if (event is CreateCategory) {
      repository.createCategory(event.category);
    } else if (event is CreateDefaultCategories) {
      repository.createDefaultCategories();
    } else if (event is UpdateCategory) {
      repository.updateCategory(event.category);
    } else if (event is DeleteCategory) {
      repository.deleteCategory(event.category);
    }
    //TODO continue

    else if (event is SetupSettingsEvent) {
      yield SetupSettingsState(_settings);
    } else if (event is SetSettingsEvent) {
      _settings = event.settings;
      _settings.areDefaultSettings = false;
      repository.setUserSettings(_settings);
    }
  }

  static String monthAsString(DateTime month) =>
      DateFormat("MMM yyyy").format(month).toUpperCase();
}
