import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cook_kuy/model/recipe.dart';
import 'package:cook_kuy/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future uploadRecipe(
      String recipeName,
      String recipeDescription,
      String mainIngre,
      List<String> additionalIngre,
      Uint8List image,
      double rating,
      List<Map<String, dynamic>> step,
      String uid) async {
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

      // for (var list in step) {
      //   // for (var imageUrl in imagesUrl) {
      //   //   list['image'] = imageUrl;
      //   //   print("ini image url: $imageUrl");
      //   // }
      //   list['image'] = imagesUrl;
      // }

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
          rating: rating,
          step: stepByStepConvert);
      _firestore.collection('recipe').doc(recipeId).set(recipe.toJson());
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> postComment(String recipeId, String text, String uid,
      String name, String profilPic, List likes) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
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
          'date_published': DateTime.now(),
          'likes': likes
        });
      } else {
        print("text is empty");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> likeComment(
      String recipeId, String commentId, String uid, List likes) async {
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
}
