import 'package:flutter/material.dart';

class AppTheme {
  final Color electusColor;

  final bool tenebrisModusEts;

  AppTheme({
    this.electusColor = const Color(0xFF1E1C36),
    this.tenebrisModusEts = false,
  });

  ThemeData getTheme() {
    return ThemeData(
      colorSchemeSeed: electusColor,
      brightness: tenebrisModusEts ? Brightness.dark : Brightness.light,

      appBarTheme: AppBarTheme(
        centerTitle: false,
      ),
    );
    
  }

}
