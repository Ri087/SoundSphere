import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AppFirebase {
  static FirebaseFirestore database = FirebaseFirestore.instance;

  static FirebaseStorage storage = FirebaseStorage.instance;
  static Reference storageRef = storage.ref();
  static Reference usersImagesRef = storageRef.child("users/images/");
  static Reference musicsStorageRef = storageRef.child("musics/");
}