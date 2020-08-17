import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:tusmatik/models/comment.dart';
import 'package:intl/intl.dart';

class Topic{
  String nickname;
  String uid;
  String topicHeader;
  String topicDetails;
  String timestamp;
  List<Map<String,dynamic>> comments;

  Topic({this.nickname,this.uid,this.topicHeader,this.topicDetails,this.timestamp,this.comments});

Map<String,dynamic> toJson() =>
{
  'nickname':nickname,
  'uid':uid,
  'topicHeader':topicHeader,
  'topicDetails':topicDetails,
  'timestamp':timestamp,
  'comments':comments,
};

factory Topic.fromDocument(DocumentSnapshot doc) {
  List<Map<String,dynamic>> commentList = [];
  for(int i = 0 ; i< doc['comments'].length; i ++){
    commentList.add(Comment(comment: doc['comments'][i]['comment'],nickname: doc['comments'][i]['nickname'],uid: doc['comments'][i]['uid'],timestamp: DateFormat('d|M|yyyy HH:mm').format(DateTime.now()).toString()).toJson());
  }

  return Topic(
        nickname: doc['nickname'], 
        uid: doc['uid'], 
        topicDetails: doc['topicDetails'],
        topicHeader: doc['topicHeader'],
        timestamp: doc['timestamp'],
        comments: commentList);
}



}