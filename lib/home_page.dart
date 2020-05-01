import 'package:flutter/material.dart';
import 'package:flightpal/parameters.dart';
import 'dart:async';

enum AirportType { Departure, Arrival, Alternate }

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeStatePage();
  }
}

class _HomeStatePage extends State<HomePage> {
  String onMainPageText = 'ZZZZ';

  Timer _timer;

  String _timeString;
  String _dateString;

  DateTime now = DateTime.now().toUtc();
  DateTime blockOffTime;
  DateTime blockOnTime;

  String depAirport = 'ZZZZ';
  String arrAirport = 'ZZZZ';

  TextEditingController depAirportController;
  TextEditingController arrAirportController;

  @override
  void initState() {
    _dateString =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year.toString()}';
    _timeString = '${now.hour.toString()}:${now.minute.toString()}';

    depAirportController = TextEditingController(text: "ZZZZ");
    arrAirportController = TextEditingController(text: "ZZZZ");

    _timer =
        Timer.periodic(Duration(seconds: 1), (Timer t) => _getCurrentTime());

    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _getCurrentTime() {
    setState(() {
      now = DateTime.now().toUtc();
      _timeString = '${now.hour.toString()}:${now.minute.toString()}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: buildTitle() + buildAirports())),
      ),
    );
  }

  List<Widget> buildTitle() {
    return [
      Container(
          alignment: Alignment.centerLeft,
          //padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 15, bottom: 15),
          margin: EdgeInsets.only(left: 25.0, right: 20.0, top: 10, bottom: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'FlightPal 1.0',
                style: TextStyle(color: darkTextColor),
              ),
              SizedBox(height: 10.0),
              Text(
                _timeString + " UTC  " + _dateString,
                style: TextStyle(
                    color: textColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ))
    ];
  }

  List<Widget> buildAirports() {
    return [
      Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 15, bottom: 15),
        margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 10, bottom: 10),
        decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            color: containerColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.airplanemode_active,
                  color: iconBlue,
                  size: 24.0,
                ),
                SizedBox(height: 5.0),

                // Container(
                //  child:
                FlatButton(
                    color: containerColor,
                    child: Text(depAirport, style: TextStyle(color: textColor, fontSize: 26, fontWeight: FontWeight.bold)),
                    onPressed: () {_myDialog(AirportType.Departure);}
                 ),

                SizedBox(height: 3.0),
                Text('20:45Z',
                    style: TextStyle(color: darkTextColor, fontSize: 14))
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 5.0),
                Icon(
                  Icons.arrow_forward,
                  color: iconGreen,
                  size: 24.0,
                ),
                SizedBox(height: 3.0),
                Text('RA02772',
                    style: TextStyle(color: textColor, fontSize: 16)),
                //Text('RA02772', style: TextStyle(color: darkTextColor, fontSize: 14)),
                SizedBox(height: 20.0),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.assistant_photo,
                  color: iconRed,
                  size: 24.0,
                ),
                SizedBox(height: 5.0),
                FlatButton(
                    color: containerColor,
                    child: Text(arrAirport, style: TextStyle(color: textColor, fontSize: 26, fontWeight: FontWeight.bold)),
                    onPressed: () {_myDialog(AirportType.Arrival);}
                ),
                SizedBox(height: 3.0),
                Text('20:45Z',
                    style: TextStyle(color: darkTextColor, fontSize: 14))
              ],
            ),
          ],
        ),
      )
    ];
  }

  void _myDialog(AirportType airportType) async {
    String dialogText;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text( "Departure",
            style: TextStyle(color: textColor),
          ),
          backgroundColor: backgroundColor,
          content: TextField(
            onChanged: (String textTyped) {
              setState(() {
                dialogText = textTyped;
              });
            },
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                hintText: 'Enter airport ICAO code', fillColor: textColor),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            Row(
              children: <Widget>[
                FlatButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    setState(() {
                   //   onMainPageText = '';
                    });
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                    onPressed: () {
                      setState(() {
                        switch (airportType) {
                          case AirportType.Departure:
                            {
                              depAirport = dialogText;
                              break;
                            }
                          case AirportType.Arrival:
                            {
                              arrAirport = dialogText;
                              break;
                            }
                          case AirportType.Alternate:
                            {
                              // altAirport = dialogText;
                              break;
                            }
                        }
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text("OK"))
              ],
            ),
          ],
        );
      },
    );
  }
}
