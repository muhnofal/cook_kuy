import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  final String name;
  final String description;
  final String image;
  final String mainIngre;
  final List<String> like;
  final String recipeId;
  final List<String> additionalIngre;
  final List<Map<String, dynamic>> step;
  final String uid;
  final DateTime datePublished;
  final List<String> favorite;
  final String approvalStatus;

  Recipe({
    required this.name,
    required this.description,
    required this.image,
    required this.mainIngre,
    required this.like,
    required this.recipeId,
    required this.additionalIngre,
    required this.step,
    required this.uid,
    required this.datePublished,
    required this.favorite,
    required this.approvalStatus
  });

  static Recipe fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Recipe(
      name: snapshot['name'],
      description: snapshot['description'],
      image: snapshot['image_url'],
      like: snapshot['like'],
      recipeId: snapshot['recipe_id'],
      step: snapshot['step'],
      mainIngre: snapshot['main_ingredient'],
      additionalIngre: snapshot['ingredients'],
      uid: snapshot['uid'],
      datePublished: snapshot['date_published'],
      favorite: snapshot['favorite'],
      approvalStatus: snapshot['approval_status']
    );
  }

  Map<String, dynamic> toJson() => {
    "description": description,
    "image_url": image,
    "ingredients": additionalIngre,
    "main_ingredient": mainIngre,
    "name": name,
    "like": like,
    "recipe_id": recipeId,
    "step": step,
    "uid": uid,
    "date_published": datePublished,
    "favorite": favorite,
    "approval_status": approvalStatus
  };
}
