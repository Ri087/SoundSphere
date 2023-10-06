import 'dart:math';

import 'package:SoundSphere/utils/app_firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User {
  late String uid;
  late String mail;
  late String displayName;
  late bool state; // Connecté ou non

  // A modifier niveau gestion des erreurs
  Future<dynamic> register(String emailAddress, String password) async {
    if (!checkPasswordFormat(password)) {
      return null;
    }
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailAddress, password: password);
      final user = credential.user!;
      uid = user.uid;
      mail = user.email!;
      displayName = 'user_${getRandomString(10)}';
      await AppFirebase.db.collection("users").doc(uid).set({
        "email": user.email,
        "username": displayName,
      }).onError((e, _) => print(e));
      return this;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return false;
    }
  }

  Future<dynamic> login(String emailAddress, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
      final user = credential.user!;
      uid = user.uid;
      mail = user.email!;
      displayName = user.displayName!;
      return this;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return false;
    }
  }

  static Future<bool> userExist(String email) async {
    // try {
    //   final method =
    //       // L'adresse e-mail est déjà utilisée
    //       await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
    //   return method.isNotEmpty;
    // } catch (error) {
    //   print("compte inexistant");
    //   return false;

    //   // Vous pouvez également gérer d'autres types d'erreurs ici si nécessaire
    // }
    try {
      final snapshot = await AppFirebase.db
          .collection("users")
          .where("email", isEqualTo: email)
          .get();
      if (snapshot.docs.isEmpty) {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
    ;
    return true;
  }

  Future<bool> signOut() async {
    await FirebaseAuth.instance.signOut();
    state = false;
    return true;
  }

  // Si besoins d'ajouter des règles de vérification de mdp suplémentaires
  bool checkPasswordFormat(String password) {
    return true;
  }
}

String getRandomString(int length) {
  const characters =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random random = Random();
  return String.fromCharCodes(Iterable.generate(
      length, (_) => characters.codeUnitAt(random.nextInt(characters.length))));
}
