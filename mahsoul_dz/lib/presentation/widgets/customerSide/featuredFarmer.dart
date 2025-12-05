import 'package:flutter/material.dart';
import 'package:mahsoul_dz/presentation/themes/colors.dart';

class FeaturedFarmer extends StatelessWidget {
  final String profileImage;
  final String name;
  final String rating;
  final String availability;
  final String location;
  final String products;
  const FeaturedFarmer({
    super.key, 
    required this.profileImage, 
    required this.name, 
    required this.rating, 
    required this.availability, 
    required this.location, 
    required this.products});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:Color(0xFFF9F6F1),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
        // profile
        Image.asset(
          profileImage, 
          width: 60, 
          height: 60),
        SizedBox(width: 10),
        // infor
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name
            Text(
              name,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            // info
            Row(
              children: [
                Text(
                  products,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  location,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],

            )
          ],
        ),

        SizedBox(width  : 20),
        // rating and availability
        Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.star,

                  color: Colors.black,
                  size: 12,
                ),
                SizedBox(width: 5),
                Text(
                  rating,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              availability,
              style: TextStyle(
                fontSize: 12,
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        )
      ],
     ),
    );
  }
}
