import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mahsoul_dz/widgets/button.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Hide system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/backgroundImage.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 58.0, vertical: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top section: Title and Description
              Padding(
                padding: const EdgeInsets.only(top: 80.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // toggle of language

                    // title
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome To',
                          style: TextStyle(color: Colors.white, fontSize: 48),
                          textAlign: TextAlign.left,
                        ),
                        Row(
                          children: [
                            Text(
                              'Mahsoul',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(width: 10),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Image.asset('lib/assets/MainFrame.png', width: 48, height: 48),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // description
                    Column(
                      children: [
                        Text(
                          'Discover the freshest produce directly',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'from local farmers in your area.',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Bottom section: Button
              Padding(
                padding: const EdgeInsets.only(bottom: 100.0),
                child: MyButton(
                  text: 'Get started',
                  onPressed: () {
                    Navigator.pushNamed(context, '/home');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
