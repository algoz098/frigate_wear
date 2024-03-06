// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:frigate_wear/jsmpeg.dart';
import 'package:frigate_wear/frigate_drawer.dart';
import 'package:provider/provider.dart';

import 'model/api_model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int screenHeight = 150;
  String baseUrl = '';
  bool loaded = false;
  bool showAllCameras = false;
  bool disabledPlayer = true;
  String cameraActive = '';

  getBaseUrl() async {
    try {
      final apiModel = context.read<ApiModel>();
      String currentBaseUrl = await apiModel.getCurrentBaseUrl();
      baseUrl = '$currentBaseUrl/api';
      debugPrint('baseUrl: $baseUrl');
      setState(() {
        loaded = true;
      });
      return baseUrl;
    } catch (e) {
      debugPrint('Error: $e');
      setState(() {
        loaded = true;
      });
      throw e;
    }
  }

  @override
  void initState() {
    super.initState();
    final apiModel = context.read<ApiModel>();

    debugPrint('External URL: ${apiModel.externalUrl}');
    if (apiModel.externalUrl.isEmpty) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      screenHeight = MediaQuery.of(context).size.height.toInt();
      debugPrint('Screen height: $screenHeight');
    });

    getBaseUrl();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final apiModel = context.read<ApiModel>();

    if (!apiModel.loaded || !loaded) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(
                  height:
                      20), // Add space between the CircularProgressIndicator and Text
              Text('Loading...',
                  style: TextStyle(color: Colors.white)), // Add your text here
            ],
          ),
        ),
      );
    }

    var cam = Scaffold(
        backgroundColor: Colors.black,
        body: FutureBuilder<List<String>>(
            future: apiModel.getCameras(),
            builder:
                (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.white),
                );
              }

              return PageView.builder(
                itemCount: snapshot.data!.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  String cameraName = snapshot.data![index];
                  return Column(
                    children: [
                      Text(
                        '${DateTime.now().hour}:${DateTime.now().minute}',
                        style: TextStyle(color: Colors.white),
                      ),
                      Expanded(
                        child: Jsmpeg(
                          height: screenHeight,
                          baseUrl: baseUrl,
                          cameraName: cameraName,
                        ),
                      ),
                      Text(
                        '${index + 1}/${snapshot.data!.length}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  );
                },
              );
            }));

    if (cameraActive.isNotEmpty) {
      cam = Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            children: [
              Text(
                '${DateTime.now().hour}:${DateTime.now().minute}',
                style: TextStyle(color: Colors.white),
              ),
              Expanded(
                  child: Jsmpeg(
                      height: screenHeight,
                      baseUrl: baseUrl,
                      cameraName: cameraActive)),
              Text(
                '$cameraActive',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ));
    }

    return Scaffold(
      key: _scaffoldKey,
      body: GestureDetector(
        onTap: () {
          disabledPlayer = true;
          _scaffoldKey.currentState?.openDrawer();
        },
        onTapUp: (details) {},
        child: cam,
      ),
      drawer: FrigateDrawer(
        baseUrl: baseUrl,
        disabledPlayer: disabledPlayer,
        onCloseTap: (cameraNameRec) {
          _scaffoldKey.currentState?.closeDrawer();
          disabledPlayer = true;

          if (cameraNameRec != null) {
            setState(() {
              cameraActive = cameraNameRec;
            });
          }
        },
      ),
    );
  }
}
