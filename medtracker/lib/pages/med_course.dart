import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:MedTracker/pages/qr_code.dart';

class MedCourse extends StatefulWidget {
  @override
  _MedCourseState createState() => _MedCourseState();
}


class _MedCourseState extends State<MedCourse> {
  String morningDropdownValue = 'No dose';
  String afternoonDropdownValue = 'No dose';
  String eveningDropdownValue = 'No dose';
  String _selectedDate = 'Tap to select date';
  String _qrDate = '';
  var date = new DateTime.now();

  List<String> medicineList = [];
  //["med1,1,0,2,2/2024","med2,1,0,1,2/2024","med3,2,0,2,2/2024"];


  var dosage = {
    'No dose' : '0',
    'Before food' : '1',
    'After food' : '2'
  };



  final myController = TextEditingController();

  String getTime() {
    var temptime = new DateTime(date.year, date.month, date.day, 22);
    var morningTime = new DateFormat.Hm("en_US").format(temptime);
    return morningTime;
  }

  Map dosageTime() {
    var data = new Map();
    String temp = '';
    data = {
      'morning' : false,
      'afternoon' : false,
      'evening' : false
    };
    //print('dosageTime');
    //print(medicineList);
    for(var i = 0; i < medicineList.length; i++) {
      temp = medicineList[i];
      var med = temp.split(',');
      //print('dosageTime');
      //print(temp);

      if(med[1] != '0')
        data['morning'] = true;
      if(med[2] != '0')
        data['afternoon'] = true;
      if(med[3] != '0')
        data['evening'] = true;
    }
    return data;
  }

  String convertToQRText(String _medicineName) {
    String QROutput = '';
    QROutput = _medicineName + ',' + dosage[morningDropdownValue] + ',' +
        dosage[afternoonDropdownValue] + ',' + dosage[eveningDropdownValue] +
        ',' + _qrDate;
    return QROutput;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }


  Future<void> _selectDate(BuildContext context) async {
    final DateTime d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(date.year + 5, date.month),
      initialDatePickerMode: DatePickerMode.year,
    );
    if (d != null)
      _qrDate = new DateFormat.yM("en_US").format(d);
    setState(() {
      //_selectedDate = new DateFormat.yMMMMd("en_US").format(d);
      _selectedDate = new DateFormat.yMMMM("en_US").format(d);
    });
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;

  @override
  void initState() {
    super.initState();
    initializing();
  }

  void initializing() async {
    androidInitializationSettings = AndroidInitializationSettings('ic_launcher');
    iosInitializationSettings = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = InitializationSettings(
        androidInitializationSettings, iosInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }
  void _showNotifications() async {
    await notification();
  }


  void _showNotificationsAfterSecond() async {
    String notificationBody = 'Time for your Morning medicines';
    var dTime = dosageTime();
    var timer = new Time();
    //print(dTime);
//    Map m = {
//      'morning' : new DateTime(date.year, date.month, date.day, 10, 48),
//      'afternoon' : new DateTime(date.year, date.month, date.day, 10, 48),
//      'evening' : new DateTime(date.year, date.month, date.day, 10, 48),
//    };
//    m.forEach((key, value) {
//      if(dTime[key]) {
//        notificationBody = 'Time for ${key} medicines';
//        timeDelayed = new DateTime(date.year, date.month, date.day, 10, 00);
//        await notificationAfterSec(timeDelayed, notificationBody);
//      }
//    });

    //var t = 7;
    if(dTime['morning']) {
      notificationBody = 'Time for morning medicines';
      timer = new Time(9);
      await notificationAfterSec(1, timer, notificationBody);
    }
    if(dTime['afternoon']) {
      notificationBody = 'Time for afternoon medicines';
      timer = new Time(12, 51);
      await notificationAfterSec(2, timer, notificationBody);
    }
    if(dTime['evening']) {
      notificationBody = 'Time for evening medicines';
      timer = new Time(20);
      await notificationAfterSec(3, timer, notificationBody);
    }
//    await notificationAfterSec(timeDelayed, notificationBody);
  }

  Future<void> notification() async {
    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
        'Channel ID', 'Channel title', 'channel body',
        priority: Priority.High,
        importance: Importance.Max,
        playSound: true,
        ticker: 'test');

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

    NotificationDetails notificationDetails =
    NotificationDetails(androidNotificationDetails, iosNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        0, 'Title', 'Body medicine', notificationDetails);
  }

