import 'package:cash_cockpit_app/data/config_provider.dart';
import 'package:cash_cockpit_app/data/data_provider.dart';
import 'package:flutter/material.dart';

import 'currency_setup_pages.dart';
import 'main_page.dart';

class WelcomePage extends StatelessWidget {

  final DataProvider dataProvider;

  const WelcomePage({Key key, this.dataProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    createDefaultCategoriesIfNoExist(context);
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Hello",
                    style: TextStyle(fontSize: 48),
                  ),
                  Text("Thank you for purchasing CashCockpit!")
                ],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "Specifie your prefered currency settings to complete the setup",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    OutlineButton(
                      child: Text("SPECIEFIE CURRENCY SETTINGS"),
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (context) => CurrencySetupPage(
                                      showBackButton: false,
                                    )))
                            .whenComplete(() {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => MainPage()));
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void createDefaultCategoriesIfNoExist(BuildContext context) async {
    if (dataProvider.bills.length == 0) {
      ConfigProvider.of(context).createDefaultCategories();
    }
  }
}
