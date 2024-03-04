import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/api_model.dart';

class WifiSettings extends StatefulWidget {
  const WifiSettings({super.key});

  @override
  State<WifiSettings> createState() => _WifiSettingsState();
}

class _WifiSettingsState extends State<WifiSettings> {
  final FocusNode addNetworkFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    addNetworkFocusNode.addListener(() {
      if (addNetworkFocusNode.hasFocus) return;
      Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    super.dispose();
    addNetworkFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final apiModel = context.watch<ApiModel>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: ListView(children: [
            ListTile(
              textColor: Colors.white,
              leading: Icon(Icons.add),
              title: Text('Add Network'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: TextField(
                        autofocus: true,
                        focusNode: addNetworkFocusNode,
                        onSubmitted: (value) {
                          apiModel.setInternalNetwork(
                              apiModel.internalNetworks + [value]);
                          Navigator.of(context).pop();
                        },
                      ),
                    );
                  },
                );
              },
            ),
            ...apiModel.internalNetworks.map((network) {
              return ListTile(
                textColor: Colors.white,
                leading: Icon(Icons.link),
                title: Text(network),
                onTap: () {
                  // prompt to confirm removal
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          'Remove Network?',
                          style: TextStyle(fontSize: 11),
                        ),
                        content: SizedBox
                            .shrink(), // Adicionado para diminuir o espaço
                        actions: <Widget>[
                          TextButton(
                            child: Text(
                              'Yes',
                              style: TextStyle(fontSize: 11),
                            ),
                            onPressed: () {
                              apiModel.setInternalNetwork(apiModel
                                  .internalNetworks
                                  .where((element) => element != network)
                                  .toList());
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            }).toList(),
          ]),
        ),
      ),
    );
  }
}
