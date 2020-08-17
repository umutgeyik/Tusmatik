import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import 'package:tusmatik/components/main_drawer.dart';
import 'package:tusmatik/constants.dart';
import 'package:tusmatik/models/topic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tusmatik/screens/topic_detail_screen.dart';
import 'package:tusmatik/models/comment.dart';

List<DateTime> dateList = [];
final databaseReference = Firestore.instance;
final SolidController _controller = SolidController();
double headerHeight = 30;
final _headerController = TextEditingController();
final _descriptionController = TextEditingController();
FirebaseUser myUser;
String myNickname;

class TusBar extends StatefulWidget {
  @override
  _TusBarState createState() => _TusBarState();
}

class _TusBarState extends State<TusBar> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserData();
  }

  _getUserData() async {
    myUser = await FirebaseAuth.instance.currentUser();
    DocumentReference documentReference =
        Firestore.instance.collection("users").document(myUser.uid);
    await documentReference.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        myNickname = datasnapshot.data['nickname'];
        print(myNickname);
      } else {
        myNickname = 'noname';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: Icon(Icons.menu),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      alignment: Alignment.topCenter,
                      child: Text(
                        'Neler Oluyor?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          showFancyCustomDialog(
                              context: context, width: width, height: height);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              ForumList(),
            ],
          ),
        ),
      ),
    );
  }
}

class ForumList extends StatelessWidget {
  const ForumList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
          stream: Firestore.instance.collection('topics').orderBy('timestamp',descending:true).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Text('Loading...');
            }
            if (snapshot.hasData) {
              return ListView(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
                  return InkWell(
                    onTap: () {
                      print(document.documentID);
                      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(topicId: document.documentID,),
          ),
        );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 8.0,
                      margin:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                      child: Container(
                        padding: EdgeInsets.only(left: 12.0),
                        decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0)),
                            color: Colors.white,
                          ),
                          child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              leading: Container(
                                padding: EdgeInsets.only(right: 12.0),
                                decoration: new BoxDecoration(
                                    border: new Border(
                                        right: new BorderSide(
                                            width: 1.0,
                                            color: Colors.blue[200]))),
                                child: Column(
                                  children: <Widget>[
                                    Icon(Icons.question_answer,
                                        color: Colors.blue[300]),
                                        Text(document['comments'].length.toString(),style: TextStyle(
                                          color: Colors.lightBlue[400]
                                        ),)
                                  ],
                                ),
                              ),
                              title: Text(
                                document['topicHeader'],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                              subtitle: Column(
                                children: <Widget>[
                                  Row(
                                    
                                    children: <Widget>[
                                      SizedBox(height: 30,),
                                      Icon(Icons.person_outline,
                                          color: Colors.black26,),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Text(document['nickname'],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w300)),],
                                  ),
                                  
                                  Row(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 30,
                                      ),
                                     
                                      Icon(Icons.access_time,
                                          color: Colors.black26,),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Text(document['timestamp'].toString().replaceAll('|', '.'),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w300)),
                                    
                                      
                                    ],
                                  ),
                                ],
                              ),
                              trailing: Icon(Icons.keyboard_arrow_right,
                                  color: Colors.blue[300], size: 30.0)),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            }
          }),
    );
  }
}

void showFancyCustomDialog(
    {BuildContext context, double width, double height}) {
  bool _validateHeader = false;
  bool _validateDescription = false;
  Dialog fancyDialog = Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: StatefulBuilder(
      builder: (context, setState) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
          ),
          height: height * 0.6,
          width: width * 0.8,
          child: Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: height * 0.8,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Center(
                  child: ListView(
                    children: <Widget>[
                      SizedBox(
                        height: 60,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextField(
                          controller: _headerController,
                          maxLength: 50,
                          decoration: new InputDecoration(
                            errorText: _validateHeader ? 'Konu başlıgı boş bırakılamaz!' : null,
                            labelText: "Konu Başlığı",
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(),
                            ),
                            //fillColor: Colors.green
                          ),
                          keyboardType: TextInputType.text,
                          style: new TextStyle(
                            fontFamily: "Poppins",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextField(
                          controller: _descriptionController,
                          maxLines: 5,
                          decoration: new InputDecoration(
                            errorText: _validateDescription ? 'Açıklama boş bırakılamaz!' : null,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 50.0, horizontal: 8.0),
                            labelText: "Detaylı Açıklama",
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(),
                            ),
                            //fillColor: Colors.green
                          ),
                          keyboardType: TextInputType.emailAddress,
                          style: new TextStyle(
                            fontFamily: "Poppins",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 50,
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  color: Colors.blue[300],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Sende Paylaş!",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: () {
                   
                      setState(() {
                        _headerController.text.isEmpty ? _validateHeader = true : _validateHeader = false;
                        _descriptionController.text.isEmpty ? _validateDescription = true: _validateDescription = false;
                      });
                    if(!_headerController.text.isEmpty && !_descriptionController.text.isEmpty){

                   
                    List<Map<String,dynamic>> list = [];
                    list.add(Comment(comment: _descriptionController.text,timestamp: DateFormat('d|M|yyyy HH:mm').format(DateTime.now()).toString(),nickname: myNickname,uid: myUser.uid).toJson());
                    final topic = Topic(
                        nickname: myNickname,
                        uid: myUser.uid,
                        topicHeader: _headerController.text,
                        topicDetails: _descriptionController.text,
                        timestamp: DateFormat('d|M|yyyy HH:mm').format(DateTime.now()).toString(),
                        comments: list);
                    _saveTopicToDb(topic);
                    _headerController.clear();
                    _descriptionController.clear();
                    Navigator.pop(context);   

                     }
                    
                    
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.blue[500],
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Yayınla",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                // These values are based on trial & error method
                alignment: Alignment(1.05, -1.05),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    ),
  );
  showDialog(context: context, builder: (BuildContext context) => fancyDialog);
}

_saveTopicToDb(Topic topic) async {
  CollectionReference dbReplies = Firestore.instance.collection('topics');
  print('TOPICCC######');
  print(topic.toString());
  Firestore.instance.runTransaction((Transaction tx) async {
    await dbReplies.add(topic.toJson());
  });
}
