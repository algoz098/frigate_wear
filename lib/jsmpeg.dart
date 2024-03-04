import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import 'model/api_model.dart';

class Jsmpeg extends StatefulWidget {
  Jsmpeg({Key? key}) : super(key: key);

  @override
  _JsmpegState createState() => _JsmpegState();
}

class _JsmpegState extends State<Jsmpeg> {
  String baseUrl = '';
  String imageUrl = '';
  bool loaded = false;
  String previousImageUrl = '';
  int counter = 0;
  int screenHeight = 150;
  Timer? _timer;

  getImgUrl() async {
    try {
      final apiModel = context.read<ApiModel>();
      String currentBaseUrl = await apiModel.getCurrentBaseUrl();
      baseUrl =
          '$currentBaseUrl/api/${apiModel.activeCamera}/latest.jpg?h=$screenHeight';
      imageUrl = '$baseUrl&counter=$counter';
      debugPrint('imageUrl: $imageUrl');
      loaded = true;
      return imageUrl;
    } catch (e) {
      loaded = true;
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
    getImgUrl();
    _timer =
        Timer.periodic(const Duration(seconds: 1), (Timer t) => _updateImage());
  }

  void _updateImage() async {
    var apiModel = context.read<ApiModel>();
    if (apiModel.activeCamera.isEmpty) {
      return;
    }

    counter++;
    debugPrint('update image: $counter');
    imageUrl = await getImgUrl();
    setState(() {
      imageUrl = imageUrl;
      previousImageUrl = imageUrl;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final apiModel = context.read<ApiModel>();

    if (!apiModel.loaded || !loaded) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (baseUrl.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            // Add a Text widget here (101 lines)
            child: Text(
              'Please set the external URL in the settings (tap on the screen to see it)',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    }

    if (apiModel.activeCamera.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            // Add a Text widget here (101 lines)
            child: Text(
              'Please select a camera (tap on the screen to see it)',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black, // Set the background color to black
      body: Center(
        child: FadeInImage.assetNetwork(
          placeholder: 'assets/loading.gif',
          image: imageUrl,
          fit: BoxFit.cover,
          imageErrorBuilder: (context, error, stackTrace) {
            return Text('An error occurred: $error');
          },
        ),
      ),
    );
  }
}
