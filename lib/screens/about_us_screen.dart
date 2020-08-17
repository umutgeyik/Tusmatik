import 'package:flutter/material.dart';
import 'package:show_up_animation/show_up_animation.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class AboutUsScreen extends StatelessWidget {
  static const String id = 'about_us_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(),
              
              ShowUpAnimation(
                delayStart: Duration(seconds: 1),
                animationDuration: Duration(seconds: 1),
                curve: Curves.bounceIn,
                direction: Direction.vertical,
                offset: 0.5,
                child: ShowUpList(
                  direction: Direction.horizontal,
                  animationDuration: Duration(milliseconds: 1500),
                  delayBetween: Duration(milliseconds: 800),
                  offset: -0.2,
                  children: <Widget>[
                    
                    Text(
                      'Tusmatik',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 45.0,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Indieflower'),
                    ),
                    Text('Takipte kalin.',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Roboto-Regular'
                    ),),
                  ],
                ),
              ),
              TyperAnimatedTextKit(

                          text: [
                            "from Umut Geyik",
                            
                          ],
                          textStyle:
                              TextStyle(fontSize: 30.0, fontFamily: "DancingScript"),
                          textAlign: TextAlign.start,
                          alignment: AlignmentDirectional
                              .topStart // or Alignment.topLeft
                          ),
            ],
          ),
        ),
      ),
    );
  }
}
