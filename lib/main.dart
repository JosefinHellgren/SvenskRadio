import 'dart:collection';
import 'package:bestapp/EntryPoint.dart';
import 'package:bestapp/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting('sv_SE', null).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  String todaysDate() {
    String capitalize(String s) {
      return s.isNotEmpty ? s[0].toUpperCase() + s.substring(1) : s;
    }

    DateTime today = DateTime.now();
    DateFormat weekdayFormat = DateFormat('EEEE', 'sv_SE');
    DateFormat monthFormat = DateFormat('MMMM', 'sv_SE');
    String weekdayString = capitalize(weekdayFormat.format(today));
    String monthString = capitalize(monthFormat.format(today));
    return '$weekdayString ${today.day} $monthString ';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Sveriges Radio",
      theme: new ThemeData(
        scaffoldBackgroundColor: Colors.black,
        textTheme: TextTheme(bodyText1: TextStyle(color: Colors.white)),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sveriges Radio', style: TextStyle(fontSize: 30)),
              Text(todaysDate()),
            ],
          ),
          backgroundColor: Colors.black,
        ),
        body: EntryPoint(),
      ),
    );
  }
}
