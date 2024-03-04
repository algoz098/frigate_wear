import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/api_model.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FocusNode internalFocusNode = FocusNode();
  FocusNode externalFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    internalFocusNode.addListener(() {
      if (internalFocusNode.hasFocus) return;
      Navigator.of(context).pop();
    });

    externalFocusNode.addListener(() {
      if (externalFocusNode.hasFocus) return;
      Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    internalFocusNode.dispose();
    externalFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final apiModel = context.read<ApiModel>();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: ListView(
            children: <Widget>[
              ListTile(
                textColor: Colors.white,
                leading: Icon(Icons.link),
                title: Text('External URL'),
                subtitle: Text(apiModel.externalUrl),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: TextField(
                          autofocus: true,
                          focusNode: externalFocusNode,
                          controller:
                              TextEditingController(text: apiModel.externalUrl),
                          onSubmitted: (value) {
                            apiModel.setExternallUrl(value);
                            Navigator.of(context).pop();
                          },
                        ),
                      );
                    },
                  );
                },
              ),
              ListTile(
                textColor: Colors.white,
                leading: Icon(Icons.link),
                title: Text('Internal URL'),
                subtitle: Text(apiModel.internalUrl),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: TextField(
                          autofocus: true,
                          controller:
                              TextEditingController(text: apiModel.internalUrl),
                          focusNode: internalFocusNode,
                          onSubmitted: (value) {
                            apiModel.setInternalUrl(value);
                            Navigator.of(context).pop();
                          },
                        ),
                      );
                    },
                  );
                },
              ),
              ListTile(
                textColor: Colors.white,
                leading: Icon(Icons.link),
                title: Text('Internal networks'),
                subtitle: Text(
                    '${apiModel.internalNetworks.length.toString()} networks'),
                onTap: () {
                  Navigator.pushNamed(context, '/wifi-settings');
                },
              ),
              apiModel.externalUrl.isEmpty
                  ? ListTile(
                      title: Text(
                        'Please set the external URL before exiting',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : ListTile(
                      title: Text('Go back'),
                      textColor: Colors.white,
                      leading: Icon(Icons.arrow_back),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
            ],
          ), // END: ed8c6549bwf9
        ),
      ),
    );
  }
}
