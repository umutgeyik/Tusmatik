import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tusmatik/constants.dart';
import 'package:tusmatik/strings.dart';
import 'package:tusmatik/images.dart';
import 'package:tusmatik/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'krono_screen.dart';
import 'package:intl/intl.dart';

final databaseReference = Firestore.instance;
List<DateTime> dateList = [];
final FirebaseAuth _auth = FirebaseAuth.instance;
String errorMessage;
bool _validate = false;
bool nickNameUsed = false;

class AfterRegisterScreen extends StatefulWidget {
  static const String id = 'after_register_screen';
  @override
  _AfterRegisterScreenState createState() => _AfterRegisterScreenState();
}

class _AfterRegisterScreenState extends State<AfterRegisterScreen>{
  int group = 1;
  bool selectedRadio;
  Future userFuture;
  int value;
  final _text = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userFuture = _getDateData();
    
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  _sortDates() async{
      dateList.sort((a,b) => a.compareTo(b));
  }

  _getDateData() async {
    dateList.clear();
    return await databaseReference
        .collection("tus_dates")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents
          .forEach((f)  {
            String myDate = f.data['date'].toString() + ' ' + f.data['hour'].toString();
            var dateTime1 = DateFormat('d|M|yyyy HH:mm').parse(myDate);
            dateList.add(dateTime1);
            print('MONTH KISMI');
            print(dateTime1.month);
           // dateList.add(dateTime1.day.toString() + ' ' + kMonthsList[int.parse(dateTime1.month.toString())] + ' ' + dateTime1.year.toString() + ' ' + f.data['hour'].toString());
            } );
            _sortDates();
    });
  }

  final int _numPages = 4;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.blue,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    String nickName;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 0.4, 0.7, 0.9],
              colors: [
                Colors.lightBlue,
                Colors.lightBlue,
                Colors.lightBlueAccent,
                Colors.lightBlueAccent,
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: height * 0.8,
                  child: PageView(
                    physics: ClampingScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: <Widget>[
                      OutlandWidget(
                          height: height,
                          width: width,
                          title: sAfterRegisterTitle,
                          subtitle: sAfterRegisterDescription),
                      OutlandWidget(
                          height: height,
                          width: width,
                          title: sTakeNicknameTitle,
                          subtitle: sTakeNicknameDescription),
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Image(
                                image: AssetImage(
                                  iCalendarIcon,
                                ),
                                height: height * 0.3,
                                width: width * 0.6,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Center(
                                child: Text(
                              sPickExamDate,
                              style: kTitleStyle,
                            )),
                            Center(
                              child: FutureBuilder(
                                future: userFuture,
                                builder: (context, snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.none:
                                      return Text('Baglanti hatasi');
                                    case ConnectionState.active:
                                    case ConnectionState.waiting:
                                      return Text('Active and maybe waiting');
                                    case ConnectionState.done:
                                      return SizedBox(
                                          height: height * 0.3,
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
                                                   dateList[index].day.toString() 
                                                   + ' ' 
                                                   + kMonthsList[int.parse(dateList[index].month.toString())] 
                                                   + ' ' + dateList[index].year.toString() 
                                                   + ' ' 
                                                   + dateList[index].hour.toString() 
                                                   + ':' 
                                                   + dateList[index].minute.toString()
                                                   + '0',
                                                   
                                                    style: kSubtitleStyle,
                                                  ),
                                                );
                                              },
                                              itemCount: dateList.length,
                                            ),
                                          ));
                                    default:
                                      return Text('default');
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onPanDown: (_) {
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Center(
                                child: Image(
                                  image: AssetImage(
                                    iNamePlateIcon,
                                  ),
                                  height: height * 0.3,
                                  width: width * 0.6,
                                ),
                              ),
                              SizedBox(height: 15.0),
                              Center(
                                child: Text(
                                  sPickNickName,
                                  style: kTitleStyle,
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              TextField(
                                  controller: _text,
                                  decoration: new InputDecoration(
                                      errorText: _validate ? errorMessage : null,
                                      border: new OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(10.0),
                                        ),
                                      ),
                                      filled: true,
                                      hintStyle:
                                          new TextStyle(color: Colors.grey[800]),
                                      hintText: "Takma ad giriniz",
                                      fillColor: Colors.white70),
                                  onChanged: (value) {
                                    nickName = value;
                                  },
                                ),
                              
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),
                _currentPage != _numPages - 1
                    ? Expanded(
                        child: Align(
                          alignment: FractionalOffset.bottomRight,
                          child: FlatButton(
                            onPressed: () {
                              _pageController.nextPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'İlerle',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 30.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Text(''),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: _currentPage == _numPages - 1
          ? Container(
              height: 100.0,
              width: double.infinity,
              color: Colors.white,
              child: GestureDetector(
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (_text.text.toString() == null ||
                      _text.text.toString() == '') {
                    print(nickName);
                    print(_text.text.toString());
                    errorMessage = 'Lutfen takma ad giriniz.';
                    _text.text.isEmpty ? _validate = true : _validate = false;
                    // GIVE ERROR
                  } else if (_text.text.toString().length > 20) {
                    errorMessage = 'Takma ad 20 harften buyuk olamaz';
                    _validate = true;
                  } else {
                    print(_text.text.toString());
                    await createRecord(
                        nickname: _text.text.toString(),
                        date: dateList[value ?? 0].day.toString() + '|' + dateList[value ?? 0].month.toString() + '|' + dateList[value ?? 0].year.toString() + ' ' + dateList[value ?? 0].hour.toString() + ':' + dateList[value ?? 0].minute.toString() + '0',
                        context: context);
                    print(nickNameUsed);
                    if (nickNameUsed == true) {
                      errorMessage = 'Bu takma ad kullaniliyor. Lutfen baska';
                      _validate = true;
                    } else {
                      _validate = false;
                    }
                  }

                  setState(() {});
                  //print(nickName);
                },
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 30.0),
                    child: Text(
                      'Haydi Başlayalım',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            )
          : Text(''),
    );
  }
}

class OutlandWidget extends StatelessWidget {
  const OutlandWidget(
      {Key key,
      @required this.height,
      @required this.width,
      @required this.title,
      @required this.subtitle})
      : super(key: key);

  final double height;
  final double width;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Image(
              image: AssetImage(iLoadingIcon),
              height: height * 0.3,
              width: width * 0.6,
            ),
          ),
          SizedBox(height: 15.0),
          Text(
            title,
            style: kTitleStyle,
          ),
          SizedBox(height: 15.0),
          Text(
            subtitle,
            style: kSubtitleStyle,
          ),
        ],
      ),
    );
  }
}

Future<void> createRecord({nickname, date, context}) async {
  final FirebaseUser user = await _auth.currentUser();
  final uid = user.uid;
  nickNameUsed = false;
  try {
    await databaseReference
        .collection("users")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        print(f.data);
        if (f.data['nickname'] == nickname) {
          nickNameUsed = true;
        }
      });
      if (nickNameUsed == false) {
        databaseReference.collection("users").document(user.uid).setData({
          'date': date,
          'nickname': nickname,
        });
        print('NICK NAME BOSA GIRDI');
        print(nickname);
        print(user.email);
        Navigator.of(context).pushNamedAndRemoveUntil(
            KronoScreen.id, (r) => true,
            arguments: {user: user, nickname: nickname});
      }
    });
  } catch (e) {}
}

_displaySnackBar(BuildContext context) {
  Scaffold.of(context).removeCurrentSnackBar();
  final snackBar =
      SnackBar(content: Text('Şifreler eşleşmiyor. Lütfen kontrol ediniz.'));
  Scaffold.of(context).showSnackBar(snackBar);
}
