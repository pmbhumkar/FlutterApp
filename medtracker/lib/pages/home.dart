import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('MedTracker'),
          centerTitle: true,
        ),
        body: Padding(
            padding: EdgeInsets.all(10.0),
            child: ListView(
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/medCourse');
                  },
                  child: Text('Add medicine course'),
                  color: Colors.lightBlue,
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/scanQR');
                  },
                  child: Text('Scan Medicine'),
                  color: Colors.lightBlue,
                ),
              ],
            )
        )
    );
  }
}