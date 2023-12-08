import 'package:flutter/material.dart';
import 'package:simple_social_app/styles/colors.dart';

final ThemeData dark =  ThemeData(
    scaffoldBackgroundColor: Colors.black,
    primarySwatch: Colors.deepPurple,
    appBarTheme:  AppBarTheme(
      titleSpacing: 10,
      backgroundColor: Colors.black,
      titleTextStyle: TextStyle(
        color: defColor,
        fontWeight: FontWeight.bold,
        fontSize: 20
      )
    )
);