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
  Settings _settings = Settings.defaultSettings();

  @override
  DataState get initialState => InitialDataState();

  @override
  Stream<DataState> mapEventToState(
    DataEvent event,
  ) async* {
    if (event is SetupDataEvent) {
      repository.userID = (await FirebaseAuth.instance.currentUser()).uid;
      _settings = await Settings.fromFirebase(repository.userID);

      repository.billsOfMonth(monthAsString(event.month)).listen((bills){
        _bills = bills;
        dispatch(DataUpdatedEvent(_bills, _categories, _settings));
      });

      repository.categories().listen((categories){
        _categories = categories;
        dispatch(DataUpdatedEvent(_bills, _categories, _settings));
      });

    } else if(event is DataUpdatedEvent){
      yield DataAvailableState(event.bills, event.categories, event.settings);
    }
  }

  String monthAsString(DateTime month) =>
      DateFormat("MMM yyyy").format(month).toUpperCase();
}
