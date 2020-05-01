import 'package:flutter/material.dart';
import 'package:flightpal/home_page.dart';


class RootPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _RootPageState();
  }
}


class _RootPageState extends State<RootPage> {

  @override
  Widget build(BuildContext context) {

    // Here we can call different pages (switch, etc.)
    return HomePage();
  }
}