  Future<void> notificationAfterSec(var notId, var timeDelayed, String body) async {
    //var timeDelayed = DateTime.now().add(Duration(seconds: 5));
    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
        'second channel ID', 'second Channel title', 'second channel body',
        priority: Priority.High,
        importance: Importance.Max,
        playSound: true,
        ticker: 'test');

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

    NotificationDetails notificationDetails =
    NotificationDetails(androidNotificationDetails, iosNotificationDetails);
    await flutterLocalNotificationsPlugin.showDailyAtTime(notId, 'Medicine time',
        body, timeDelayed, notificationDetails);
  }


  Future onSelectNotification(String payLoad) {
    if (payLoad != null) {
      print(payLoad);
    }

    // we can set navigator to navigate another screen
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              print("");
            },
            child: Text("Okay")),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add medicine course'),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 10.0),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                controller: myController,
                decoration: InputDecoration(
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.teal)
                    ),
                    hintText: 'Enter medicine name'
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text('Morning'),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child:DropdownButton<String>(
                      value: morningDropdownValue,
                      icon: Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(
                          color: Colors.lightBlue
                      ),
                      underline: Container(
                        height: 2,
                        color: Colors.lightBlue,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          morningDropdownValue = newValue;
                        });
                      },
                      items: <String>['No dose', 'Before food', 'After food']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      })
                          .toList(),
                    ),
                  ),
                ),

              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text('Afternoon'),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child:DropdownButton<String>(
                      value: afternoonDropdownValue,
                      icon: Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(
                          color: Colors.lightBlue
                      ),
                      underline: Container(
                        height: 2,
                        color: Colors.lightBlue,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          afternoonDropdownValue = newValue;
                        });
                      },
                      items: <String>['No dose', 'Before food', 'After food']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      })
                          .toList(),
                    ),
                  ),
                ),

              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text('Evening'),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child:DropdownButton<String>(
                      value: eveningDropdownValue,
                      icon: Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(
                          color: Colors.lightBlue
                      ),
                      underline: Container(
                        height: 2,
                        color: Colors.lightBlue,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          eveningDropdownValue = newValue;
                        });
                      },
                      items: <String>['No dose', 'Before food', 'After food']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      })
                          .toList(),
                    ),
                  ),
                ),

              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text('Expiry Date'),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.all(10.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.lightBlue),
                      shape: BoxShape.rectangle,
                    ),
                    child: InkWell(
                      child: Text(
                          _selectedDate,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xFF000000))
                      ),
                      onTap: (){
                        _selectDate(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 50.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: 150,
                    child: RaisedButton(
                      onPressed: () {
                        medicineList.add(convertToQRText(myController.text));
                        print(medicineList);
                        return showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text('Added ${myController.text} medicine'),
                            );
                          },
                        );
                      },
                      child: Text('Add medicine'),
                      color: Colors.lightBlue,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: 150,
                    child: RaisedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text('Added reminder to take ${myController.text}'),
                            );
                          },
                        );
                        _showNotificationsAfterSecond();
                        //return
                      },
                      child: Text('Add reminder'),
                      color: Colors.lightBlue,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: 150,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => qrrCode(qrText : medicineList),
                        ));
                      },
                      child: Text('Generate QR'),
                      color: Colors.lightBlue,
                    ),
                  ),
                ),
              ],
            ),



          ],

        ),
      ),
    );
  }
}
