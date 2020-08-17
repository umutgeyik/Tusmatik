import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:slide_countdown_clock/slide_countdown_clock.dart';

class TimeCounter extends StatelessWidget {
  final duration;
  final durationInDays;
  const TimeCounter({Key key, this.duration, this.durationInDays})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: width * 0.5,
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.lightBlue[100],
                  shape: BoxShape.circle,
                ),
                child: Text(
                  durationInDays.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                  
                    color: Colors.white,
                    fontSize: width*0.15,
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                'Gün',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  color: Colors.lightBlue[100],
                  fontSize: width * 0.13,
                ),
              )
            ],
          ),
          Container(
            width: width ,
                      child: Center(
                        child: Padding(
              padding: EdgeInsets.all(10),
              child: SlideCountdownClock(
                duration: duration,
                separator: ':',
                textStyle: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                separatorTextStyle: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightBlue[100],
                ),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.lightBlue[100], shape: BoxShape.circle),
              ),
            ),
                      ),
          ),
        ]);
  }
}
