import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import 'model/api_model.dart';

class Jsmpeg extends StatefulWidget {
  final int height;
  final String baseUrl;
  final String? cameraName;
  final bool? disabled;

  Jsmpeg(
      {Key? key,
      required this.height,
      required this.baseUrl,
      this.cameraName,
      this.disabled})
      : super(key: key);

  @override
  _JsmpegState createState() => _JsmpegState();
}

class _JsmpegState extends State<Jsmpeg> {
  String cameraUrl = '';
  String imageUrl = '';
  bool loaded = false;
  String previousImageUrl = '';
  int counter = 0;
  int screenHeight = 150;
  Timer? _timer;

  getImgUrl() async {
    try {
      cameraUrl =
          '${widget.baseUrl}/${widget.cameraName}/latest.jpg?h=$screenHeight';
      imageUrl = '$cameraUrl&counter=$counter';
      debugPrint('imageUrl: $imageUrl');
      setState(() {
        loaded = true;
      });
      return imageUrl;
    } catch (e) {
      setState(() {
        loaded = true;
      });

      throw e;
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      screenHeight = MediaQuery.of(context).size.height.toInt();
      debugPrint('Screen height: $screenHeight');
    });
    getImgUrl();
    _timer = Timer.periodic(
        const Duration(milliseconds: 500), (Timer t) => _updateImage());
  }

  void _updateImage() async {
    if (widget.cameraName == null) {
      return;
    }

    if (widget.disabled == true) {
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
    if (widget.cameraName == null) {
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
