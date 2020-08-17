import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tusmatik/models/comment.dart';
import 'package:tusmatik/screens/krono_screen.dart';
import 'package:tusmatik/screens/tus_bar.dart';
import 'package:intl/intl.dart';

class DetailScreen extends StatefulWidget {
  final String topicId;
  DetailScreen({Key key, @required this.topicId}) : super(key: key);
  @override
  _DetailScreenState createState() => _DetailScreenState(topicId: topicId);
}

class _DetailScreenState extends State<DetailScreen> {
  final String topicId;
  _DetailScreenState({this.topicId});

  final databaseReference = Firestore.instance;
  String topicQuestion;
  String commentCount;
  final _commentController = TextEditingController();
  bool _validate = false;
   ScrollController _hideButtonController;
var _isVisible;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _hideButtonController = ScrollController();
    
    _isVisible = true;
      _hideButtonController.addListener((){
        if(_hideButtonController.position.userScrollDirection == ScrollDirection.reverse){
          if(_isVisible == true){
            setState(() {
              _isVisible = false;
            });
          }
        }
        else {
          if(_hideButtonController.position.userScrollDirection == ScrollDirection.forward){
          if(_isVisible == false) {
               setState((){
                 _isVisible = true;
               });
           }
        }
        }
    });
  }

   @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  _getTopicData() async {
    return await databaseReference
        .collection("topics")
        .document(topicId)
        .get().then((DocumentSnapshot snapshot) {
      topicQuestion = snapshot.data['topicHeader'];
      commentCount = snapshot.data['comments'].length.toString();
    });
  }

  _addComment({String comment}) async {
 return await databaseReference.collection("topics").document(topicId).get().then(
      (DocumentSnapshot) {
      List<dynamic> list = DocumentSnapshot.data['comments'];
            list.add(Comment(comment: comment,nickname: myNickname,uid: myUser.uid,timestamp: DateFormat('d|M|yyyy HH:mm').format(DateTime.now()).toString()).toJson());
       
            setState(() {
              commentCount = list.length.toString();
            });

            databaseReference.collection('topics').document(topicId).updateData({'comments': list});
      
      });
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: _getTopicData(),
          builder: (context, snapshot) {
            return SafeArea(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Column(
                      children: <Widget>[
                        new Text(
                          topicQuestion ?? ' ',
                          textScaleFactor: 1.5,
                          style: new TextStyle(fontWeight: FontWeight.bold),
                        ),
                        new Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              new IconWithText(Icons.healing, "Genel"),
                              new IconWithText(
                                  Icons.comment, commentCount ?? '0')
                            ],
                          ),
                        ),
                        new Divider(
                          thickness: 3,
                          color: Colors.lightBlue,
                        )
                      ],
                    ),
                  ),
                  Expanded(
      child: new StreamBuilder(
          stream: Firestore.instance
              .collection('topics')
              .document(topicId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Text('Loading...');
            var userDocument = snapshot.data;
            List<dynamic> list = userDocument['comments'];

            final comments = (userDocument['comments'] as List)
                .map((i) => new Comment.fromJson(i));
            //print(userDocument['comments'].toString());
            return ListView(
              controller: _hideButtonController,
              shrinkWrap: true,
              children: <Widget>[
                for (var comment in comments)
                  Container(
                    margin: const EdgeInsets.all(5.0),
                    decoration: new BoxDecoration(
                      color: Colors.lightBlue[50],
                      borderRadius:
                          const BorderRadius.all(const Radius.circular(20.0)),
                    ),
                    child: new Column(
                      children: <Widget>[
                        new Container(
                          decoration: new BoxDecoration(
                            color: Colors.lightBlue[50],
                            borderRadius: const BorderRadius.only(
                                topLeft: const Radius.circular(20.0),
                                topRight: const Radius.circular(20.0)),
                          ),
                          child: new Row(
                            children: <Widget>[
                              new Icon(
                                Icons.person_outline,
                                size: 35.0,
                                color: Colors.black45,
                              ),
                              new Expanded(
                                child: Text(comment.nickname),
                              ),
                              new Row(
                                children: <Widget>[
                                  new Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: new Icon(Icons.timelapse, size: 20),
                                  ),
                                  new Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8.0, left: 2.0),
                                    child:
                                        new Text(comment.timestamp.toString().replaceAll('|', '.')),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 2.0, right: 2.0, bottom: 2.0),
                          padding: const EdgeInsets.all(8.0),
                          decoration: new BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: const Radius.circular(20.0),
                                  bottomRight: const Radius.circular(20.0))),
                          child: new Text(
                            comment.comment,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          }),
    ),
                ],
              ),
            );
          }),
      floatingActionButton: Visibility(
        visible: _isVisible,
              child: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              isScrollControlled: true,
                context: context,
                builder: (context) => StatefulBuilder(
                  builder: (context, setState) {
                    return Padding(
                    
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Container(
                              height: MediaQuery.of(context).size.height * 0.3,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: ListView(
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Container(
                                        height: 0.15 * MediaQuery.of(context).size.height,
                                        child: TextField(
                                          maxLines: 5,
                                          controller: _commentController,
                                          decoration: InputDecoration(
                                            hintText: "Yorumunuzu buraya yazın...",
                                            fillColor: Colors.grey[300],
                                            filled: true,
                                            errorText: _validate ? 'Yorum boş bırakılamaz!' : null
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: FlatButton(
                                          child: Text(
                                            'Yayınla',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _commentController.text.isEmpty ? _validate = true: _validate = false;
                                            });
                                            if(!_commentController.text.isEmpty){
                                              _addComment(comment: _commentController.text);
                                              _commentController.clear();
                                              Navigator.pop(context);
                                            }
                                            
                                          },
                                          color: Colors.lightBlue,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )),
                        );
                  }
                ));
          },
          backgroundColor: Colors.lightBlueAccent,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}




class IconWithText extends StatelessWidget {
  final IconData iconData;
  final String text;
  final Color iconColor;

  IconWithText(this.iconData, this.text, {this.iconColor});
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Row(
        children: <Widget>[
          new Icon(
            this.iconData,
            color: this.iconColor,
          ),
          new Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: new Text(this.text),
          ),
        ],
      ),
    );
  }
}
