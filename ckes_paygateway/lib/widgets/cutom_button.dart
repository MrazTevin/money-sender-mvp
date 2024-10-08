import 'package:ckes_paygateway/theme/app_theme.dart';
import 'package:flutter/material.dart';
 
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({super.key, required this.text, required this.onPressed});


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: AppTheme.backgroundColor, backgroundColor: AppTheme.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))
      ),
      child: Text(text),
    );
  }
}
