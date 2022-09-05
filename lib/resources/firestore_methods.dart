import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cook_kuy/model/comment.dart';
import 'package:cook_kuy/model/recipe.dart';
import 'package:cook_kuy/resources/storage_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future uploadRecipe(String recipeId,
      String recipeName,
      String recipeDescription,
      String mainIngre,
      List<String> additionalIngre,
      String photoUrl,
      List<String> like,
      List<Map<String, dynamic>> step,
      List<String> favorite,
      String uid,
      String approval) async {
    String res = "Some error occurred";
    try {
      Recipe recipe = Recipe(
          recipeId: recipeId,
          uid: uid,
          name: recipeName,
          description: recipeDescription,
          image: photoUrl,
          mainIngre: mainIngre,
          additionalIngre: additionalIngre,
          like: like,
          step: step,
          datePublished: DateTime.now(),
          favorite: favorite,
          approvalStatus: approval);
      _firestore.collection('recipe').doc(recipeId).set(recipe.toJson());
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future uploadToApproval(String recipeName,
      String recipeDescription,
      String mainIngre,
      List<String> additionalIngre,
      Uint8List image,
      List<String> like,
      List<Map<String, dynamic>> step,
      List<String> favorite,
      String uid,
      String approval) async {
    String res = "Some error occurred";
    try {
      String photoUrl = await StorageMethods()
          .uploadImageToStorage('recipeImage', image, true);
      String recipeId = const Uuid().v1();

      //upload Uint8 to storage
      List<Uint8List> stepImageUrl = [];
      List<Map<String, dynamic>> stepByStepConvert = [];

      for (var item in step) {
        stepImageUrl.add(item['image']);
      }
      List<String> imagesUrl = await StorageMethods()
          .uploadMultiImageToStorage('recipeStepByStep', stepImageUrl, true);

      for (var i = 0; i < step.length; i++) {
        step[i]['image'] = imagesUrl[i];
        stepByStepConvert.add(step[i]);
      }

      Recipe recipe = Recipe(
          recipeId: recipeId,
          uid: uid,
          name: recipeName,
          description: recipeDescription,
          image: photoUrl,
          mainIngre: mainIngre,
          additionalIngre: additionalIngre,
          like: like,
          step: stepByStepConvert,
          datePublished: DateTime.now(),
          favorite: favorite,
          approvalStatus: approval);
      _firestore.collection('approval').doc(recipeId).set(recipe.toJson());
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> postComment(String recipeId,
      String text,
      String uid,
      String name,
      String profilPic,
      List likes,
      String notificationType) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        String notificationId = const Uuid().v1();
        _firestore
            .collection('recipe')
            .doc(recipeId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profile_pic': profilPic,
          'name': name,
          'uid': uid,
          'text': text,
          'comment_id': commentId,
          'recipe_id': recipeId,
          'date_published': DateTime.now(),
          'likes': likes
        });
        // _firestore.collection('users').doc(uid).collection('notification').doc(notificationId).set({
        //   'notification_id': notificationId,
        //   'notification'
        // });
      } else {
        print("text is empty");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> likeComment(String recipeId, String commentId, String uid,
      List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore
            .collection('recipe')
            .doc(recipeId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore
            .collection('recipe')
            .doc(recipeId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> likes(String recipeId, String uid, List favorite) async {
    try {
      if (favorite.contains(uid)) {
        await _firestore.collection('recipe').doc(recipeId).update({
          'like': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('recipe').doc(recipeId).update({
          'like': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addFavorite(String recipeId, String uid, List favorite) async {
    try {
      if (favorite.contains(uid)) {
        await _firestore.collection('recipe').doc(recipeId).update({
          'favorite': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('recipe').doc(recipeId).update({
          'favorite': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void sendPushMessage(String token, String username, String uid) async {
    if (token == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }

    try {
      var result = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Authorization':
          "key=AAAAfu5Xu18:APA91bHqBpp7yvho59dOsLzfDRGLrzDkERhuJbU9cAqV1VU6R9D7HS351M6QUfWHRnZKYPeJ63VYLD0Cl0ezIUmwpobeAVgjWs07eCwDWYJJ5M69SpoFBnxF9uSDmiZLU5pf1yvwIh2V",
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          "to": token,
          "collapse_key": "type_a",
          "notification": {
            "body": "$username started to follow you",
            "title": "Someone Following You"
          },
          "data": {
            // "route": "/another_account",
            "anotherUserId": uid,
            "click_action": "/another_account"
          }
        }),
      );
      print('FCM request for device sent! ${result.statusCode}');
    } catch (e) {
      print(e);
    }
  }

  Future<void> followUser(String uid, String anotherUserId,
      String token) async {
    try {
      DocumentSnapshot snap =
      await _firestore.collection('users').doc(uid).get();
      String notificationId = const Uuid().v1();
      // List following = (snap.data()! as dynamic)['following'];

      List following = (snap.data() as dynamic)['following'];

      if (following.contains(anotherUserId)) {
        _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([anotherUserId])
        });
        _firestore.collection('users').doc(anotherUserId).update({
          'followers': FieldValue.arrayRemove([uid])
        });
      } else {
        _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([anotherUserId])
        });
        _firestore.collection('users').doc(anotherUserId).update({
          'followers': FieldValue.arrayUnion([uid])
        });
        _firestore
            .collection('users')
            .doc(anotherUserId)
            .collection('notification')
            .doc(uid)
            .set({
          'notification_id': notificationId,
          'notification_type': 'userFollow',
          'recipe_id': '',
          'uid': uid
        });
        //push notification
        sendPushMessage(token, snap['username'], uid);
      }

      // if (following.contains(followId)) {
      //   await _firestore.collection('users').doc(uid).update({
      //     'followers': FieldValue.arrayRemove([uid])
      //   });
      //   await _firestore.collection('users').doc(uid).update({
      //     'following': FieldValue.arrayRemove([uid])
      //   });
      // }else{

      // }
    } catch (e) {}
  }

  Future editProfile(String uid, String username, String bio,
      Uint8List imageFile) async {
    String res = "Some error occurred";
    try {
      String photoUrl = await StorageMethods()
          .uploadImageToStorage('profilePics', imageFile, false);
      _firestore
          .collection('users')
          .doc(uid)
          .update({'username': username, 'bio': bio, 'photoUrl': photoUrl});
      res = "success";
    } catch (e) {}
    return res;
  }

  Future updateApprovalStatus(String recipeId, String approvalStatus) async {
    String res = "Update error";
    try {
      _firestore
          .collection('approval')
          .doc(recipeId)
          .update({'approval_status': approvalStatus});
      res = "success";
    } catch (e) {
      return res;
    }
  }

  // Future deleteApproval(String recipeId) async {
  //   String res = "delete error";
  //   try {
  //     _firestore.collection('approval').doc(recipeId).delete();
  //     res = "success";
  //   } catch (e) {
  //     return res;
  //   }
  // }

  Future commentReport(String commentId,
      String recipeId,
      String profilePic,
      String name,
      String uid,
      String text,) async {
    String res = "Report error";
    try {
      Comment comment = Comment(commentId: commentId,
          recipeId: recipeId,
          datePublished: DateTime.now(),
          name: name,
          profilePic: profilePic,
          text: text,
          uid: uid);
      _firestore.collection('commentReport').doc(commentId).set(comment.toJson());
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future deleteComment(String recipeId, String commentId) async {
    String res = "delete error";
    try {
      _firestore.collection('commentReport').doc(commentId).delete();
      _firestore.collection('recipe').doc(recipeId).collection('comments').doc(
          commentId).delete();
      res = "success";
    } catch (e) {
      return res;
    }
  }
  Future safeComment(String commentId) async {
    String res = "delete error";
    try {
      _firestore.collection('commentReport').doc(commentId).delete();
      res = "success";
    } catch (e) {
      return res;
    }
  }
}
