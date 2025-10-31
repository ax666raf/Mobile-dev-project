import 'package:flutter/material.dart';
import 'package:mahsoul_dz/themes/colors.dart';

class UserCard extends StatelessWidget {
  final String iconPath;
  final String title;
  final String description;
  final VoidCallback? onTap;
  final bool selected;

  const UserCard({
    super.key,
    required this.iconPath,
    required this.title,
    required this.description,
    this.onTap,
    this.selected = false,
  });

  // Helper method to determine if it's a farmer
  bool get isFarmer => title.toLowerCase().contains('farmer');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 28.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? primaryColor : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  (selected
                          ? primaryColor
                          : (isFarmer ? primaryColor : Colors.grey[800]!))
                      .withOpacity(0.4),
              spreadRadius: 0,
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // icon
            Image.asset(iconPath, width: 55, height: 55.0),
            const SizedBox(height: 20.0),

            // title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isFarmer ? primaryColor : Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5.0),

                  // description
                  Text(
                    description,
                    style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
