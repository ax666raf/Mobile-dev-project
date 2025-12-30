import 'package:flutter/material.dart';

class CategoriesCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String count;
  const CategoriesCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 15),
          Image.asset(imagePath, width: 50, height: 50),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(count, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),

   
    );
  }
}
