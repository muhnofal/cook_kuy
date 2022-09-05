import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String commentId;
  final String recipeId;
  final DateTime datePublished;
  final String name;
  final String profilePic;
  final String text;
  final String uid;

  Comment(
      {required this.commentId, required this.recipeId, required this.datePublished, required this.name, required this.profilePic, required this.text, required this.uid});

  static Comment fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Comment(
      commentId: snapshot['comment_id'],
      recipeId: snapshot['recipe_id'],
      datePublished: snapshot['date_published'],
      name: snapshot['name'],
      profilePic: snapshot['profile_pic'],
      text: snapshot['text'],
      uid: snapshot['uid']
    );
  }
  Map<String, dynamic> toJson() => {
    'comment_id': commentId,
    'recipe_id': recipeId,
    'date_published': datePublished,
    'name': name,
    'profile_pic': profilePic,
    'text': text,
    'uid': uid
  };

}
