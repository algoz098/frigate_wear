import 'package:flutter/material.dart';
import 'package:frigate_wear/jsmpeg.dart';
import 'package:frigate_wear/frigate_drawer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: GestureDetector(
        onTap: () {
          _scaffoldKey.currentState?.openDrawer();
        },
        child: Jsmpeg(),
      ),
      drawer: FrigateDrawer(
        onCloseTap: () {
          _scaffoldKey.currentState?.closeDrawer();
        },
      ),
    );
  }
}
