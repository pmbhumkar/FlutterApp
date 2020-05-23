import 'package:flutter/material.dart';
import 'package:MedTracker/pages/home.dart';
import 'package:MedTracker/pages/med_course.dart';
import 'package:MedTracker/pages/scanQR.dart';

void main() {
  runApp(MaterialApp(
    //initialRoute: '/medCourse',
    routes: {
      '/' : (context) => Home(),
      '/medCourse' : (context) => MedCourse(),
      '/scanQR' : (context) => ScanPage(),
    },
    debugShowCheckedModeBanner: false,
  ));
}