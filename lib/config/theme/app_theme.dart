import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

      textTheme:  TextTheme(
        titleLarge: GoogleFonts.montserratAlternates(
          
        ),
      )
    );
    
  }

}
