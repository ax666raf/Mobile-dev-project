import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        
                        'Mahsoul',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                       
                      ),
                      SizedBox(width: 10),
                      Image.asset('lib/assets/Frame.png'),
                    ],
                  ),
                );
  }
}