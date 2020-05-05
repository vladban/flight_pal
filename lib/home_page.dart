import 'package:flutter/material.dart';
import 'package:flightpal/parameters.dart';
import 'dart:async';
import 'airportForm_page.dart';

DateTime now = DateTime.now().toUtc();
String timeColons = ':';

enum FlightState { onGround, inFlight, landed }

FlightState flightState;

DateTime blockOffTime;
DateTime blockOnTime;

String flightNumber = 'RA02772';
String depAirport = 'ZZZZ';
String arrAirport = 'ZZZZ';
String altAirport = 'ZZZZ';
String blockOffTimeString = 'blockOFF';
String blockOnTimeString = 'blockON';
String blockTimeString = '--:--';

TextEditingController depAirportController;
TextEditingController arrAirportController;
// TextEditingController fltAirportController;

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeStatePage();
  }
}

class _HomeStatePage extends State<HomePage> with TickerProviderStateMixin {
  Timer _timer;

  AnimationController _animationController;

  String _timeString;
  String _dateString;

  @override
  void initState() {
    flightState = FlightState.onGround;

    _dateString =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year.toString()}';
    _timeString =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    blockOffTime = DateTime.utc(now.year, now.month, now.day, 0, 0, 0);
    blockOnTime = DateTime.utc(now.year, now.month, now.day, 0, 0, 0);

    depAirportController = TextEditingController(text: "ZZZZ");
    arrAirportController = TextEditingController(text: "ZZZZ");

    _timer =
        Timer.periodic(Duration(seconds: 1), (Timer t) => _getCurrentTime());

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    _animationController.animateTo(1.0);

    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _getCurrentTime() {
    setState(() {
      now = DateTime.now().toUtc();
      _timeString =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
      if (flightState == FlightState.inFlight) {
        (timeColons == ':') ? timeColons = ' ' : timeColons = ':';

        blockTimeString =
            '${now.difference(blockOffTime).inHours.toString().padLeft(2, '0')}$timeColons${now.difference(blockOffTime).inMinutes.remainder(60).toString().padLeft(2, '0')}';
      }
    });
  }

  void setFlightOnGround() {
    blockOffTimeString = '--:--';
    blockOnTimeString = '--:--';
    blockTimeString = '--:--';

    flightState = FlightState.inFlight;
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
    var _depOnPressed;
    var _arrOnPressed;

    if (flightState == FlightState.onGround) {
      _arrOnPressed = null;
      _depOnPressed = () {
        blockOffTime = now;
        blockOffTimeString =
            '${blockOffTime.hour.toString().padLeft(2, '0')}:${blockOffTime.minute.toString().padLeft(2, '0')}Z';
        flightState = FlightState.inFlight;
      };
    } else {
      _depOnPressed = null;
    }

    if (flightState == FlightState.inFlight) {
      _depOnPressed = null;
      _arrOnPressed = () {
        blockOnTime = now;
        blockOnTimeString =
            '${blockOnTime.hour.toString().padLeft(2, '0')}:${blockOnTime.minute.toString().padLeft(2, '0')}Z';
        flightState = FlightState.landed;
      };
    } else {
      _arrOnPressed = null;
    }

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
                SizedBox(
                  width: 100.0,
                  height: 60.0,
                  child: AirportFieldForm(depAirportController),
                ),
                RaisedButton(
                  color: backgroundColor,
                  disabledColor: Colors.brown,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      side: BorderSide(color: Colors.red)
                  ),
                  child: Text(blockOffTimeString,
                      style: TextStyle(color: darkTextColor, fontSize: 16)),
                  onPressed: _depOnPressed,
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                AnimatedIcon(
                  color: Colors.green,
                  icon: AnimatedIcons.pause_play,
                  progress: _animationController,
                ),
//                Icon(
//                  Icons.arrow_forward,
//                  color: iconGreen,
//                  size: 24.0,
//                ),
                SizedBox(height: 21.0),
                Text(flightNumber,
                    style: TextStyle(color: darkTextColor, fontSize: 16)),
                SizedBox(height: 35.0),
                Text(blockTimeString,
                    style: TextStyle(color: textColor, fontSize: 20)),
                SizedBox(height: 15.0)
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
                SizedBox(
                  width: 100.0,
                  height: 60.0,
                  child: AirportFieldForm(arrAirportController),
                ),
                RaisedButton(
                    color: backgroundColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        side: BorderSide(color: Colors.red)
                    ),
                    disabledColor: Colors.brown,
                    child: Text(blockOnTimeString,
                        style: TextStyle(color: darkTextColor, fontSize: 16)),
                    onPressed: _arrOnPressed)
              ],
            ),
          ],
        ),
      )
    ];
  }
}
