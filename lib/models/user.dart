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

  Future<bool> userExist(String email) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: "jeremy.12@gmail.com", password: "azertyuiop&é\"'(§è!ç)");
      // L'utilisateur a été créé avec succès
      return false;
    } catch (error) {
      if (error is FirebaseAuthException) {
        print(error.code);
        if (error.code == 'user-not-found') {
          return true;
          // L'adresse e-mail est déjà utilisée
        }
        // Vous pouvez également gérer d'autres types d'erreurs ici si nécessaire
      }
    }
    return false;
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
