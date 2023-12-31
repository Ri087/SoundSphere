import 'dart:io';

import 'package:SoundSphere/utils/app_firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/app_utilities.dart';

class AppUser {
  late String? uid;
  late String email;
  late String displayName;
  late String photoUrl;

  AppUser({this.uid, required this.email, required this.displayName, this.photoUrl = ""});

  static CollectionReference<AppUser> collectionRef = AppFirebase.database.collection("users").withConverter(
    fromFirestore: AppUser.fromFirestore,
    toFirestore: (AppUser user, _) => user.toFirestore(),);

  static Future<dynamic> register(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final userCredential = credential.user!;
      final user = AppUser(uid: userCredential.uid, email: email, displayName: 'user_${AppUtilities.getRandomString(8)}');
      await userCredential.updateDisplayName(user.displayName);
      await collectionRef.doc(user.uid).set(user);
      return user;
    } on FirebaseAuthException {
      return false;
    }
  }

  static Future<dynamic> login(String email, String password) async {
    email = email.toLowerCase().trim();
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final userCredential = credential.user!;
      final user = AppUser(uid: userCredential.uid, email: email, displayName: userCredential.displayName!);
      return user;
    } on FirebaseAuthException {
      return false;
    }
  }

  static Future<bool> userExist(String email) async {
    // check si connecté à internet
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

  factory AppUser.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return AppUser(
      email: data?["email"],
      displayName: data?["display_name"],
      photoUrl: data?["photo_url"]
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "email": email,
      "display_name": displayName,
      "photo_url": photoUrl,
    };
  }
}