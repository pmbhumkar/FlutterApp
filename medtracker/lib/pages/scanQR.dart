import 'dart:async';

import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';


class ScanPage extends StatefulWidget {
  @override
  ScanPageState createState() {
    return new ScanPageState();
  }
}

class ScanPageState extends State<ScanPage> {
  String result = "Hey there !";

  formatString(result){
    var now = new DateTime.now();
    List<String> formatted = result.split(',');
    var hour;
    String para;
    var Morning_dosage = int.parse(formatted[1]);
    var Afternoon_dosage = int.parse(formatted[2]);
    var Night_dosage =int.parse(formatted[3]);

    var expiry_info;
    var expiry_date = formatted[4];
    List<String> date = expiry_date.split('/');
    var expiry_month = int.parse(date[0]);
    var expiry_year = int.parse(date[1]);

    var dosage_info = '';
    if(now.hour >= 8 && now.hour <= 11) {
      if (Morning_dosage == 1)
        dosage_info = 'Take this medicine before having food';
      else if (Morning_dosage == 2)
        dosage_info = 'Take this medicine after having food';
      else
        dosage_info = 'This medicine should not be taken in the morning';
    }
    else if(now.hour >= 12 && now.hour <= 14) {
      if (Afternoon_dosage == 1)
        dosage_info = 'Take this medicine before having food';
      else if (Afternoon_dosage == 2)
        dosage_info = 'Take this medicine after having food';
      else
        dosage_info = 'This medicine should not be taken in the afternoon';
    }
    else if (now.hour >=19 && now.hour <= 22){
      if (Night_dosage == 1)
        dosage_info = 'Take this medicine before having food';
      else if (Night_dosage == 2)
        dosage_info = 'Take this medicine after having food';
      else
        dosage_info = 'This medicine should not be taken in the night';
    }
    else
      dosage_info = 'This medicine should not be taken right now';

    if(expiry_year > now.year)
      expiry_info = '';

    else if(expiry_year == now.year) {
      if (expiry_month > now.month)
        expiry_info = '';
      else
        expiry_info = 'Medicine has expired';
    }
    else
      expiry_info = 'Medicine has expired';

    para = 'Medicine name: ${formatted[0]} \nDetails: ${dosage_info} \n' ;
    if (expiry_info != '')
      para = para +  'Expiry: ${expiry_info} \n';

    return para;
  }

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      qrResult = formatString(qrResult);
      setState(() {
        result = qrResult;
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = "Camera permission was denied";
        });
      } else {
        setState(() {
          result = "Unknown Error $ex";
        });
      }
    } on FormatException {
      setState(() {
        result = "You pressed the back button before scanning anything";
      });
    } catch (ex) {
      setState(() {
        result = "Unknown Error $ex";
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR Scanner"),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.lightBlue),
            shape: BoxShape.rectangle,
          ),
          child: InkWell(
            child: Text(
                result,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 20.0, color: Color(0xFF000000), fontWeight: FontWeight.bold )
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.camera_alt),
        label: Text("Scan"),
        onPressed: _scanQR,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}