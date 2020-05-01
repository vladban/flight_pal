import 'package:flutter/material.dart';
import 'package:flightpal/root_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flight Pal',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: RootPage()
    );
  }

}
