import 'package:flutter/material.dart';
import 'package:mahsoul_dz/themes/colors.dart';

class MyButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;

  const MyButton({
    super.key,
    required this.text,
    required this.onTap,
    });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, 
      child: Container(
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(20),
        ),

        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),

        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white, 
              fontSize: 16, 
              fontWeight: FontWeight.bold,
            ),
            
          ),
        ),

      )
    );
  }
}
