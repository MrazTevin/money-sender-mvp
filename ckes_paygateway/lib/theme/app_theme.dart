import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Colors.black;
  static const Color accentColor = Color(0xFF00B386);
  static const Color backgroundColor = Colors.white;
  static const Color textColor = Colors.black;
  static const Color hintTextColor = Colors.grey;

    static ThemeData get lightTheme {
        return ThemeData(
          primaryColor: primaryColor,
          hintColor: accentColor,
          colorScheme: const ColorScheme.light(
            background: backgroundColor
          ),
          scaffoldBackgroundColor: backgroundColor,
          fontFamily: 'SansSerif', 
          textTheme: const TextTheme(
            displayLarge: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: textColor),
            bodyLarge:  TextStyle(fontSize: 16.0, color: textColor),
            bodySmall: TextStyle(fontSize: 14.0, color: hintTextColor),
          ),
          appBarTheme: const AppBarTheme(
            color: backgroundColor,
            elevation: 0,
            iconTheme: IconThemeData(color: primaryColor),
            titleTextStyle: TextStyle(
                color: textColor,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
            ),
          ),
          buttonTheme: ButtonThemeData(
            buttonColor: primaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: accentColor),
            ),
            focusedBorder: const  OutlineInputBorder(
              borderSide: BorderSide(color: accentColor),
            ),
            hintStyle: const  TextStyle(color: hintTextColor),
          ),
        );
      }

}