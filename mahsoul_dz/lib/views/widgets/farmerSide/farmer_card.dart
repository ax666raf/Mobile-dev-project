import 'package:flutter/material.dart';

class FarmerCard extends StatelessWidget {
  final String image;
  final String title;
 
  const FarmerCard({
    super.key, 
    required this.image, 
    required this.title, 
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 15.0),
        child: Column(
          children: [
            Image.asset(
              image,
              width: 30,
              height:30,
              ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}