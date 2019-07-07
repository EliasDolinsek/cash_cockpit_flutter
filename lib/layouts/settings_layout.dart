import 'package:flutter/material.dart';

import '../pages/currency_setup_pages.dart';
import '../core/auth_manager.dart' as authManager;

class SettingsLayout extends StatefulWidget {
  @override
  _SettingsLayoutState createState() => _SettingsLayoutState();
}

class _SettingsLayoutState extends State<SettingsLayout> {
  List<Widget> settings;

  @override
  void initState() {
    super.initState();
    settings = [
      ListTile(
        title: Text("Currency and formatting settings"),
        subtitle: Text("Currency selection and separator settings for amounts"),
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => CurrencySetupPage()));
        },
      ),
      ListTile(
        title: Text("Categories"),
        subtitle: Text("Create, edit and delete categories"),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.separated(
              itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(
                      top: (index == 0 ? 8.0 : 0),
                      bottom: (index == settings.length ? 8.0 : 0),
                    ),
                    child: settings.elementAt(index),
                  ),
              separatorBuilder: (context, index) => Divider(),
              itemCount: settings.length),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            MaterialButton(
              child: Text("SIGN OUT"),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => _buildSignOutDialog(context));
              },
            ),
            MaterialButton(
              child: Text("HELP"),
            ),
            MaterialButton(
              child: Text("ABOUT"),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildSignOutDialog(BuildContext context) {
    return AlertDialog(
      title: Text("Sign out"),
      content: Text("Do you really want to sign out"),
      actions: <Widget>[
        MaterialButton(
          child: Text("CANCEL"),
          onPressed: () => Navigator.of(context).pop(),
        ),
        MaterialButton(
          child: Text("SIGN OUT"),
          onPressed: () {
            authManager.signOut();
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
