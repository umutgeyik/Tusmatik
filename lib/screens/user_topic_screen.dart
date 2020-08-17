import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tusmatik/models/topic.dart';
import 'topic_detail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserTopicDetail extends StatefulWidget {
  static const String id = 'user_topic_screen';
  final String userUid;

  UserTopicDetail({Key key, @required this.userUid}) : super(key: key);
  @override
  _UserTopicDetailState createState() =>
      _UserTopicDetailState(userUid: userUid);
}

class _UserTopicDetailState extends State<UserTopicDetail> {
  final String userUid;
  _UserTopicDetailState({this.userUid});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Stack(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                              icon: Icon(Icons.arrow_back_ios),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              'Konularım',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              ForumList(
                userUid: userUid,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ForumList extends StatefulWidget {
  final String userUid;
  ForumList({Key key, @required this.userUid}) : super(key: key);
  @override
  _ForumListState createState() => _ForumListState(userUid: userUid);
}

class _ForumListState extends State<ForumList> {
  final String userUid;
  _ForumListState({@required this.userUid});

  List<Topic> topics = [];
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
          stream: Firestore.instance
              .collection('topics')
              .where('uid', isEqualTo: userUid)
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      'Hiç aktif değilsiniz.. Hadi canlanın ve bir konu açın.',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                ),
              );
            }

            topics = List<Topic>.from(snapshot.data.documents
                .map((doc) => Topic.fromDocument(doc))
                .toList());

            if (topics.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      'Hiç aktif değilsiniz.. Hadi canlanın ve bir konu açın.',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                ),
              );
            }

            if (snapshot.hasData) {
              return topics.isNotEmpty
                  ? ListView.builder(
                      itemCount: topics.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailScreen(
                                  topicId:
                                      snapshot.data.documents[index].documentID,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            elevation: 8.0,
                            margin: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 6.0),
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
                                          Text(
                                            topics[index]
                                                .comments
                                                .length
                                                .toString(),
                                            style: TextStyle(
                                                color: Colors.lightBlue[400]),
                                          )
                                        ],
                                      ),
                                    ),
                                    title: Text(
                                      topics[index].topicHeader,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                    subtitle: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            SizedBox(
                                              height: 30,
                                            ),
                                            Icon(
                                              Icons.person_outline,
                                              color: Colors.black26,
                                            ),
                                            SizedBox(
                                              width: 3,
                                            ),
                                            Text(topics[index].nickname,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w300)),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            SizedBox(
                                              height: 30,
                                            ),
                                            Icon(
                                              Icons.access_time,
                                              color: Colors.black26,
                                            ),
                                            SizedBox(
                                              width: 3,
                                            ),
                                            Text(
                                                topics[index]
                                                    .timestamp
                                                    .toString()
                                                    .replaceAll('|', '.'),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w300)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    trailing: PopUpMenu(onDelete: () {
                                      setState(() {
                                        Firestore.instance
                                            .collection("topics")
                                            .document(snapshot.data
                                                .documents[index].documentID)
                                            .delete();
                                        topics.removeAt(index);
                                        final snackBar = SnackBar(
                                            content:
                                                Text('Başarıyla silinmiştir.'));
                                        Scaffold.of(context)
                                            .showSnackBar(snackBar);
                                        if (topics.length == 0) {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        }
                                      });
                                    })),
                              ),
                            ),
                          ),
                        );
                      })
                  : Center(child: Text('SA'));
            }
          }),
    );
  }
}

class PopUpMenu extends StatelessWidget {
  VoidCallback onDelete;

  PopUpMenu({this.onDelete});
  void showMenuSelection(String value) {
    switch (value) {
      case 'Sil':
        onDelete();
        break;
      // Other cases for other menu options
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      icon: Icon(Icons.delete_outline),
      onSelected: showMenuSelection,
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
            value: 'Sil',
            child: ListTile(leading: Icon(Icons.delete), title: Text('Sil')))
      ],
    );
  }
}
