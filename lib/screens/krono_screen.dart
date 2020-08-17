import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tusmatik/main.dart';
import 'package:tusmatik/components/main_drawer.dart';
import 'package:tusmatik/screens/after_register_screen.dart';
import 'welcome_screen.dart';
import 'package:intl/intl.dart';
import 'package:slide_countdown_clock/slide_countdown_clock.dart';
import 'package:tusmatik/components/time_counter.dart';
import 'tus_bar.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

final databaseReference = Firestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

var tusDate;
var tusHour;
Duration finalDuration;
int durationInDays;
Future userFuture;

class KronoScreen extends StatefulWidget {
  final _firestore = Firestore.instance;

  FirebaseUser loggedInUser;
  static const String id = 'krono_screen';
  @override
  _KronoScreenState createState() => _KronoScreenState();
}

class _KronoScreenState extends State<KronoScreen> {
  int _bottomNavBarIndex = 0;
  String title;

  final tabs = [KronoBar(), TusBar()];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userFuture = _getDateData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Container(
          width: MediaQuery.of(context).size.width * 0.7, child: MainDrawer()),
      // appBar: AppBar(
      //   title: AppBarTitle(
      //     title: title ?? 'Tusmatik',
      //   ),
      //   backgroundColor: Colors.lightBlue,
      // ),
      body: tabs[_bottomNavBarIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        selectedItemColor: Colors.lightBlue,
        unselectedItemColor: Colors.blueGrey,
        showSelectedLabels: true,
        elevation: 0,
        currentIndex: _bottomNavBarIndex,
        onTap: (int index) {
          setState(() {
            _getDateData();
            _bottomNavBarIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            title: Text('Sayaç'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            title: Text('Neler Oluyor?'),
          ),
        ],
      ),
    );
  }
}

class AppBarTitle extends StatelessWidget {
  String title;
  AppBarTitle({this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title);
  }
}

class KronoBar extends StatelessWidget {
  const KronoBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: userFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                Text('none');
                break;
              case ConnectionState.waiting:
                Text('Yukleniyor..');
                break;
              case ConnectionState.active:
                Text('ACTIVE STATE');
                break;
              case ConnectionState.done:
                return LiquidLinearProgressIndicator(
                  value: durationInDays / 365, // Defaults to 0.5.
                  valueColor: AlwaysStoppedAnimation(Colors
                      .lightBlue), // Defaults to the current Theme's accentColor.
                  backgroundColor: Colors
                      .white, // Defaults to the current Theme's backgroundColor.
                  borderColor: Colors.lightBlue,
                  borderWidth: 2.0,
                  borderRadius: 12.0,
                  direction: Axis
                      .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
                  center: TimeCounter(
                      duration: finalDuration, durationInDays: durationInDays),
                );

                break;
            }
          }),
    );
  }
}

_getDateData() async {
  final FirebaseUser myUser = await _auth.currentUser();
  return await databaseReference
      .collection("users")
      .document(myUser.uid)
      .get()
      .then((DocumentSnapshot) {
    tusDate = DocumentSnapshot.data['date'].toString();
    var now = new DateTime.now();
    print(now);
    var dateTime1 = DateFormat('d|M|yyyy HH:mm').parse(tusDate);
    print(dateTime1);
    durationInDays = dateTime1.difference(now).inDays;
    final differenceInHours = dateTime1.difference(now).inHours;
    final differenceInMinutes = dateTime1.difference(now).inMinutes;
    final differenceInSeconds = dateTime1.difference(now).inSeconds;
    return finalDuration = Duration(
        hours: differenceInHours % 24,
        minutes: differenceInMinutes % 60,
        seconds: differenceInSeconds % 60);
  });
}

_displaySnackBar(BuildContext context, String message) {
  Scaffold.of(context).removeCurrentSnackBar();
  final snackBar = SnackBar(content: Text(message));
  Scaffold.of(context).showSnackBar(snackBar);
}
