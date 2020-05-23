import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class qrrCode extends StatelessWidget {

  List<String> qrText = [];
  qrrCode({Key key,@required this.qrText}) : super(key : key);

  Widget getQRWidget(String text) {
    return Column(
      children: <Widget>[
        QrImage(
          data: text,
          backgroundColor: Colors.white,
          size: 70,
        ),
        Text(text.split(',')[0]),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar (
          title : Text('QR Code'),
          centerTitle: true,
        ),
        body: Padding(
            padding: EdgeInsets.all(10.0),
            child: ListView(
              children: <Widget>[
                for (var item in qrText)
                  getQRWidget(item),
              ],
            )
        )
    );
  }
}


