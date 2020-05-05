import 'package:flightpal/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flightpal/parameters.dart';

class AirportFieldForm extends StatefulWidget {
  final TextEditingController _myController;

  AirportFieldForm(this._myController);

  @override
  _AirportFieldFormState createState() => _AirportFieldFormState();
}

class _AirportFieldFormState extends State<AirportFieldForm> {
  final validCharacters = RegExp(r'^[A-Z]+$');


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      child: TextFormField(
        style: TextStyle(
            color: textColor,
            fontSize: 26.0,
            decorationColor: textColor,
            fontWeight: FontWeight.bold),
        maxLength: 4,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintStyle: TextStyle(
              fontSize: 12.0, color: Colors.cyanAccent, fontWeight: FontWeight.normal),
          counter: SizedBox.shrink(),
          border: InputBorder.none,
          hintText: 'ICAO only',
        ),
        controller: widget._myController,
        onFieldSubmitted: (value) {
          String myText = widget._myController.text.toUpperCase();
            if (validCharacters.hasMatch(myText) &&
                myText.length == 4) {
              widget._myController.text = myText;
              if (widget._myController == depAirportController) depAirport = myText;
              if (widget._myController == arrAirportController) arrAirport = myText;
              print('Dep: $depAirport');
              print('Arr: $arrAirport');
             // if widget._myController == altAirportController altAirport = myText;
            } else {
              widget._myController.clear();
            }
            FocusScope.of(context).unfocus();
        },
      ),
      onFocusChange: (hasFocus) {
        if (hasFocus) {
          widget._myController.clear();
        }
      },
    );
  }
}
