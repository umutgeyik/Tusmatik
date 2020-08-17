class Comment{
  String comment;
  String nickname;
  String uid;
  String timestamp;

  Comment({this.comment,this.nickname,this.uid,this.timestamp});

  Map<String,dynamic> toJson() => {
    'comment':comment,
    'nickname':nickname,
    'uid':uid,
    'timestamp':timestamp,

  };

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(comment: json['comment'] as String, nickname: json['nickname'] as String, uid: json['uid'] as String, timestamp: json['timestamp'] as String);
  }

}