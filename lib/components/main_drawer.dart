import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tusmatik/images.dart';
import 'package:tusmatik/main.dart';
import 'package:tusmatik/screens/user_agreement.dart';
import 'package:tusmatik/strings.dart';
import 'package:tusmatik/screens/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:tusmatik/constants.dart';
import 'package:tusmatik/styles.dart';
import 'package:tusmatik/screens/krono_screen.dart';
import 'package:tusmatik/screens/user_topic_screen.dart';
import 'package:tusmatik/screens/about_us_screen.dart';

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  String myNickname;
  FirebaseUser myUser;
  String myEmail = 'null';
  String date;
  final databaseReference = Firestore.instance;
  List<DateTime> dateList = [];
  int group = 1;
  int value;

  _getData() async {
    myUser = await FirebaseAuth.instance.currentUser();
    myEmail = myUser.email;
    DocumentReference documentReference =
        Firestore.instance.collection("users").document(myUser.uid);
    await documentReference.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        myNickname = datasnapshot.data['nickname'].toString();
        date = datasnapshot.data['date'].toString();
        var dateTime1 = DateFormat('d|M|yyyy HH:mm').parse(date);
        date = dateTime1.day.toString() +
            ' ' +
            kMonthsList[int.parse(dateTime1.month.toString())] +
            ' ' +
            dateTime1.year.toString() +
            ' ' +
            dateTime1.hour.toString() +
            ':' +
            dateTime1.minute.toString() +
            '0';
      } else {
        nickname = 'noname';
        print("No username");
      }
    });
  }

  _sortDates() async {
    dateList.sort((a, b) => a.compareTo(b));
  }

  _getDateData() async {
    dateList.clear();
    return await databaseReference
        .collection("tus_dates")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        String myDate =
            f.data['date'].toString() + ' ' + f.data['hour'].toString();
        var dateTime1 = DateFormat('d|M|yyyy hh:mm').parse(myDate);
        dateList.add(dateTime1);
        print('MONTH KISMI');
        print(dateTime1.month);
        // dateList.add(dateTime1.day.toString() + ' ' + kMonthsList[int.parse(dateTime1.month.toString())] + ' ' + dateTime1.year.toString() + ' ' + f.data['hour'].toString());
      });
      _sortDates();
    });
  }


  _updateDatabase({date}) async {
    myUser = await FirebaseAuth.instance.currentUser();
    return await databaseReference.collection("users").document(myUser.uid).updateData({
      'date': date
    });
  }

  Future<void> resetPassword(String email) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String nickname;
  String email;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return FutureBuilder(
        future: _getData(),
        builder: (context, snapshot) {
          return Drawer(
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  color: Theme.of(context).primaryColor,
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 30),
                          height: height * 0.1,
                          child: Image.asset(iSthetescopIcon),
                        ),
                        SizedBox(height: 20),
                        Text(
                          myNickname ?? 'noname',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          myEmail ?? 'bos',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.question_answer),
                  title: Text(
                    sListTile1,
                    style: TextStyle(fontSize: 15),
                  ),
                  onTap: () {
                    print('HEY');
                   
                     Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserTopicDetail(userUid: myUser.uid,),
          ),
        );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.calendar_today),
                  title: Text(
                    sListTile5,
                    style: TextStyle(fontSize: 15),
                  ),
                  onTap: () async {
                    await _getDateData();
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext bc) {
                          return StatefulBuilder(

                            builder: (BuildContext context,setState) => Container(
                              height: MediaQuery.of(context).size.height * 0.70,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text('Senin Tarihin:'),
                                        IconButton(
                                          icon: Icon(Icons.cancel),
                                          color: Colors.blue,
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ),
                                    Text(
                                      date,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w700),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    SizedBox(
                                      height: height * 0.4,
                                      child: Scrollbar(
                                        child: ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return RadioListTile(
                                              value: index,
                                              activeColor: Colors.blue,
                                              groupValue: value,
                                              onChanged: (ind) {
                                                setState(() {
                                                  value = ind;
                                                });
                                              },
                                              title: Text(
                                                dateList[index].day.toString() +
                                                    ' ' +
                                                    kMonthsList[int.parse(
                                                        dateList[index]
                                                            .month
                                                            .toString())] +
                                                    ' ' +
                                                    dateList[index]
                                                        .year
                                                        .toString() +
                                                    ' ' +
                                                    dateList[index]
                                                        .hour
                                                        .toString() +
                                                    ':' +
                                                    dateList[index]
                                                        .minute
                                                        .toString() +
                                                    '0',
                                                style: kSubtitleStyle,
                                              ),
                                            );
                                          },
                                          itemCount: dateList.length,
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: FlatButton(
                                        color: Colors.blue,
                                        onPressed: () async {
                                          String myDate = dateList[value].day.toString() +
                                                  '|' +
                                                  dateList[value].month.toString() +
                                                  '|' +
                                                  dateList[value]
                                                      .year
                                                      .toString() +
                                                  ' ' +
                                                  dateList[value]
                                                      .hour
                                                      .toString() +
                                                  ':' +
                                                  dateList[value]
                                                      .minute
                                                      .toString() +
                                                  '0';
                                          await _updateDatabase(date: myDate);
                                          Navigator.pushNamedAndRemoveUntil(context, KronoScreen.id, (r) => false);

                                          // Change date from firebase.
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                            'Değiştir',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontFamily: 'Roboto',
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  },
                ),
                ListTile(
                  leading: Icon(Icons.cloud),
                  title: Text(
                    sListTile2,
                    style: TextStyle(fontSize: 15),
                  ),
                  onTap: () async {
                    await resetPassword(email ?? myUser.email);

                    _displaySnackBar(
                        context, 'Şifre sıfırlama mailiniz gönderilmiştir.');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.info),
                  title: Text(
                    sListTile3,
                    style: TextStyle(fontSize: 15),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, AboutUsScreen.id);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.chrome_reader_mode),
                  title: Text(
                    sListTile6,
                    style: TextStyle(fontSize: 15),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, UserAgreementScreen.id);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text(
                    sListTile4,
                    style: TextStyle(fontSize: 15),
                  ),
                  onTap: () {
                    _auth.signOut();
                    Navigator.pushNamedAndRemoveUntil(
                        context, WelcomeScreen.id, (r) => false);
                  },
                )
              ],
            ),
          );
        });
  }
}

_displaySnackBar(BuildContext context, String message) {
  Scaffold.of(context).removeCurrentSnackBar();
  final snackBar = SnackBar(content: Text(message));
  Scaffold.of(context).showSnackBar(snackBar);
}
