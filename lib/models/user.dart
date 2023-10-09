import 'dart:io';

import 'package:SoundSphere/utils/app_firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:device_info_plus/device_info_plus.dart';

import '../utils/app_utilities.dart';

class User {
  late String? uid;
  late String email;
  late String displayName;
  late bool state; // Connecté ou non

  User({this.uid, required this.email, required this.displayName, this.state = false});

  static CollectionReference<User> collectionRef = AppFirebase.db.collection("users").withConverter(
    fromFirestore: User.fromFirestore,
    toFirestore: (User user, _) => user.toFirestore(),);

  // A modifier niveau gestion des erreurs
  static Future<dynamic> register(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final userCredential = credential.user!;
      final user = User(uid: userCredential.uid, email: email, displayName: 'user_${AppUtilities.getRandomString(10)}');
      await collectionRef.doc(user.uid).set(user);
      return user;
    } on FirebaseAuthException {
      // Utilisateur existe déjà ou format du mail invalide
      return false;
    }
  }

  static Future<dynamic> login(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final userCredential = credential.user!;
      final user = User(uid: userCredential.uid, email: email, displayName: userCredential.displayName!);
      return user;
    } on FirebaseAuthException {
      return false;
    }
  }

  static Future<bool> userExist(String email) async {
    bool connectedToInternet = false;
    try {
      DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      await deviceInfoPlugin.webBrowserInfo;
      connectedToInternet = true;
    } catch (e) {
      final result = await InternetAddress.lookup('8.8.8.8');
      connectedToInternet = result.isNotEmpty&&result[0].rawAddress.isNotEmpty;
    }

    if (!connectedToInternet) {
      throw Exception();
    }

    try {
      final snapshot = await collectionRef.where("email", isEqualTo: email).get();
      return snapshot.docs.isNotEmpty;
    } catch (_) {
      throw Exception();
    }
  }

  static Future<String> getCurrentDisplayName() async {
    try {
      return FirebaseAuth.instance.currentUser!.displayName!;
    } catch (e) {
      return e.toString();
    }
  }

  factory User.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return User(
      email: data?["email"],
      displayName: data?["display_name"]
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "email": email,
      "display_name": displayName,
    };
  }
}