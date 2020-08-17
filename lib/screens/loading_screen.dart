import 'package:flutter/material.dart';
import 'package:tusmatik/images.dart';

class LoadingScreen extends StatelessWidget {
  static const String id = 'loading_screen';


  @override
  Widget build(BuildContext context) {
    
      return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Image.asset(iLoadingIcon)],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Text(
              'Tusmatik',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 60, fontFamily: 'Indieflower',fontWeight: FontWeight.w500),
            ),
          ])
        ],
      ),
    );
  }
}