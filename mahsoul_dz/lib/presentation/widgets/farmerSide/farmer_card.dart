import 'package:flutter/material.dart';

class FarmerCard extends StatelessWidget {
  final String image;
  final String title;
  final String? value;
 
  const FarmerCard({
    super.key, 
    required this.image, 
    required this.title,
    this.value,
  });
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
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
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (value != null) ...[
                SizedBox(height: 5),
                Text(
                  value!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}