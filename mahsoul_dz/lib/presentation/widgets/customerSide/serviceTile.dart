import 'package:flutter/material.dart';

class ServiceTile extends StatelessWidget {
  final String iconPath;
  final String title;
  final void Function() onTap;
  final String description;

  const ServiceTile({
    super.key, 
    required this.iconPath, 
    required this.title, 
    required this.description, 
    required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
            // icon
            Image.asset(
              iconPath, 
              width: 53, 
              height: 53,
              ),
        
            SizedBox(width: 20),
        
            // title and description
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                )
              ],
            ),
        
            Spacer(),
        
            // arrow icon
            GestureDetector(
              onTap: onTap,
              child: Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[600],
                size: 16,
              ),
            )
        
          ],
          ),
        ),
      ),
    );
  }
}