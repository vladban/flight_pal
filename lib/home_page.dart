import 'package:flutter/material.dart';
import 'package:flightpal/parameters.dart';
import 'dart:async';
import 'airportForm_page.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:ext_storage/ext_storage.dart';

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

  // File _image;




  Future postFlightData() async {
    final directory =  await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOCUMENTS);
     Permission.storage.request().isGranted;

    var myImagePath = '$directory';

    //   ;
    final fileName = 'FlightData_$depAirport'+ '_$arrAirport' +
        '_' +
        '${now.day.toString().padLeft(2, '0')}${now.month.toString().padLeft(2, '0')}${now.year.toString()}' +
        '_' +
        '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}.csv';
    //print('$myImagePath' + '/' + '$fileName');

    try {
       await Directory(myImagePath).create();
      myImagePath = myImagePath + '/${now.year.toString()}';
       await Directory(myImagePath).create();
      myImagePath = myImagePath + '/${now.month.toString().padLeft(2, '0')}';
       await Directory(myImagePath).create();
      myImagePath = myImagePath + '/${now.day.toString().padLeft(2, '0')}';
       await Directory(myImagePath).create();
    } catch (e) {
      // print('ERRORRRR $e');
    }

    try {
      final File file = File('$myImagePath' + '/' + '$fileName');
       file.writeAsString(flightNumber + ',' + depAirport+ ',' + arrAirport+ ',' + _dateString + ',' + blockOffTimeString + ',' + blockOnTimeString + ',' + blockTimeString);
    } catch (e) {
      //  print('ERRORRRR $e');
    }

    flightState = FlightState.onGround;
    depAirport = 'ZZZZ';
    arrAirport = 'ZZZZ';
    altAirport = 'ZZZZ';
    blockOffTimeString = 'blockOFF';
    blockOnTimeString = 'blockON';
    blockTimeString = '--:--';
    depAirportController.text = 'ZZZZ';
    arrAirportController.text = 'ZZZZ';

    setState(() {
      // _image = image;
       print('$myImagePath' + '/' + '$fileName');
    });


  }





  Future getImage(ImgSource source, String namePrefix) async {
    final directory = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOCUMENTS);

    //  final directory = (await getApplicationDocumentsDirectory()).path;

   // print('MY DIRECTORY NAME IS: ' + directory);

   // var statePermission = await Permission.storage.status;
    //print('PErmissions: ' + statePermission.toString());
    if (await Permission.storage.request().isGranted) {}

     // await Permission.storage.status;
   // print('PErmissions: ' + statePermission.toString());

    var image = await ImagePickerGC.pickImage(
      context: context,
      source: source,
      cameraIcon: Icon(
        Icons.add,
        color: Colors.red,
      ), //cameraIcon and galleryIcon can change. If no icon provided default icon will be present
    );

    var myImagePath = '$directory';

    //   ;
    final fileName = namePrefix +
        '_' +
        '${now.day.toString().padLeft(2, '0')}${now.month.toString().padLeft(2, '0')}${now.year.toString()}' +
        '_' +
        '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}.jpg';
    //print('$myImagePath' + '/' + '$fileName');

    try {
      await Directory(myImagePath).create();
      myImagePath = myImagePath + '/${now.year.toString()}';
      await Directory(myImagePath).create();
      myImagePath = myImagePath + '/${now.month.toString().padLeft(2, '0')}';
      await Directory(myImagePath).create();
      myImagePath = myImagePath + '/${now.day.toString().padLeft(2, '0')}';
      await Directory(myImagePath).create();
    } catch (e) {
     // print('ERRORRRR $e');
    }

    try {
      await image.copy('$myImagePath' + '/' + '$fileName');
    } catch (e) {
    //  print('ERRORRRR $e');
    }

    setState(() {
      // _image = image;
     // print('$myImagePath' + '/' + '$fileName');
    });
  }

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

    _timer = Timer.periodic(
        Duration(milliseconds: 500), (Timer t) => _getCurrentTime());

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
                children: buildTitle() +
                    buildAirports() +
                    buildMidTitle() +
                    buildPictures() +
                    buildEndTitle())),
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
              Row(
                children: <Widget>[
                  Text(
                    _timeString + " UTC  " + _dateString,
                    style: TextStyle(
                        color: textColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                ],
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
                      side: BorderSide(color: Colors.red)),
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
                ButtonTheme(
                  height: 20.0,
                  child: RaisedButton(
                    child: Text(
                      flightNumber,
                      style: TextStyle(color: textColor),
                    ),
                    onPressed: () => _flightNumberDialog(),
                    color: backgroundColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        side: BorderSide(color: darkTextColor)),
                    textColor: textColor,
                    //padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    splashColor: Colors.grey,
                  ),
                ),
                SizedBox(height: 17.0),
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
                        side: BorderSide(color: Colors.red)),
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

  List<Widget> buildMidTitle() {
    return [
      Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(left: 25.0, right: 20.0, top: 10, bottom: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 5.0),
              Row(
                children: <Widget>[
                  Text(
                    'Document Pictures',
                    style: TextStyle(
                        color: darkTextColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ))
    ];
  }

  List<Widget> buildPictures() {
    return [
      Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.only(left: 12.0, right: 10.0, top: 15, bottom: 15),
        height: 220.0,
        margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 10, bottom: 10),
        decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            color: containerColor),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                ButtonTheme(
                  height: 50.0,
                  child: RaisedButton(
                    child: Text(
                      "FMS",
                      style: TextStyle(color: textColor),
                    ),
                    onPressed: () => getImage(ImgSource.Camera, 'FMS'),
                    color: backgroundColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        side: BorderSide(color: darkTextColor)),
                    textColor: textColor,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    splashColor: Colors.grey,
                  ),
                ),
                SizedBox(
                  width: 15.0,
                ),
                ButtonTheme(
                  height: 50.0,
                  child: RaisedButton(
                    child: Text(
                      "Fuel",
                      style: TextStyle(color: textColor),
                    ),
                    onPressed: () => getImage(ImgSource.Camera, 'Fuel'),
                    color: backgroundColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        side: BorderSide(color: darkTextColor)),
                    textColor: textColor,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    splashColor: Colors.grey,
                  ),
                ),
                SizedBox(
                  width: 15.0,
                ),
                ButtonTheme(
                  height: 50.0,
                  child: RaisedButton(
                    child: Text(
                      "Order",
                      style: TextStyle(color: textColor),
                    ),
                    onPressed: () => getImage(ImgSource.Camera, 'Order'),
                    color: backgroundColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        side: BorderSide(color: darkTextColor)),
                    textColor: textColor,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    splashColor: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15.0,
            ),
            Row(
              children: <Widget>[
                ButtonTheme(
                  height: 50.0,
                  child: RaisedButton(
                    child: Text(
                      "Receipt",
                      style: TextStyle(color: textColor),
                    ),
                    onPressed: () => getImage(ImgSource.Camera, 'Receipt'),
                    color: backgroundColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        side: BorderSide(color: darkTextColor)),
                    textColor: textColor,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    splashColor: Colors.grey,
                  ),
                ),
                SizedBox(
                  width: 15.0,
                ),
                ButtonTheme(
                  height: 50.0,
                  child: RaisedButton(
                    child: Text(
                      "General",
                      style: TextStyle(color: textColor),
                    ),
                    onPressed: () => getImage(ImgSource.Camera, 'General'),
                    color: backgroundColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        side: BorderSide(color: darkTextColor)),
                    textColor: textColor,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    splashColor: Colors.grey,
                  ),
                ),
                SizedBox(
                  width: 15.0,
                ),
                ButtonTheme(
                  height: 50.0,
                  child: RaisedButton(
                    child: Text(
                      "Pax manif",
                      style: TextStyle(color: textColor),
                    ),
                    onPressed: () => getImage(ImgSource.Camera, 'PaxManifest'),
                    color: backgroundColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        side: BorderSide(color: darkTextColor)),
                    textColor: textColor,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    splashColor: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15.0,
            ),
            Row(
              children: <Widget>[
                ButtonTheme(
                  height: 50.0,
                  child: RaisedButton(
                    child: Text(
                      "Customs",
                      style: TextStyle(color: textColor),
                    ),
                    onPressed: () => getImage(ImgSource.Camera, 'Customs'),
                    color: backgroundColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        side: BorderSide(color: darkTextColor)),
                    textColor: textColor,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    splashColor: Colors.grey,
                  ),
                ),
                SizedBox(
                  width: 15.0,
                ),
                ButtonTheme(
                  height: 50.0,
                  child: RaisedButton(
                    child: Text(
                      "Loadsheet",
                      style: TextStyle(color: textColor),
                    ),
                    onPressed: () => getImage(ImgSource.Camera, 'Loadsheet'),
                    color: backgroundColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        side: BorderSide(color: darkTextColor)),
                    textColor: textColor,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    splashColor: Colors.grey,
                  ),
                ),
                SizedBox(
                  width: 15.0,
                ),
                ButtonTheme(
                  height: 50.0,
                  child: RaisedButton(
                    child: Text(
                      "Other",
                      style: TextStyle(color: textColor),
                    ),
                    onPressed: () => getImage(ImgSource.Camera, 'Other'),
                    color: backgroundColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        side: BorderSide(color: darkTextColor)),
                    textColor: textColor,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    splashColor: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      )
    ];
  }

  List<Widget> buildEndTitle() {
    var _finishOnPressed;

    if (flightState == FlightState.landed) {

      _finishOnPressed = () {
        postFlightData();

        _finishOnPressed = null;
      };
    }

    return [
      Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(left: 25.0, right: 20.0, top: 10, bottom: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 5.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: Text(
                      "Finish Flight",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    onPressed: _finishOnPressed,
                    color: containerColor,
                    textColor: textColor,
                    disabledTextColor: Colors.white30,
                    disabledColor: Colors.white30,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(width: 3.0, color: Colors.blue),
                    ),
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  ),
                ],
              ),
            ],
          ))
    ];
  }

  void _flightNumberDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Select Flight Number'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                   flightNumber = 'RA02772';
                   Navigator.of(context).pop();
                },
                child: const Text('RA02772'),
              ),
              SimpleDialogOption(
                onPressed: () {
                   flightNumber = 'RA07887';
                   Navigator.of(context).pop();

                },
                child: const Text('RA07887'),
              ),



            ],
          );
        });
  }
}
