import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/api_model.dart';

class FrigateDrawer extends StatelessWidget {
  final Function onCloseTap;

  FrigateDrawer({required this.onCloseTap});

  @override
  Widget build(BuildContext context) {
    final apiModel = context.read<ApiModel>();
    return Drawer(
      backgroundColor: Colors.black,
      child: ListView(
        padding: EdgeInsets.all(10.0), // Adicione padding aqui
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(
              'Settings',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          FutureBuilder<List<String>>(
            future: apiModel.getCameras(),
            builder:
                (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(color: Colors.white),
                );
              } else {
                return Column(
                  children: snapshot.data!.map((camera) {
                    return ListTile(
                      leading: Icon(Icons.camera),
                      title: Text(camera),
                      textColor: Colors.white,
                      onTap: () {
                        apiModel.setActiveCamera(camera);
                        onCloseTap();
                      },
                    );
                  }).toList(),
                );
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.arrow_back),
            title: Text(
              'Exit',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              onCloseTap();
            },
          ),
        ],
      ),
    );
  }
}
