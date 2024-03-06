import 'package:flutter/material.dart';
import 'package:frigate_wear/jsmpeg.dart';
import 'package:provider/provider.dart';

import 'model/api_model.dart';

class FrigateDrawer extends StatelessWidget {
  final Function onCloseTap;
  final String? baseUrl;
  final bool? disabledPlayer;

  const FrigateDrawer(
      {super.key, required this.onCloseTap, this.baseUrl, this.disabledPlayer});

  @override
  Widget build(BuildContext context) {
    final apiModel = context.read<ApiModel>();
    return Drawer(
        backgroundColor: Colors.black,
        child: FutureBuilder<List<String>>(
          future: apiModel.getCameras(),
          builder:
              (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              );
            } else {
              return Container(
                color: Colors.black,
                child: GridView.builder(
                  padding: const EdgeInsets.all(15),
                  itemCount:
                      snapshot.data!.length + 3, // +1 for the settings icon
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // number of columns
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/settings');
                          },
                          child: const Column(
                            children: <Widget>[
                              Icon(Icons.settings,
                                  size: 50, color: Colors.grey),
                              Text(
                                'Settings',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ));
                    }

                    if (index == 1) {
                      return GestureDetector(
                          onTap: () {
                            onCloseTap('');
                          },
                          child: const Column(
                            children: <Widget>[
                              Icon(Icons.camera_alt_outlined,
                                  size: 50, color: Colors.grey),
                              Text(
                                'Cams Scroll',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ));
                    }
                    if (index == snapshot.data!.length + 2) {
                      return GestureDetector(
                          onTap: () {
                            onCloseTap(null);
                          },
                          child: const Column(
                            children: <Widget>[
                              Icon(Icons.arrow_back,
                                  size: 50, color: Colors.grey),
                              Text(
                                'Exit',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ));
                    }

                    String cameraName = snapshot.data![index - 2];
                    return GestureDetector(
                      onTap: () {
                        onCloseTap(cameraName);
                      },
                      child: Column(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(250),
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.rectangle,
                              ),
                              child: Jsmpeg(
                                disabled: disabledPlayer,
                                height: 50,
                                baseUrl: baseUrl ?? '',
                                cameraName: cameraName,
                              ),
                            ),
                          ),
                          Container(
                            width: 60, // Limit the width to 60px
                            child: Text(
                              cameraName,
                              style: const TextStyle(color: Colors.grey),
                              overflow: TextOverflow
                                  .ellipsis, // Cut off the text when it exceeds the width
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }
          },
        ));
  }
}
